//
//  RootViewModel.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import Foundation
import Combine
import UIKit

struct GeneralResponse: Codable {
    var result: Bool
    
    enum CodingKeys: String, CodingKey {
        case result
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
    }
}

struct RestResult: Equatable {
    var success: Bool = true
    var message: String? = nil
}

enum NetworkError: LocalizedError {
    case responseStatusError(statusCode: Int, message: String)
}

enum MyError: Error {
    case runtimeError(String)
}

class RootViewModel: ObservableObject {
    
    @Published var inProgress: Bool = false
    @Published var restResult: RestResult?
    
    var cancellables = Set<AnyCancellable>()
    
    func getRequest<Item>(url: String, parameters: [String: String] = [:], type: Item.Type = GeneralResponse.self, success: ((Any?) -> Void)?, failure: ((RestError?) -> Void)?) where Item: Decodable {
        self.restRequest(method: "GET", url: url, parameters: parameters, type: type, success: success, failure: failure)
    }
    
    func postRequest<Item>(url: String, parameters: [String: String] = [:], type: Item.Type = GeneralResponse.self, success: ((Any?) -> Void)?, failure: ((RestError?) -> Void)?) where Item: Decodable {
        self.restRequest(method: "POST", url: url, parameters: parameters, type: type, success: success, failure: failure)
    }
    
    func putRequest<Item>(url: String, parameters: [String: String] = [:], type: Item.Type = GeneralResponse.self, success: ((Any?) -> Void)?, failure: ((RestError?) -> Void)?) where Item: Decodable {
        self.restRequest(method: "PUT", url: url, parameters: parameters, type: type, success: success, failure: failure)
    }
    
    func deleteRequest<Item>(url: String, parameters: [String: String] = [:], type: Item.Type = GeneralResponse.self, success: ((Any?) -> Void)?, failure: ((RestError?) -> Void)?) where Item: Decodable {
        self.restRequest(method: "DELETE", url: url, parameters: parameters, type: type, success: success, failure: failure)
    }
    
    func uploadImage<Item>(url: String, parameters: [String: String] = [:], type: Item.Type = GeneralResponse.self, uploadImage: UIImage? = nil, success: ((Any?) -> Void)?, failure: ((RestError?) -> Void)?) where Item: Decodable {
        self.restRequest(method: "POST", url: url, parameters: parameters, type: type, uploadImage: uploadImage, success: success, failure: failure)
    }
    
    func restRequest<Item>(method: String, url: String, parameters: [String: String], type: Item.Type, uploadImage: UIImage? = nil, success: ((Any?) -> Void)?, failure: ((RestError?) -> Void)?) where Item: Decodable {
        
        let urlComp = NSURLComponents(string: url)!
        
        if (method == "GET") {
            var items = [URLQueryItem]()
            for (key, value) in parameters {
                items.append(URLQueryItem(name: key, value: value))
            }
            items = items.filter{!$0.name.isEmpty}
            if !items.isEmpty {
                urlComp.queryItems = items
            }
        }
        
        var request = URLRequest(url: urlComp.url!)
        
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(UIDevice.current.identifierForVendor?.uuidString ?? "Unknown", forHTTPHeaderField: "Device")
        
        if let token = Auth.shared.token {
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        
        if uploadImage != nil {
            guard let image = uploadImage?.fixOrientation() else { return }
            guard let mediaImage = Media(withImage: image, forKey: "picture") else { return }
            let boundary = generateBoundary()
            let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = dataBody
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if (method == "POST" || method == "PUT") {
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .print()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                if let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 {
                    return data
                }
                else if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject],
                        let error = result["error"] as? String {
                    throw NetworkError.responseStatusError(statusCode: statusCode, message: error)
                }
                else {
                    throw NetworkError.responseStatusError(statusCode: statusCode, message: "Neznáma chyba")
                }
            }
            .decode(type: type, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let error = error as? NetworkError {
                        switch error {
                        case .responseStatusError(let statusCode, let message):
                            failure?(RestError(statusCode: statusCode, message: message))
                        }
                    }
                    else {
                        failure?(RestError(statusCode: -1, message: error.localizedDescription))
                    }
                }
            } receiveValue: { returnedValue in
                success?(returnedValue)
            }
            .store(in: &cancellables)
    }
    
    // https://stackoverflow.com/questions/58235857/how-to-upload-image-file-using-codable-and-urlsession-shared-uploadtask-multipa
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }

        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"

        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}

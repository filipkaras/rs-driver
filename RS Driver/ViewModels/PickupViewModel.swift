//
//  PickupViewModel.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation

class PickupViewModel: RootViewModel, Pageable {
    
    typealias Value = PickupModel
    typealias ResultData = (items: [PickupModel], info: PageInfo)
    var listType: String
    
    init(listType: String = "") {
        self.listType = listType
    }
    
    func loadPage(after currentPage: PageInfo, size: Int) async throws -> ResultData {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<ResultData, Error>) in
            getRequest(url: K.Api.Url + "/pickups/" + listType, parameters: [:], type: PickupModelWrapper.self) { wrapper in
                if let wrapper = wrapper as? PickupModelWrapper,
                   wrapper.result == true {
                    continuation.resume(returning: (items: wrapper.data, info: PageInfo(hasNextPage: false, pageNumber: currentPage.pageNumber + 1)))
                } else {
                    continuation.resume(throwing: MyError.runtimeError("Neznáma chyba"))
                }
            } failure: { error in
                continuation.resume(throwing: MyError.runtimeError(error?.message ?? "Neznáma chyba"))
            }
        })
    }
    
    func acceptPickup(idPickup: Int, success: (() -> Void)? = nil, failure: ((RestError?) -> Void)? = nil) {
        inProgress = true
        putRequest(url: K.Api.Url + "/pickups/accept/" + String(idPickup), parameters: [:], type: GeneralResponse.self) { result in
            if let result = result as? GeneralResponse, result.result == true {
                success?()
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        } failure: { error in
            failure?(error)
            self.inProgress = false
        }
    }
    
    func rejectPickup(idPickup: Int, success: (() -> Void)? = nil, failure: ((RestError?) -> Void)? = nil) {
        inProgress = true
        putRequest(url: K.Api.Url + "/pickups/reject/" + String(idPickup), parameters: [:], type: GeneralResponse.self) { result in
            if let result = result as? GeneralResponse, result.result == true {
                success?()
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        } failure: { error in
            if let error = error {
                failure?(error)
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        }
    }
    
    func cancelPickup(idPickup: Int, success: (() -> Void)? = nil, failure: ((RestError?) -> Void)? = nil) {
        inProgress = true
        putRequest(url: K.Api.Url + "/pickups/cancel/" + String(idPickup), parameters: [:], type: GeneralResponse.self) { result in
            if let result = result as? GeneralResponse, result.result == true {
                success?()
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        } failure: { error in
            if let error = error {
                failure?(error)
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        }
    }
    
    func goPickupAddress(idPickup: Int, idAddress: Int, success: (() -> Void)? = nil, failure: ((RestError?) -> Void)? = nil) {
        inProgress = true
        putRequest(url: K.Api.Url + "/pickups/go/" + String(idPickup) + "/" + String(idAddress), parameters: [:], type: GeneralResponse.self) { result in
            if let result = result as? GeneralResponse, result.result == true {
                success?()
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        } failure: { error in
            if let error = error {
                failure?(error)
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        }
    }
    
    func completePickupAddress(idPickup: Int, idAddress: Int, success: (() -> Void)? = nil, failure: ((RestError?) -> Void)? = nil) {
        inProgress = true
        putRequest(url: K.Api.Url + "/pickups/complete/" + String(idPickup) + "/" + String(idAddress), parameters: [:], type: GeneralResponse.self) { result in
            if let result = result as? GeneralResponse, result.result == true {
                success?()
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        } failure: { error in
            if let error = error {
                failure?(error)
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        }
    }
    
    func returnPickupAddress(idPickup: Int, idAddress: Int, success: (() -> Void)? = nil, failure: ((RestError?) -> Void)? = nil) {
        inProgress = true
        putRequest(url: K.Api.Url + "/pickups/return/" + String(idPickup) + "/" + String(idAddress), parameters: [:], type: GeneralResponse.self) { result in
            if let result = result as? GeneralResponse, result.result == true {
                success?()
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        } failure: { error in
            if let error = error {
                failure?(error)
            } else {
                failure?(RestError())
            }
            self.inProgress = false
        }
    }
}

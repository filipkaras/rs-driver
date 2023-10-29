//
//  CmsViewModel.swift
//  RS Driver
//
//  Created by Filip Karas on 26/04/2023.
//

import Foundation
import Combine

class CmsViewModel: RootViewModel {
    
    @Published private(set) var cms = CmsModel()
    
    func getCms(idCms: Int) {
        inProgress = true
        getRequest(url: K.Api.Url + "/cms/detail/" + String(idCms), type: CmsResponse.self) { result in
            self.inProgress = false
            if let result = result as? CmsResponse, result.result == true, let cms = result.data {
                self.cms = cms
            } else {
                self.restResult = RestResult(success: false, message: "Neznáma chyba")
            }
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
}

struct CmsResponse: Codable {
    
    var result: Bool
    var data: CmsModel?
    
    enum CodingKeys: String, CodingKey {
        case result
        case data
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        data = try container.decodeIfPresent(CmsModel.self, forKey: .data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(data, forKey: .data)
    }
}

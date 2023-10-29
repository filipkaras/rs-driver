//
//  BranchViewModel.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation

class BranchViewModel: RootViewModel, Pageable {
    
    @Published var message: String = ""
    
    typealias Value = BranchModel
    typealias ResultData = (items: [BranchModel], info: PageInfo)
    
    func loadPage(after currentPage: PageInfo, size: Int) async throws -> ResultData {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<ResultData, Error>) in
            var parameters: [String: String] = ["page": String(currentPage.pageNumber)]
            if let location = LocationManager.shared.lastLocation {
                parameters["lat"] = String(location.coordinate.latitude)
                parameters["lon"] = String(location.coordinate.longitude)
            }
            getRequest(url: K.Api.Url + "/branches/list", parameters: parameters, type: BranchModelWrapper.self) { wrapper in
                if let wrapper = wrapper as? BranchModelWrapper,
                   wrapper.result == true {
                    let hasNextPage = wrapper.data.count > 0
                    continuation.resume(returning: (items: wrapper.data, info: PageInfo(hasNextPage: hasNextPage, pageNumber: currentPage.pageNumber + 1)))
                } else {
                    continuation.resume(throwing: MyError.runtimeError("Neznáma chyba"))
                }
            } failure: { error in
                continuation.resume(throwing: MyError.runtimeError(error?.message ?? "Neznáma chyba"))
            }
        })
    }
    
    func setStatus(idBranch: Int, status: Bool) {
        inProgress = true
        putRequest(url: K.Api.Url + "/branches/active_status/" + String(idBranch) + "/" + (status ? "1" : "0"), parameters: [:], type: GeneralResponse.self) { result in
            if let result = result as? GeneralResponse, result.result == true {
                self.restResult = RestResult(success: true, message: status ? "Aktivácia prebehla úspešne" : "Deaktivácia prebehla úspešne")
            } else {
                self.restResult = RestResult(success: false, message: "Neznáma chyba")
            }
            self.inProgress = false
        } failure: { error in
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
            self.inProgress = false
        }
    }
    
    func request(idBranch: Int) {
        let url = K.Api.Url + "/branches/request"
        let parameters: [String: String] = [
            "branch_id": String(idBranch),
            "message": message
        ]
        
        inProgress = true
        postRequest(url: url, parameters: parameters, type: GeneralResponse.self) { result in
            self.inProgress = false
            self.restResult = RestResult(success: true, message: "Správa úspešne odoslaná.")
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
}

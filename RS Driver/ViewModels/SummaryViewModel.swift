//
//  SummaryViewModel.swift
//  RS Driver
//
//  Created by Filip Karas on 31/03/2023.
//

import Foundation

class SummaryViewModel: RootViewModel {
    
    @Published private(set) var summary = SummaryModelWrapper()
    
    func getSummary(date: Date) {
        self.inProgress = true
        let dateString = date.dateString(dateFormat: "yyyy-MM-dd")!
        getRequest(url: K.Api.Url + "/summary/branches/" + dateString, parameters: [:], type: SummaryModelWrapper.self) { wrapper in
            self.inProgress = false
            if let wrapper = wrapper as? SummaryModelWrapper,
               wrapper.result == true {
                self.summary = wrapper
            } else {
                self.restResult = RestResult(success: false, message: "Neznáma chyba")
            }
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
    
    override init() {}
    
    init(demoItem: SummaryModelWrapper) {
        self.summary = demoItem
    }
}

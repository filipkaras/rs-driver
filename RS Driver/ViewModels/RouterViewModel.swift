//
//  RouterViewModel.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import SwiftUI

enum Page {
    case login
    case root
}

struct ToastMessage {
    var message: String = ""
    var success: Bool = true
    var dismissCallback: (() -> Void)?
}

class RouterViewModel: ObservableObject {
    
    @Published var currentPage: Page
    @Published var tabSelection = 1
    @Published var loggedIn: Bool = false
    
    @Published var badgeChallenge: Int = 0
    @Published var badgePickup: Int = 0
    
    @Published var segueToRegister: Bool = false
    @Published var segueToForgotPassword: Bool = false
    @Published var segueToSettings: Bool = false
    @Published var segueToCmsAbout: Bool = false
    @Published var segueToCmsTerms: Bool = false
    @Published var segueToCmsPrivacy: Bool = false
    @Published var segueToMapApplication: Bool = false
    @Published var segueToProfile: Bool = false
    @Published var segueToBranchRequest: Bool = false
    
    @Published var showLoadingIndicator: Bool = false
    @Published var showToast: Bool = false
    @Published var toastMessage: ToastMessage? {
        didSet {
            if toastMessage != nil {
                showToast = true
            }
        }
    }
    
    init() {
        loggedIn = Auth.shared.loggedIn
        currentPage = .root
    }
    
    public func route() {
        loggedIn = Auth.shared.loggedIn
        if loggedIn {
            currentPage = .root
        }
    }
    
    public func showToast(_ restResult: RestResult?, dismissCallback: (() -> Void)? = nil) {
        if let value = restResult, let message = value.message {
            toastMessage = ToastMessage(message: message, success: value.success, dismissCallback: dismissCallback)
        }
    }
    
    public func showToast(_ message: String, success: Bool = true, dismissCallback: (() -> Void)? = nil) {
        toastMessage = ToastMessage(message: message, success: success, dismissCallback: dismissCallback)
    }
}

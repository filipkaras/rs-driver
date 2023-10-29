//
//  AccountViewModel.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import Foundation
import Combine
import FirebaseMessaging
import UIKit

class AccountViewModel: RootViewModel {
    
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var phoneNumber: String = ""
    @Published var ico: String = ""
    @Published var dic: String = ""
    @Published var icDph: String = ""
    @Published var company: String = ""
    @Published var address: String = ""
    @Published var country: String = ""
    @Published var terms: Bool = false
    @Published var privacy: Bool = false
    
    override init() {
        guard let user = Auth.shared.user else { return }
        email = user.email
        name = user.name
        phoneNumber = user.phoneNumber
        ico = user.ico
        dic = user.dic
        icDph = user.icDph
        company = user.company
        address = user.address
        country = user.country
    }
    
    func login() {
        
        let parameters = [
            "external_account_email": self.email,
            "external_account_password": self.password
        ];
        
        inProgress = true
        postRequest(url: K.Api.Url + "/account/login", parameters: parameters, type: LoginResponse.self) { result in
            self.inProgress = false
            if let result = result as? LoginResponse {
                Auth.shared.token = result.token
                Auth.shared.user = result.user
                if let firebaseToken = Messaging.messaging().fcmToken {
                    self.updateFirebaseToken(firebaseToken)
                }
                self.restResult = RestResult(success: true, message: "Boli ste úspešne prihlásený.")
            } else {
                self.restResult = RestResult(success: false, message: "Neznáma chyba")
            }
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
    
    func getProfile() {
        
        getRequest(url: K.Api.Url + "/account/detail", type: LoginResponse.self) { result in
            self.inProgress = false
            if let result = result as? LoginResponse {
                Auth.shared.user = result.user
            }
        } failure: { error in }
    }
    
    func register() {
        
        let parameters = [
            "external_account_email": self.email,
            "external_account_name": self.name,
            "external_account_password": self.password,
            "external_account_phone_number": self.phoneNumber,
            "external_account_inv_ico": self.ico
        ];
        
        inProgress = true
        postRequest(url: K.Api.Url + "/account/register", parameters: parameters) { result in
            self.inProgress = false
            self.restResult = RestResult(success: true, message: "Úspešne ste sa zaregistrovali. Aktivujte prosím svoj účet pomocou aktivačného emailu, ktorý sme vám odoslali.")
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
    
    func updateProfile() {
        
        let parameters = [
            "external_account_name": name,
            "external_account_phone_number": phoneNumber,
            "external_account_inv_ico": ico,
            "external_account_inv_dic": dic,
            "external_account_inv_icdph": icDph,
            "external_account_inv_street": address,
            "external_account_inv_country": country,
            "external_account_inv_name": company,
        ]
        
        inProgress = true
        putRequest(url: K.Api.Url + "/account/profile", parameters: parameters, type: LoginResponse.self) { result in
            self.inProgress = false
            self.restResult = RestResult(success: true, message: "Profil bol úspešne aktualizovaný.")
            self.getProfile()
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
    
    func deleteAccount() {
        
        inProgress = true
        deleteRequest(url: K.Api.Url + "/account/remove") { result in
            self.inProgress = false
            if let result = result as? GeneralResponse, result.result == true {
                self.restResult = RestResult(success: true, message: "Boli ste úspešne prihlásený.")
            } else {
                self.restResult = RestResult(success: false, message: "Neznáma chyba")
            }
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
    
    func uploadProfilePhoto(image: UIImage) {
        
        inProgress = true
        uploadImage(url: K.Api.Url + "/account/photo", uploadImage: image) { result in
            self.inProgress = false
            if let result = result as? GeneralResponse, result.result == true {
                self.restResult = RestResult(success: true)
            } else {
                self.restResult = RestResult(success: false, message: "Neznáma chyba")
            }
            self.getProfile()
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
    
    func resetPassword() {
        
        let parameters = [
            "external_account_email": email
        ]
        
        inProgress = true
        putRequest(url: K.Api.Url + "/account/reset_password", parameters: parameters, type: GeneralResponse.self) { result in
            self.inProgress = false
            self.restResult = RestResult(success: true, message: "Poslali sme vám e-mail s pokynmi pre obnovenie vášho hesla.")
        } failure: { error in
            self.inProgress = false
            self.restResult = RestResult(success: false, message: error?.message ?? "Neznáma chyba")
        }
    }
    
    func updateFirebaseToken(_ token: String) {
        
        let parameters = [
            "external_account_firebase_token": token,
        ];
        
        putRequest(url: K.Api.Url + "/account/firebase_token", parameters: parameters, type: GeneralResponse.self, success: nil, failure: nil)
    }
}

struct LoginResponse: Codable {
    
    var result: Bool
    var token: String
    var user: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case result
        case token
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        token = try container.decodeIfPresent(String.self, forKey: .token) ?? ""
        user = try container.decodeIfPresent(UserModel.self, forKey: .data)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(token, forKey: .token)
        try container.encode(user, forKey: .data)
    }
}

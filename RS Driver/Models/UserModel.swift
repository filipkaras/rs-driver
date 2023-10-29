//
//  RegisterModel.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import Foundation

struct UserModel: Identifiable, Codable {
    
    var id: Int
    var name: String
    var email: String
    var phoneNumber: String
    var company: String
    var ico: String
    var dic: String
    var icDph: String
    var address: String
    var country: String
    var photoPath: String?
    var photo: String? {
        guard let path = photoPath else { return nil }
        return K.Api.DataUrl + path.replacingOccurrences(of: "[size]", with: "small")
    }
    
    enum CodingKeys: String, CodingKey {
        case external_account_id
        case external_account_name
        case external_account_email
        case external_account_phone_number
        case external_account_inv_ico
        case external_account_inv_street
        case external_account_inv_country
        case external_account_inv_name
        case external_account_inv_dic
        case external_account_inv_icdph
        case external_account_photo
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .external_account_id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .external_account_name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .external_account_email) ?? ""
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .external_account_phone_number) ?? ""
        ico = try container.decodeIfPresent(String.self, forKey: .external_account_inv_ico) ?? ""
        address = try container.decodeIfPresent(String.self, forKey: .external_account_inv_street) ?? ""
        country = try container.decodeIfPresent(String.self, forKey: .external_account_inv_country) ?? ""
        company = try container.decodeIfPresent(String.self, forKey: .external_account_inv_name) ?? ""
        dic = try container.decodeIfPresent(String.self, forKey: .external_account_inv_dic) ?? ""
        icDph = try container.decodeIfPresent(String.self, forKey: .external_account_inv_icdph) ?? ""
        photoPath = try container.decodeIfPresent(String.self, forKey: .external_account_photo) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .external_account_id)
        try container.encode(name, forKey: .external_account_name)
        try container.encode(email, forKey: .external_account_email)
        try container.encode(phoneNumber, forKey: .external_account_phone_number)
        try container.encode(ico, forKey: .external_account_inv_ico)
        try container.encode(address, forKey: .external_account_inv_street)
        try container.encode(country, forKey: .external_account_inv_country)
        try container.encode(company, forKey: .external_account_inv_name)
        try container.encode(dic, forKey: .external_account_inv_dic)
        try container.encode(icDph, forKey: .external_account_inv_icdph)
        try container.encode(photoPath, forKey: .external_account_photo)
    }
}

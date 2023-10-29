//
//  BranchModel.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation

struct BranchModelWrapper: Codable, Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var result: Bool
    var data: [BranchModel] = []
    
    enum CodingKeys: String, CodingKey {
        case result
        case data
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        data = try container.decodeIfPresent([BranchModel].self, forKey: .data) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(data, forKey: .data)
    }
}

struct BranchModel: Codable, Identifiable, Hashable {
    
    var id: Int = 0
    var name: String = ""
    var desc: String = ""
    var address: String = ""
    var contact: String = ""
    var email: String = ""
    var distance: Double = 0.0
    var defaultPriceBase: Double = 0.0
    var defaultPriceDistance: Double = 0.0
    var myBranch: Bool = false
    var iAmActive: Bool = false
    var phoneUrl: URL? {
        if let phone = self.contact.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
           let phone = URL(string: "telprompt://\(phone)") {
            return phone
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case branch_id
        case branch_name
        case branch_description
        case branch_address
        case branch_contact
        case branch_email
        case branch_distance
        case branch_default_price_per_base
        case branch_default_price_per_km
        case my_branch
        case i_am_active
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .branch_id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .branch_name) ?? ""
        desc = try container.decodeIfPresent(String.self, forKey: .branch_description) ?? ""
        address = try container.decodeIfPresent(String.self, forKey: .branch_address) ?? ""
        contact = try container.decodeIfPresent(String.self, forKey: .branch_contact) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .branch_email) ?? ""
        distance = try container.decodeIfPresent(Double.self, forKey: .branch_distance) ?? 0.0
        defaultPriceBase = try container.decodeIfPresent(Double.self, forKey: .branch_default_price_per_base) ?? 0.0
        defaultPriceDistance = try container.decodeIfPresent(Double.self, forKey: .branch_default_price_per_km) ?? 0.0
        myBranch = try container.decodeIfPresent(Int.self, forKey: .my_branch) == 1 ? true : false
        iAmActive = try container.decodeIfPresent(Int.self, forKey: .i_am_active) == 1 ? true : false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .branch_id)
        try container.encode(name, forKey: .branch_name)
        try container.encode(desc, forKey: .branch_description)
        try container.encode(address, forKey: .branch_address)
        try container.encode(contact, forKey: .branch_contact)
        try container.encode(email, forKey: .branch_email)
        try container.encode(distance, forKey: .branch_distance)
        try container.encode(defaultPriceBase, forKey: .branch_default_price_per_base)
        try container.encode(defaultPriceDistance, forKey: .branch_default_price_per_km)
        try container.encode(myBranch ? 1 : 0, forKey: .my_branch)
        try container.encode(iAmActive ? 1 : 0, forKey: .i_am_active)
    }
    
    init(id: Int, name: String, desc: String, address: String = "", contact: String = "", distance: Double = 0.0) {
        self.id = id
        self.name = name
        self.desc = desc
        self.contact = contact
        self.address = address
        self.distance = distance
    }
}

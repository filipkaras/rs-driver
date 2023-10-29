//
//  PickupModel.swift
//  RS Driver
//
//  Created by Filip Karas on 26/03/2023.
//

import Foundation
import SwiftUI

struct PickupModelWrapper: Codable, Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var result: Bool
    var data: [PickupModel] = []
    
    enum CodingKeys: String, CodingKey {
        case result
        case data
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        data = try container.decodeIfPresent([PickupModel].self, forKey: .data) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(data, forKey: .data)
    }
}

struct PickupModel: Codable, Identifiable, Hashable {
    
    var id: Int = 0
    var idBranch: Int = 0
    var distance: Int = 0
    var deliveryPrice: Double = 0
    var date: Date = Date()
    var pickupPrice: Double = 0
    var note: String = ""
    var addresses: [PickupAddressModel] = []
    var status: PickupStatusModel?
    var challengeDeletedInt: Int = 0
    var challengeDeleted: Bool {
        return challengeDeletedInt == 1
    }
    var branch: BranchModel?
    
    enum CodingKeys: String, CodingKey {
        case pickup_id
        case pickup_id_branch
        case pickup_distance
        case pickup_delivery_price
        case pickup_arrival_currier_date
        case pickup_price
        case pickup_branch_note
        case addresses
        case pickup_status
        case pickup_challenge_deleted
        case branch
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .pickup_id) ?? 0
        idBranch = try container.decodeIfPresent(Int.self, forKey: .pickup_id_branch) ?? 0
        distance = try container.decodeIfPresent(Int.self, forKey: .pickup_distance) ?? 0
        deliveryPrice = try container.decodeIfPresent(Double.self, forKey: .pickup_delivery_price) ?? 0
        pickupPrice = try container.decodeIfPresent(Double.self, forKey: .pickup_price) ?? 0
        note = try container.decodeIfPresent(String.self, forKey: .pickup_branch_note) ?? ""
        addresses = try container.decodeIfPresent([PickupAddressModel].self, forKey: .addresses) ?? []
        status = try container.decodeIfPresent(PickupStatusModel.self, forKey: .pickup_status)
        challengeDeletedInt = try container.decodeIfPresent(Int.self, forKey: .pickup_challenge_deleted) ?? 0
        branch = try container.decodeIfPresent(BranchModel.self, forKey: .branch)
        
        if let date = try container.decodeIfPresent(String.self, forKey: .pickup_arrival_currier_date) {
            self.date = date.toDateTime(dateFormat: "yyyy-MM-dd HH:mm:ss") ?? Date()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .pickup_id)
        try container.encode(idBranch, forKey: .pickup_id_branch)
        try container.encode(distance, forKey: .pickup_distance)
        try container.encode(deliveryPrice, forKey: .pickup_delivery_price)
        try container.encode(pickupPrice, forKey: .pickup_price)
        try container.encode(note, forKey: .pickup_branch_note)
        try container.encode(addresses, forKey: .addresses)
        try container.encode(status, forKey: .pickup_status)
        try container.encode(challengeDeletedInt, forKey: .pickup_challenge_deleted)
        try container.encode(date, forKey: .pickup_arrival_currier_date)
    }
    
    init(id: Int, distance: Int, deliveryPrice: Double, date: Date, pickupPrice: Double, addresses: [PickupAddressModel], status: PickupStatusModel, branch: BranchModel) {
        self.id = id
        self.distance = distance
        self.deliveryPrice = deliveryPrice
        self.date = date
        self.pickupPrice = pickupPrice
        self.addresses = addresses
        self.status = status
        self.branch = branch
    }
}

struct PickupAddressModel: Codable, Identifiable, Hashable {
    
    var id: Int = 0
    var idOrder: String = ""
    var idOrderMinor: String {
        //String(idOrder.prefix(idOrder.count - 2))
        return ""
    }
    var idOrderMajor: String {
        String(idOrder.suffix(2))
    }
    var name: String = ""
    var value: String = ""
    var phone: String = ""
    var note: String = ""
    var payment: String = ""
    var products: String = ""
    var paymentColor: Color {
        if payment == "Hotovosť" { return Color.paymentCash }
        if payment == "Cardpay online" { return Color.paymentCardpay }
        if payment == "Terminál na prevádzke" { return Color.paymentCard }
        return Color.primary100
    }
    var price: Double = 0
    var status: PickupAddressStatusModel?
    var idStatus: Int {
        return status?.id ?? 0
    }
    var isActive: Bool {
        return [0, 1].contains(idStatus)
    }
    var phoneUrl: URL? {
        return URL(string: "telprompt://\(phone)")
    }
    
    enum CodingKeys: String, CodingKey {
        case pickup_address_id
        case pickup_address_id_order
        case pickup_address_name
        case pickup_address_value
        case pickup_address_phone
        case pickup_address_note
        case pickup_address_payment
        case pickup_address_price
        case pickup_address_status
        case pickup_address_products
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .pickup_address_id) ?? 0
        idOrder = try container.decodeIfPresent(String.self, forKey: .pickup_address_id_order) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .pickup_address_name) ?? ""
        value = try container.decodeIfPresent(String.self, forKey: .pickup_address_value) ?? ""
        phone = try container.decodeIfPresent(String.self, forKey: .pickup_address_phone) ?? ""
        note = try container.decodeIfPresent(String.self, forKey: .pickup_address_note) ?? ""
        payment = try container.decodeIfPresent(String.self, forKey: .pickup_address_payment) ?? ""
        price = try container.decodeIfPresent(Double.self, forKey: .pickup_address_price) ?? 0
        status = try container.decodeIfPresent(PickupAddressStatusModel.self, forKey: .pickup_address_status)
        products = try container.decodeIfPresent(String.self, forKey: .pickup_address_products) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .pickup_address_id)
        try container.encode(idOrder, forKey: .pickup_address_id_order)
        try container.encode(name, forKey: .pickup_address_name)
        try container.encode(value, forKey: .pickup_address_value)
        try container.encode(phone, forKey: .pickup_address_phone)
        try container.encode(note, forKey: .pickup_address_note)
        try container.encode(payment, forKey: .pickup_address_payment)
        try container.encode(price, forKey: .pickup_address_price)
        try container.encode(status, forKey: .pickup_address_status)
        try container.encode(products, forKey: .pickup_address_products)
    }
    
    init(id: Int, idOrder: String, name: String, value: String, phone: String, note: String, payment: String, price: Double, status: PickupAddressStatusModel) {
        self.id = id
        self.idOrder = idOrder
        self.name = name
        self.value = value
        self.phone = phone
        self.note = note
        self.payment = payment
        self.price = price
        self.status = status
    }
}

struct PickupAddressStatusModel: Codable, Identifiable, Hashable {
    
    var id: Int
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case pickup_address_status_id
        case pickup_address_status_title
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .pickup_address_status_id) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .pickup_address_status_title) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .pickup_address_status_id)
        try container.encode(title, forKey: .pickup_address_status_title)
    }
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}

struct PickupStatusModel: Codable, Identifiable, Hashable {
    
    var id: Int
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case pickup_status_id
        case pickup_status_title
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .pickup_status_id) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .pickup_status_title) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .pickup_status_id)
        try container.encode(title, forKey: .pickup_status_title)
    }
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}

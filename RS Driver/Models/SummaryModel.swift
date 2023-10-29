//
//  SummaryModel.swift
//  RS Driver
//
//  Created by Filip Karas on 31/03/2023.
//

import Foundation

struct SummaryModelWrapper: Codable, Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var result: Bool = false
    var total: Double = 0
    var data: [SummaryModel] = []
    
    enum CodingKeys: String, CodingKey {
        case result
        case total
        case data
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decodeIfPresent(Bool.self, forKey: .result) ?? false
        total = try container.decodeIfPresent(Double.self, forKey: .total) ?? 0
        data = try container.decodeIfPresent([SummaryModel].self, forKey: .data) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(total, forKey: .total)
        try container.encode(data, forKey: .data)
    }
    
    init(result: Bool, total: Double, data: [SummaryModel]) {
        self.result = result
        self.total = total
        self.data = data
    }
    
    init() {}
}

struct SummaryModel: Codable, Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var branch: BranchModel?
    var pickups: [PickupModel] = []
    var total: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case branch
        case pickups
        case total_in_branch
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        branch = try container.decodeIfPresent(BranchModel.self, forKey: .branch)
        pickups = try container.decodeIfPresent([PickupModel].self, forKey: .pickups) ?? []
        total = try container.decodeIfPresent(Double.self, forKey: .total_in_branch) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(branch, forKey: .branch)
        try container.encode(pickups, forKey: .pickups)
        try container.encode(total, forKey: .total_in_branch)
    }
    
    init(branch: BranchModel, pickups: [PickupModel], total: Double) {
        self.branch = branch
        self.pickups = pickups
        self.total = total
    }
}

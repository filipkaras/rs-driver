//
//  CmsModel.swift
//  RS Driver
//
//  Created by Filip Karas on 26/04/2023.
//

import Foundation

struct CmsModel: Identifiable, Codable {
    
    var id: Int = 0
    var title: String = ""
    var content: String = ""
    
    enum CodingKeys: String, CodingKey {
        case cms_id
        case cms_title
        case cms_content
     }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .cms_id) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .cms_title) ?? ""
        content = try container.decodeIfPresent(String.self, forKey: .cms_content) ?? ""
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .cms_id)
        try container.encode(title, forKey: .cms_title)
        try container.encode(content, forKey: .cms_content)
    }
    
    init() {}
}

//
//  Facts.swift
//  CycloidTest
//
//  Created by abc on 07/04/20.
//  Copyright © 2020 abc. All rights reserved.
//

import Foundation

struct Facts:Codable {
    let title: String
    let rows: [Row]
    
    enum CodingKeys: String, CodingKey{
        case title
        case rows
    }
}
struct Row:Codable {
    var title: String?
    var description: String?
    var imageHref: String?
    
    enum CodingKeys: String, CodingKey{
        case title
        case description
        case imageHref
    }
}


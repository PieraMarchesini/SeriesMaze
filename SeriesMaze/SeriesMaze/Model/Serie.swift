//
//  Serie.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 06/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import Foundation

struct Serie: Decodable {
    let score: Float
    let show: Show
    
    struct Show: Decodable {
        let id: Int
        let name: String
        let genres: [String]
        let premiered: String?
        let image: Image?
        let summary: String?
    }
    
    struct Image: Decodable {
        let medium: String
        let original: String
    }
    
}



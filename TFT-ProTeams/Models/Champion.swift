//
//  Champion.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 19/12/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation

struct Champion : Decodable {
    let champion: String
    let cost: Int
    let traits: [String]
}

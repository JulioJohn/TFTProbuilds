//
//  PlayerDetails.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 15/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation

struct PlayerDetails {
    var name: String
    var puuid: String
    var matchs: [MatchDetails]?
    
    init(name: String, puuid: String, matchs: [MatchDetails]) {
        self.name = name
        self.puuid = puuid
        self.matchs = matchs
    }
    
    init() {
        self.name = "Not initialized"
        self.puuid = "Not initialized"
        self.matchs = []
    }
}

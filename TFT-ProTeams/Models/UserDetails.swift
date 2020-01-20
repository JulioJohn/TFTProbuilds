//
//  UserDetails.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 25/12/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation

struct UserDetails: Decodable {
    var profileIconId: Int
    var name: String
    var puuid: String
    var summonerLevel: Int
    var accountId: String
    var id: String
    var revisionDate: Int
    
    func printUserDetails() {
        print(profileIconId)
        print(name)
        print(puuid)
        print(summonerLevel)
        print(accountId)
        print(id)
        print(revisionDate)
    }
}

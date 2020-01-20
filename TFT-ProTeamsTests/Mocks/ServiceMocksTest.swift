//
//  ServiceMocksTest.swift
//  TFT-ProTeamsTests
//
//  Created by Júlio John Tavares Ramos on 16/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import XCTest
@testable import TFT_ProTeams

extension TftDAO {
    func championLoadJson(filename fileName: String, completion: @escaping ([Champion]?, Error?) -> Void) {
        
    }
    func getUserData(userName: String, completion: @escaping(UserDetails?, Error?) -> Void) {
        
    }
    func getUserMatchs(count: Int, puuid: String, completion: @escaping([String]?, Error?) -> Void) {
        
    }
    func getMatchByMatchID(matchId: String, completion: @escaping(MatchDetails?, Error?) -> Void) {
        
    }
}

class TftDAOMock: TftDAO {
    
}

class TftDAOMockChampionNil: TftDAO {
    func championLoadJson(filename fileName: String, completion: @escaping ([Champion]?, Error?) -> Void) {
        completion(nil, nil)
    }
}

class TftDAOMockIfErrorPassError: TftDAO {
    func championLoadJson(filename fileName: String, completion: @escaping ([Champion]?, Error?) -> Void) {
        completion(nil, PlayerErrors.jsonCantBeLoaded)
    }
}

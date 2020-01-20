//
//  TftDAO.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 19/12/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation

protocol TftDAO {
    func championLoadJson(filename fileName: String, completion: @escaping ([Champion]?, Error?) -> Void)
    func getUserData(userName: String, completion: @escaping(UserDetails?, Error?) -> Void)
    func getUserMatchs(count: Int, puuid: String, completion: @escaping([String]?, Error?) -> Void)
    func getMatchByMatchID(matchId: String, completion: @escaping(MatchDetails?, Error?) -> Void)
}

class TftDAOProduction: TftDAO {
    let API_KEY: String = "RGAPI-0d47ab3a-9d40-4a68-8b79-b8cc0f85db8f"
    
    func championLoadJson(filename fileName: String, completion: @escaping ([Champion]?, Error?) -> Void) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Champion].self, from: data)
                completion(jsonData, nil)
            } catch {
                completion(nil, PlayerErrors.jsonCantBeLoaded)
            }
        }
    }
    
    func getUserData(userName: String, completion: @escaping(UserDetails?, Error?) -> Void) {
        let resourceString =
        "https://br1.api.riotgames.com/tft/summoner/v1/summoners/by-name/\(userName)?api_key=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            //no caso de nao ter data chama esta
            guard let jsonData = data else {
                completion(nil, PlayerErrors.jsonDataDontExist)
                return
            }
            
            //no caso de nao conseguir processar esses dados
            do {
                let decoder = JSONDecoder()
                let userDetailsResponse = try decoder.decode(UserDetails.self, from: jsonData)
                completion(userDetailsResponse, nil)
            } catch {
                completion(nil, PlayerErrors.dataCantBeProcessed)
            }
        }
        
        dataTask.resume()
    }
    
    func getUserMatchs(count: Int, puuid: String, completion: @escaping([String]?, Error?) -> Void) {
        let resourceString = "https://americas.api.riotgames.com/tft/match/v1/matches/by-puuid/\(puuid)/ids?count=\(count)&api_key=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            //no caso de nao ter data chama esta
            guard let jsonData = data else {
                completion(nil, PlayerErrors.jsonDataDontExist)
                return
            }
            
            //no caso de nao conseguir processar esses dados
            do {
                let decoder = JSONDecoder()
                let matchDetailsResponse = try decoder.decode([String].self, from: jsonData)
                completion(matchDetailsResponse, nil)
            } catch {
                completion(nil, PlayerErrors.dataCantBeProcessed)
            }
        }
        
        dataTask.resume()
    }
    
    func getMatchByMatchID(matchId: String, completion: @escaping(MatchDetails?, Error?) -> Void) {
        
        let resourceString = "https://americas.api.riotgames.com/tft/match/v1/matches/\(matchId)?api_key=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            //no caso de nao ter data chama esta
            guard let jsonData = data else {
                completion(nil, PlayerErrors.jsonDataDontExist)
                return
            }
            
            //no caso de nao conseguir processar esses dados
            do {
                let decoder = JSONDecoder()
                let matchDetailsResponse = try decoder.decode(MatchDetails.self, from: jsonData)
                completion(matchDetailsResponse, nil)
            } catch {
                completion(nil, PlayerErrors.dataCantBeProcessed)
            }
        }
        
        dataTask.resume()
    }
}

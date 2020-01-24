//
//  TftService.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 19/12/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation
import UIKit

class TftServices {
    
    var tftDAO: TftDAO  = TftDAOProduction()
    
    /// Carrega o json de champions
    /// - Parameters:
    ///   - fileName: Nome do arquivo json
    ///   - completion: Contém o array de champions e/ou um error
    func championLoadJson(filename fileName: String, completion: @escaping ([Champion]?, Error?) -> Void) {
        if fileName.count == 0 {
            completion(nil, PlayerErrors.invalidName)
            return
        }
        
        self.tftDAO.championLoadJson(filename: fileName) { (champion, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            if let champion = champion {
                completion(champion, nil)
            } else {
                completion(nil, PlayerErrors.hasNoChampionInTheJson)
            }
        }
    }
    
    /// Dado um nome de usuario devolve os dados do usuario
    /// - Parameters:
    ///   - userName: Nome do usuario
    ///   - completion: Devolve os dados do usuario no tipo UserDetails e/ou um error
    func getUserData(userName: String, completion: @escaping(UserDetails?, Error?) -> Void) {
        if userName.count == 0 {
            completion(nil, PlayerErrors.invalidName)
            return
        }
        
        self.tftDAO.getUserData(userName: userName) { (userDetails, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            print("Usuario capturado com sucesso, puuid: \(String(describing: userDetails?.puuid))")
            completion(userDetails, nil)
        }
    }
    
    
    /// Dado um nome e o numero de ultimas partidas devolve o historico e os dados de um jogador
    /// - Parameters:
    ///   - name: Nome do jogador
    ///   - countOfMatchs: Numero de ultimas partidas
    ///   - completion: Devolve os dados do jogador completos em formato PlayerDetails e/ou um error
    func getUserMatchsByUserName(name: String, countOfMatchs: Int, completion: @escaping([PlayerDetails]?, Error?) -> Void) {
        var allPlayerMatchsByMatchDetails: [PlayerDetails] = []
        
        //Fazendo pesquisa por um usuario
        self.getUserData(userName: name) { (userData, error) in
            if error != nil {
                completion(nil, PlayerErrors.failInGetUserData)
                return
            }
            
            if let puuid = userData?.puuid {
                self.getUserMatchs(count: countOfMatchs, puuid: puuid) { (userMatchs, error) in
                    if error != nil {
                        completion(nil, error)
                        return
                    }
                    //Existem matchs
                    if let matchs = userMatchs {
                        //caso tenha nome
                        if let name = userData?.name {
                            for quantityOfMatchs in 0 ... matchs.count - 1 {
                                let player: PlayerDetails = PlayerDetails(name: name, puuid: puuid, matchs: matchs[quantityOfMatchs])
                                allPlayerMatchsByMatchDetails.append(player)
                            }
                            completion(allPlayerMatchsByMatchDetails, nil)
                        } else {
                            //caso  nao tenha nome
                            completion(nil, PlayerErrors.thePlayerHasNoName)
                        }
                    //Não existem matchs
                    } else {
                        completion(nil, PlayerErrors.thePlayerHasNoMatchs)
                    }
                }
            } else {
                completion(nil, PlayerErrors.failInGetPlayerUuid)
            }
        }
    }
    
    
    /// Recebe um array de ids e devolve os matchs referentes
    /// - Parameters:
    ///   - matchIdsArray: Array de ids de matchs
    ///   - completion: Devolve as partidas em formato MatchDetails e/ou um error
    func getAllMatchsInIDArray(_ matchIdsArray: [String], completion: @escaping([MatchDetails]?, Error?) -> Void) {
        let size = matchIdsArray.count - 1
        var matchs: [MatchDetails] = []
        
        let group = DispatchGroup()
        var lastError: Error? =  nil
        
        //Para cada matchID entra numa fila de requisicao
        for index in  0 ... size {
            group.enter()
        }
        
        //Captura o Match referente ao seu MatchID e guarda em "matchs"
        for index in  0 ... size {
            self.tftDAO.getMatchByMatchID(matchId: matchIdsArray[index]) { (matchDetails, error) in
                group.leave()
                if let matchDetails = matchDetails {
                    matchs.append(matchDetails)
                   // completion(matchs, nil)
                } else {
                    lastError = error
                    //completion(nil, error)
                }
            }
        }
        
        //Quando todos sairem da fila de requisicao ativa o completion
        group.notify(queue: DispatchQueue.main) {
            if let resultError = lastError  {
                completion(nil, resultError)
            } else {
                completion(matchs, nil)
            }
        }
    }
    
    
    /// Dado a quantidade de matchs e o puuid do usuario retorna um array de MatchDetails e/ou um error
    /// - Parameters:
    ///   - count: Numero de matchs a se pegar
    ///   - puuid: Id do tipo uuid do jogador
    ///   - completion: Devolve todas as ultimas "count" partidas e/ou um error
    func getUserMatchs(count: Int, puuid: String, completion: @escaping([MatchDetails]?, Error?) -> Void) {
        //Captura o vetor de IDs
        tftDAO.getUserMatchs(count: count, puuid: puuid) { (matchIds, error) in
            if error != nil {
                completion(nil, error)
            }

            if let matchIdsArray = matchIds {
                self.getAllMatchsInIDArray(matchIdsArray) { (matchDetails, error) in
                    completion(matchDetails, error)
                }
            } else {
                //Nao tem matchIds
                completion(nil, PlayerErrors.thePlayerHasNoMatchs)
            }
        }
    }
}

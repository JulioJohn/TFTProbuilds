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
    var matchs: MatchDetails?
    
    init(name: String, puuid: String, matchs: MatchDetails) {
        self.name = name
        self.puuid = puuid
        self.matchs = matchs
    }
    
    init() {
        self.name = "Not initialized"
        self.puuid = "Not initialized"
        self.matchs = nil
    }
    
    func searchForPlayerCompanionIcon() -> String {
        if let matchs = matchs {
            for y in 0 ... matchs.info.participants.count - 1 {
                if self.puuid == matchs.info.participants[y].puuid {
                    return matchs.info.participants[y].companion.species
                }
            }
        }
        return ""
    }
    
    func searchForPlayerTraits() -> [TraitDetails] {
        if let matchs = matchs {
            for y in 0 ... matchs.info.participants.count - 1 {
                if self.puuid == matchs.info.participants[y].puuid {
                    var traits =  matchs.info.participants[y].traits
                    var updatedTraits: [TraitDetails] = []
                    for k in 0 ... traits.count - 1 {
                        if traits[k].tier_current > 0 {
                            traits[k].name = verifyTrait(traits: traits[k].name)
                            updatedTraits.append(traits[k])
                        }
                    }
                    
                    return updatedTraits
                }
            }
        }
        return []
    }
    
    func verifyTrait(traits: String) -> String {
        if traits.count > 5 {
            var newTraits = traits
            var verifyFourFirstCaracters: String = ""
            for i in 0 ... 4 {
                verifyFourFirstCaracters.append(newTraits.removeFirst())
            }
            print(newTraits)
            print(verifyFourFirstCaracters)
            if verifyFourFirstCaracters.elementsEqual("Set2_") {
                return newTraits
            }
        }
        
        return traits
    }
    
    func getMonstersInPlayerMatch() -> [UnitDetails]? {
        let participant = self.getPlayerInMatch()
        if participant == nil {
            return nil
        }
        return participant?.units
    }

    func getPlayerInMatch() -> ParticipantDetails? {
        let matchParticipants = self.matchs!.info.participants
        //Percorre pelos participantes da partida, acha o jogador e guarda ele
        for i in 0 ... matchParticipants.count - 1 {
            if matchParticipants[i].puuid == self.puuid {
                return matchParticipants[i]
            }
        }
        print("Nao foi possivel encontrar o jogador nessa partida!")
        return nil
    }
}

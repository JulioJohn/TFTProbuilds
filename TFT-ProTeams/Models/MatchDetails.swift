//
//  MatchDetails.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 14/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation

struct MatchDetails: Decodable {
    var info: InfoDetails
    var metadata: MetadataDetails
}

struct InfoDetails: Decodable {
    var game_datetime: Double
    var participants: [ParticipantDetails]
    var tft_set_number: Int
    var game_length: Float
    var queue_id: Int
    var game_version: String
}

struct ParticipantDetails: Decodable {
    var placement: Int
    var level: Int
    var last_round: Int
    var time_eliminated: Float
    var companion: CompanionDetails
    var traits: [TraitDetails]
    var players_eliminated: Int
    var puuid: String
    var total_damage_to_players: Int
    var units: [UnitDetails]
    var gold_left: Int
}

struct CompanionDetails: Decodable {
    var skin_ID: Int
    var content_ID: String
    var species: String
}

struct MetadataDetails: Decodable {
    var data_version: String
    var participants: [String]
    var match_id: String
}

struct TraitDetails: Decodable {
    var tier_total: Int
    var name: String
    var tier_current: Int
    var num_units: Int
}

struct UnitDetails: Decodable {
    var tier: Int
    var items: [Int]
    var character_id: String
    var name: String
    var rarity: Int
}




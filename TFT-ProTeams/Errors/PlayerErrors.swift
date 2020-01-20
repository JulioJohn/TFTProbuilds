//
//  GetPlayerErrors.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 16/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation

enum PlayerErrors: Error {
    case failInGetUserData
    case failInGetPlayerUuid
    case thePlayerHasNoMatchs
    case thePlayerHasNoName
    case jsonDataDontExist
    case dataCantBeProcessed
    case jsonCantBeLoaded
    case invalidName
    case hasNoChampionInTheJson
}

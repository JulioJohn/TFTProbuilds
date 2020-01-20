//
//  UserDetailsRequest.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 14/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation
import UIKit

struct UserDetailsRequest {
    let resourceURL: URL
    let API_KEY = "RGAPI-5aded3ee-f3c5-43b7-9ae0-e46730ce42d7"
    
    
    
    func getUserData(completion: @escaping(UserDetails?) -> Void) {
        TftServices.getUserData(userName: resourceURL) { userDetails, error  in
            if error == nil {
                completion(userDetails)
            } else {
                print("Ocorreu algum erro ao capturar o user data")
                completion(nil)
            }
        }
    }
}

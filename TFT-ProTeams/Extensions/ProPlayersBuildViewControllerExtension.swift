//
//  ProPlayersBuildViewControllerExtension.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 17/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation
import UIKit

extension ProPlayersBuildViewController {
    func startSpinning(activity: UIActivityIndicatorView) {
        activity.startAnimating()
        activity.isHidden = false
    }
    
    func stopSpinning(activity: UIActivityIndicatorView) {
        activity.stopAnimating()
        activity.isHidden = true
    }
}

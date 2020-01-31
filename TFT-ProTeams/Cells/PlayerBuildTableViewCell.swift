//
//  PlayerBuildTableViewCell.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 18/12/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import UIKit

class PlayerBuildTableViewCell: UITableViewCell {

    @IBOutlet weak var playerPhoto: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//
//  ProfissionalCellTableViewCell.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 14/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import UIKit

class ProfissionalCellTableViewCell: UITableViewCell {

    @IBOutlet weak var championImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var timeThisMatch: UILabel!
    
    @IBOutlet weak var championsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        championsCollectionView.delegate = dataSourceDelegate
        championsCollectionView.dataSource = dataSourceDelegate
        championsCollectionView.tag = row
        championsCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ProfissionalCellTableViewCell.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 14/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import UIKit

class ProfissionalCellTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var championImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var timeThisMatch: UILabel!
    
    @IBOutlet weak var traitsCollectionView: UICollectionView!
    @IBOutlet weak var championsCollectionView: UICollectionView!
    
    var championsOfTheGame: [UnitDetails]? = []
    var traitsOfTheGame: [TraitDetails]? = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCollectionViewDataSourceDelegate(playerDetails: PlayerDetails) {
        //Pegando os monstros desse player nessa partida
        let champions = playerDetails.getMonstersInPlayerMatch()
        //Ordenar pela raridade
        let sortedChampions = champions!.sorted {
            $0.rarity < $1.rarity
        }
        self.championsOfTheGame = sortedChampions
        
        //Procurando traits do player
        let traits = playerDetails.searchForPlayerTraits()
        self.traitsOfTheGame = traits
        
        championsCollectionView.delegate = self
        championsCollectionView.dataSource = self
        championsCollectionView.reloadData()
        
        traitsCollectionView.delegate = self
        traitsCollectionView.dataSource = self
        traitsCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  championsCollectionView {
            if let champions = self.championsOfTheGame {
                return champions.count
            } else {
                return 0
            }
        } else if collectionView ==  traitsCollectionView {
            if let traits = self.traitsOfTheGame {
                return traits.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == championsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "championImage",
            for: indexPath) as? ChampionBuildCollectionViewCell
            
            if let champions = self.championsOfTheGame {
                cell?.championImage.layer.borderColor = colorByRarity(rarity: champions[indexPath.item].rarity)
                
                //Caso seja raridade 5 só pode ser a Lux no TFT2
                if champions[indexPath.item].rarity == 5 {
                    cell?.championImage.image = UIImage(named: "TFT2_Lux")
                } else {
                    cell?.championImage.image = UIImage(named: champions[indexPath.item].character_id)
                }
                
                cell?.championImage.layer.borderWidth = 2.0
                cell?.championImage.layer.cornerRadius = 1.5
                cell?.championImage.contentMode = .scaleAspectFit
            }
            
            return cell!
        } else if collectionView == traitsCollectionView {
            if let traits = self.traitsOfTheGame {
                if traits[indexPath.item].tier_current != 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "traitsCollectionCell", for: indexPath) as? ChampionBuildCollectionViewCell
                    
                    cell?.championImage.image = UIImage(named: traits[indexPath.item].name)
                    cell?.championImage.contentMode = .scaleAspectFit
                    
                    return cell!
                }
            }
            return UICollectionViewCell()
        } else {
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == championsCollectionView {
            return 1
        } else if collectionView == traitsCollectionView {
            return 1
        } else {
            return 0
        }
    }
}

extension ProfissionalCellTableViewCell {
    func colorByRarity(rarity: Int) -> CGColor {
        let rarityArray: [CGColor] = [
            UIColor(red: 128/256, green: 128/256, blue: 128/256, alpha: 1.0).cgColor,
            UIColor(red: 47/256, green: 144/256, blue: 119/256, alpha: 1.0).cgColor,
            UIColor(red: 85/256, green: 153/256, blue: 213/256, alpha: 1.0).cgColor,
            UIColor(red: 203/256, green: 83/256, blue: 222/256, alpha: 1.0).cgColor,
            UIColor(red: 255/256, green: 185/256, blue: 59/256, alpha: 1.0).cgColor,
            UIColor(red: 255/256, green: 59/256, blue: 59/256, alpha: 1.0).cgColor]
        return rarityArray[rarity]
    }
}

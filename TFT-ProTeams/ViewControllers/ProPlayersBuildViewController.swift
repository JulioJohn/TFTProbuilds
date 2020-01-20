//
//  ProPlayersBuildViewController.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 25/12/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import UIKit

class ProPlayersBuildViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var proBuildsTableView: UITableView!
    
    var championsOfTheGame: [UnitDetails]? = []
    
    var myPlayer: PlayerDetails? = PlayerDetails()
    
    var tftServices: TftServices = TftServices()
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Muda a cor da barra de status
        navigationController?.navigationBar.barStyle = .black

        //Esperando carregar arquivos
        startSpinning(activity: activityView)
        
        //Fazendo pesquisa por um usuario
        self.tftServices.getUserMatchsByUserName(name: "CABRITOVOADOR", countOfMatchs: 1) { (playerDetails, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let playerDetails = playerDetails {
                        self.myPlayer  = playerDetails
                        
                        self.championsOfTheGame = self.getMonstersInPlayerMatch(puuid: playerDetails.puuid, Match: playerDetails.matchs![0])
                        
                        
                    } else {
                        print("Player details está nulo!")
                    }
                    
                    self.proBuildsTableView.reloadData()
                    self.stopSpinning(activity: self.activityView)
                }
            } else {
                print(error)
            }
        }
    }
    
    func getPlayerInMatch(puuid: String, match: MatchDetails) -> ParticipantDetails? {
        let matchParticipants = match.info.participants
        //Percorre pelos participantes da partida, acha o jogador e guarda ele
        for i in 0 ... matchParticipants.count - 1 {
            if matchParticipants[i].puuid == puuid {
                return matchParticipants[i]
            }
        }
        print("Nao foi possivel encontrar o jogador nessa partida!")
        return nil
    }
    
    func getMonstersInPlayerMatch(puuid: String, Match: MatchDetails) -> [UnitDetails]? {
        let participant = getPlayerInMatch(puuid: puuid, match: Match)
        if participant == nil {
            return nil
        }
        return participant?.units
    }
    
    func getTraitsInPlayerMatch(puuid: String, Match: MatchDetails) -> [TraitDetails]? {
        let participant = getPlayerInMatch(puuid: puuid, match: Match)
        if participant == nil {
            return nil
        }
        return participant?.traits
    }
    
}

//TableView
extension ProPlayersBuildViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (myPlayer?.matchs?.count)!
    }
    
    func tableChampionCellInit(_ cell: ProfissionalCellTableViewCell, _ companionSkin: Int, _ matchDetails: [MatchDetails], _ position: Int, _ indexPath: IndexPath) {
        cell.championImage.image = UIImage(named: "\(companionSkin)")
        cell.playerName.text = myPlayer?.name
        cell.timeThisMatch.text = "\(matchDetails[position].info.game_datetime)"
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profissionalCell", for: indexPath) as! ProfissionalCellTableViewCell
        if let matchDetails = self.myPlayer?.matchs {
            if matchDetails.count != 0 {
                let position = indexPath.row
                let companionSkin: Int = matchDetails[position].info.participants[0].companion.skin_ID
                
                tableChampionCellInit(cell, companionSkin, matchDetails, position, indexPath)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.separatorStyle = .none
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .clear

        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Hot Builds"
        
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.textColor = UIColor.black

        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}

//CollectionView
extension ProPlayersBuildViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let champions = self.championsOfTheGame {
            return champions.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "championImage",
                                                      for: indexPath) as? ChampionBuildCollectionViewCell
        
        if let champions = self.championsOfTheGame {
            cell?.championImage.layer.borderColor = colorByRarity(rarity: champions[indexPath.item].rarity)
            cell?.championImage.image = UIImage(named: champions[indexPath.item].name)
            cell?.championImage.layer.borderWidth = 2.0
            cell?.championImage.layer.cornerRadius = 1.5
            cell?.championImage.contentMode = .scaleAspectFit
        }
        
        return cell!
    }
    
    func colorByRarity(rarity: Int) -> CGColor {
        let rarityArray: [CGColor] = [
            UIColor(red: 128/256, green: 128/256, blue: 128/256, alpha: 1.0).cgColor,
            UIColor(red: 66/256, green: 194/256, blue: 160/256, alpha: 1.0).cgColor,
            UIColor(red: 85/256, green: 153/256, blue: 213/256, alpha: 1.0).cgColor,
            UIColor(red: 203/256, green: 83/256, blue: 222/256, alpha: 1.0).cgColor,
            UIColor(red: 255/256, green: 185/256, blue: 59/256, alpha: 1.0).cgColor]
        return rarityArray[rarity]
    }
    
}

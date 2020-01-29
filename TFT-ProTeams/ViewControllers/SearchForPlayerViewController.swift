//
//  SearchForPlayerViewController.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 29/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import UIKit

class SearchForPlayerViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var monsterTableView: UITableView!
    @IBOutlet weak var playerSearchBar: UISearchBar!
    
    var tftServices: TftServices = TftServices()
    var myPlayer: [PlayerDetails]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Muda a cor da barra de status
        navigationController?.navigationBar.barStyle = .black
        
        playerSearchBar.delegate = self
        monsterTableView.delegate = self
        monsterTableView.dataSource = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.searchTextField
        if text.hasText == false { return }
        
        searchBar.resignFirstResponder()
        
        //Fazendo pesquisa por um usuario
        self.tftServices.getUserMatchsByUserName(name: text.text!, countOfMatchs: 10) { (playerDetails, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let playerDetails = playerDetails {
                        let sortedUsers = playerDetails.sorted {
                            $0.matchs!.info.game_datetime > $1.matchs!.info.game_datetime
                        }
                        self.myPlayer = sortedUsers
                    } else {
                        print("Player details está nulo!")
                    }
                    
                    self.monsterTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
}

    //TableView
extension SearchForPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //myPlayer!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if myPlayer == nil {
            return 1
        } else {
            return myPlayer!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profissionalCell", for: indexPath) as! ProfissionalCellTableViewCell
        
        if let player = self.myPlayer {
            let myPlayer = player[indexPath.section]
            
            if let matchDetails = myPlayer.matchs {
                let companionRace: String = myPlayer.searchForPlayerCompanionIcon()
                
                //Setando a foto do companion
                if let image = UIImage(named: companionRace) {
                    cell.championImage.image = image
                } else {
                    cell.championImage.image = UIImage(named: "PetTFTAvatar")
                }
                
                cell.championImage.layer.cornerRadius = (cell.championImage.layer.frame.width/2)
                cell.championImage.contentMode = .scaleAspectFill
                
                //Setando outras informacoes
                cell.playerName.text = myPlayer.name
                cell.timeThisMatch.text = tranformUnixInDate(date: matchDetails.info.game_datetime)
                
                cell.setCollectionViewDataSourceDelegate(playerDetails: myPlayer)
            }
        }
        
        return cell
    }
    
    func tranformUnixInDate(date: Double) -> String {
        //let todayDate = Date()
        let todayDate = NSDate().timeIntervalSince1970
        
        let dateFixedWithoutLast3Digits = date / 1000
        
        let dateComparation = todayDate - dateFixedWithoutLast3Digits
        
        let oneDayInSeconds = 86400.0
        let oneWeekInSeconds = 604800.0
        
        var timeToReturn: Double
        var timeToReturnInString: String
        
        //Se a diferenca de datas for maior do que um dia
        if dateComparation < oneDayInSeconds {
            timeToReturn = dateComparation/60
            timeToReturnInString = "hours ago"
        } else if dateComparation < oneWeekInSeconds {
            timeToReturn = dateComparation/oneDayInSeconds
            timeToReturnInString = "days ago"
        } else {
            timeToReturn = dateComparation/oneWeekInSeconds
            timeToReturnInString = "weeks ago"
        }
        return "\(Int(timeToReturn.rounded())) " + timeToReturnInString
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.separatorStyle = .none
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}

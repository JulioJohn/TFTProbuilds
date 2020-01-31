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
    
    var myPlayer: [PlayerDetails]? = nil
    
    var tftServices: TftServices = TftServices()
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Muda a cor da barra de status
        navigationController?.navigationBar.barStyle = .black

        //Esperando carregar arquivos
        startSpinning(activity: activityView)
        
        //Fazendo pesquisa por um usuario
        self.tftServices.getUserMatchsByUserName(name: "CABRITOVOADOR", countOfMatchs: 10) { (playerDetails, error) in
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
                    
                    self.proBuildsTableView.reloadData()
                    
                    //Para a animacao de carregamento
                    self.stopSpinning(activity: self.activityView)
                }
            } else {
                print(error)
            }
        }
    }
}

//TableView
extension ProPlayersBuildViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myPlayer == nil {
            return 0
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if myPlayer == nil {
            return 1
        } else {
            return myPlayer!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profissionalCell", for: indexPath) as! ProfissionalCellTableViewCell
        if let player = self.myPlayer {
            let myPlayer = player[indexPath.section]
            
            if let matchDetails = myPlayer.matchs {
                let companionRace: String = myPlayer.searchForPlayerCompanionIcon()
                
                //Setando a foto do companion
                cell.championImage.image = UIImage(named: companionRace)
                cell.championImage.layer.cornerRadius =  (cell.championImage.layer.frame.width/2)
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
        
        let oneHourInSeconds = 3600.0
        let oneDayInSeconds = 86400.0
        let oneWeekInSeconds = 604800.0
        
        var timeToReturn: Double
        var timeToReturnInString: String
        
        //Se a diferenca de datas for maior do que um dia
        if dateComparation < oneDayInSeconds {
            timeToReturn = dateComparation/oneHourInSeconds
            timeToReturnInString = "hours ago"
        } else if dateComparation < oneWeekInSeconds {
            timeToReturn = dateComparation/oneDayInSeconds
            timeToReturnInString = "days ago"
        } else {
            timeToReturn = dateComparation/oneWeekInSeconds
            timeToReturnInString = "weeks ago"
        }
        return "\(Int(timeToReturn.rounded())) " + timeToReturnInString
        
//        let newDate = Date(timeIntervalSince1970: dateFixedWithoutLast3Digits)
//        let dateFormatter = DateFormatter()
//        //Seta a zona
//        dateFormatter.locale = NSLocale.current
//        //Formatacao da data
//        dateFormatter.timeStyle = .short
//        dateFormatter.dateStyle = .short
//        return dateFormatter.string(from: newDate)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellSize: Double
        
        if indexPath.section == 0 {
            cellSize = CellSize.titleCell.rawValue
        } else {
            cellSize = CellSize.cardCell.rawValue
        }
        
        return CGFloat(cellSize)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.separatorStyle = .none
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}

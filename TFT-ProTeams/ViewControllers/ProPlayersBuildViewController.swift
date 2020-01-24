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
        let newDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //Seta a zona
        dateFormatter.locale = NSLocale.current
        //Formatacao da data
        dateFormatter.dateFormat = "dd/MM HH:mm"
        return dateFormatter.string(from: newDate)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.separatorStyle = .none
        
//        if section == 0 {
//            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//            headerView.backgroundColor = .clear
//
//            let label = UILabel()
//            label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//            label.text = "Hot Builds"
//            label.font = UIFont(name: "SFProText-Bold", size: 17)
//            label.textColor = UIColor.black
//
//            headerView.addSubview(label)
//
//            return headerView
//        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5 //46
    }
}

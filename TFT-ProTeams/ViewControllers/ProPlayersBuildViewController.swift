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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profissionalCell", for: indexPath) as! ProfissionalCellTableViewCell
        if let matchDetails = self.myPlayer?.matchs {
            if matchDetails.count != 0 {
                let position = indexPath.row
                let companionRace: String = (myPlayer?.searchForPlayerCompanionIcon())!
                
                //Setando a foto do companion
                cell.championImage.image = UIImage(named: companionRace)
                cell.championImage.layer.cornerRadius =  (cell.championImage.layer.frame.width / 2)
                cell.championImage.contentMode = .scaleAspectFill
                
                //Setando outras informacoes
                cell.playerName.text = myPlayer?.name
                cell.timeThisMatch.text = tranformUnixInDate(date: matchDetails[position].info.game_datetime)
                
                //Procurando traits do player
                let traits = (self.myPlayer?.searchForPlayerTraits())!
                
                cell.setCollectionViewDataSourceDelegate(championsOfTheGame: championsOfTheGame!, traitsOfTheGame: traits)
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

//
//  BuildViewController.swift
//  TFT-ProTeams
//
//  Created by Júlio John Tavares Ramos on 18/12/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import UIKit

class BuildViewController: UIViewController {
    
    @IBOutlet weak var championsCollectionView: UICollectionView!
    
    var championsData: [Champion] = []
    
    var tftServices = TftServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        tftServices.championLoadJson(filename: "champions", completion: { champions, error in
            if error == nil {
                //Armazena localmente
                if let championsNew = champions {
                    self.championsData = championsNew
                }
                
                //Atualiza a table view
                OperationQueue.main.addOperation {
                    self.championsCollectionView.reloadData()
                }
            } else {
                print(error)
            }
        })
    }
}

extension BuildViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return championsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "championCell", for: indexPath) as! ChampionCollectionViewCell
        cell.backgroundColor = .black
        cell.championIcon.image = UIImage(named: "\(championsData[indexPath.item].champion)")
      // Configure the cell
      return cell
    }
    
}

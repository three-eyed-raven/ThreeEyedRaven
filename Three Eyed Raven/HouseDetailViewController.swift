//
//  HouseDetailViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 4/4/17.
//
//

import UIKit
import MBProgressHUD

class HouseDetailViewController: UIViewController {

    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseRegionLabel: UILabel!
    @IBOutlet weak var houseWordsLabel: UILabel!
    @IBOutlet weak var houseCoatOfArmsLabel: UILabel!
    @IBOutlet weak var coatOfArmsView: UIView!
    @IBOutlet weak var swornMembersCollectionView: UICollectionView!
    var house: House?
    var swornMembers: [RealmCharacter] = []
    var characterForSearch: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.houseNameLabel.text = house?.name
        self.houseRegionLabel.text = house?.region
        self.houseWordsLabel.text = (house?.words?.isEmpty)! ? nil : "\"\((house?.words)!)\""
        self.houseCoatOfArmsLabel.text = (house?.coatOfArms?.isEmpty)! ? "Unknown" : house?.coatOfArms
        swornMembersCollectionView.delegate = self
        swornMembersCollectionView.dataSource = self
        setNavigationBar()
        self.swornMembers = GoTClient.getSwornMembers(by: self.house!)
    }
    
    func setNavigationBar() {
        let logoImage = UIImage(named: "TER Icon")
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.image = logoImage
        logoView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        logoView.frame = titleView.bounds
        titleView.addSubview(logoView)
        
        self.navigationItem.titleView = titleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let characterDetailVC = segue.destination as! CharacterDetailViewController
        characterDetailVC.character = self.characterForSearch
    }

}

extension HouseDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of sworn members \((self.house?.swornMembers?.count)!)")
        return self.swornMembers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HouseCollectionCell", for: indexPath) as! HouseCollectionCell
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(houseCollectionCellPressed(sender:)))
        cell.addGestureRecognizer(tapGestureRecognizer)
        let member = self.swornMembers[indexPath.row]
        cell.characterNameLabel.text = member.name
        return cell
    }
    
    @objc func houseCollectionCellPressed(sender: UITapGestureRecognizer) {
        print("tapped")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let group = DispatchGroup()
        let cell = sender.view as! HouseCollectionCell
        if let indexPath = self.swornMembersCollectionView.indexPath(for: cell) {
            let character = swornMembers[indexPath.row]
            group.enter()
            GoTClient.getCharacter(fromUrlString: character.urlString, success: { (character: Character) in
                self.characterForSearch = character
                group.enter()
                GoTClient.setHouse(for: character, success: {
                    group.leave()
                }, failure: {
                    group.leave()
                })
                group.enter()
                GoTClient.getCharacterPhoto(characters: [character], success: {
                    group.leave()
                }, failure: {
                    group.leave()
                })
                group.leave()
            }, failure: {
                print("Character search failed")
            })
        }
        group.notify(queue: .main) {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.performSegue(withIdentifier: "SwornMemberCharacterDetailSegue", sender: cell)
        }

    }
}

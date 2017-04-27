//
//  CharacterDetailViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 4/3/17.
//
//

import UIKit

class CharacterDetailViewController: UIViewController {

    
    @IBOutlet weak var characterSpouseLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var characterFatherLabel: UILabel!
    @IBOutlet weak var charcterMotherLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterBirthdateLabel: UILabel!
    @IBOutlet weak var characterGenderLabel: UILabel!
    @IBOutlet weak var characterPlayedByLabel: UILabel!
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characterImageView.layer.cornerRadius = 3
        self.characterImageView.clipsToBounds = true

        self.characterNameLabel.text = character?.name
        if let imageUrl = character?.imageUrl {
            self.characterImageView.setImageWith(imageUrl)
        }
        self.houseNameLabel.text = character?.house?.name ?? "Unknown"
        self.characterBirthdateLabel.text = (character?.birthDate?.isEmpty)! ? "Unknown" : character?.birthDate
        self.characterGenderLabel.text = (character?.gender?.isEmpty)! ? "Unknown" : character?.gender
        self.characterPlayedByLabel.text = character?.playedBy?.first
        setNavigationBar()
        getParents()
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
    
    func getParents() {
        print("getting parents mother: \(character?.mother) | father: \(character?.father)")
        GoTClient.getCharacter(fromUrlString: (character?.mother)!, success: { (character: Character) in
            self.charcterMotherLabel.text = character.name
        }) { 
            self.charcterMotherLabel.text = "Mother Unknown"
        }
        GoTClient.getCharacter(fromUrlString: (character?.father)!, success: { (character: Character) in
            self.characterFatherLabel.text = character.name
        }) {
            self.characterFatherLabel.text = "Father Unknown"
        }
        GoTClient.getCharacter(fromUrlString: (character?.spouse)!, success: { (character: Character) in
            self.characterSpouseLabel.text = character.name
        }) {
            self.characterSpouseLabel.text = "Spouse Unknown"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

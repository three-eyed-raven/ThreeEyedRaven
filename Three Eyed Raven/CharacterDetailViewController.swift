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
        getParents()
    }
    
    func getParents() {
        print("getting parents mother: \(character?.mother) | father: \(character?.father)")
        GoTClient.getCharacter(fromUrlString: (character?.mother)!, success: { (character: Character) in
            self.charcterMotherLabel.text = character.name
            print("mother success")
        }) { 
            self.charcterMotherLabel.text = "Mother Unknown"
            print("mother fail")
        }
        GoTClient.getCharacter(fromUrlString: (character?.father)!, success: { (character: Character) in
            self.characterFatherLabel.text = character.name
            print("father success")
        }) {
            print("father fail")
            self.characterFatherLabel.text = "Father Unknown"
        }
        GoTClient.getCharacter(fromUrlString: (character?.spouse)!, success: { (character: Character) in
            self.characterSpouseLabel.text = character.name
            print("spouse success")
        }) {
            print("spouse fail")
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

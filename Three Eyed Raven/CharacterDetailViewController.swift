//
//  CharacterDetailViewController.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 4/3/17.
//
//

import UIKit

class CharacterDetailViewController: UIViewController {

    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var characterFatherLabel: UILabel!
    @IBOutlet weak var charcterMotherLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
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
        self.houseNameLabel.text = character?.house?.name
        self.characterBirthdateLabel.text = character?.birthDate
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

//
//  CharacterCell.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 3/27/17.
//
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterHouseLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterCultureLabel: UILabel!
    @IBOutlet weak var castleImageView: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView!
    
    @IBOutlet weak var constraint1: NSLayoutConstraint!
    
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.characterImageView.layer.cornerRadius = 3
        self.characterImageView.clipsToBounds = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

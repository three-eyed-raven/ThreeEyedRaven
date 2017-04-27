//
//  CharacterSearchCell.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/27/17.
//
//

import UIKit

class CharacterSearchCell: UITableViewCell {

    @IBOutlet weak var characterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

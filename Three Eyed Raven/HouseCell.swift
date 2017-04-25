//
//  HouseCell.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/25/17.
//
//

import UIKit

class HouseCell: UITableViewCell {

    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseWordsLabel: UILabel!
    @IBOutlet weak var houseRegionLabel: UILabel!
    @IBOutlet weak var houseIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if houseRegionLabel.text == nil {
            houseIconImageView.isHidden = true
        } else {
            houseIconImageView.isHidden = false
        }
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

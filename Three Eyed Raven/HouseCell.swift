//
//  HouseCell.swift
//  Three Eyed Raven
//
//  Created by Fiona Thompson on 3/28/17.
//
//

import UIKit

class HouseCell: UICollectionViewCell {
    
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var houseNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        houseImageView.layer.cornerRadius = 3
        houseImageView.clipsToBounds = true
    }

}

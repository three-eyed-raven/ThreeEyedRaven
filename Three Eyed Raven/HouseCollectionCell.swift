//
//  HouseCollectionCell.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/27/17.
//
//

import UIKit

class HouseCollectionCell: UICollectionViewCell {
    @IBOutlet weak var characterNameLabel: UILabel!
    override func awakeFromNib() {
        self.layer.cornerRadius = 3
    }
}

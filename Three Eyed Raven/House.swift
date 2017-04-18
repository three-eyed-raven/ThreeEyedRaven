//
//  House.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/2/17.
//
//

import UIKit
import SwiftyJSON

class House: NSObject {
    
    var name: String?
    var region: String?
    var coatOfArms: String?
    var words: String?
    var currentLord: String?
    var heir: String?
    var swornMembers: [String]?
    
    init(json: JSON?) {
        if let name = json?["name"] { self.name = name.string}
        if let region = json?["region"] { self.region = region.string }
        if let coatOfArms = json?["coatOfArms"] { self.coatOfArms = coatOfArms.string }
        if let words = json?["words"] { self.words = words.string }
        if let currentLord = json?["currentLord"] { self.currentLord = currentLord.string}
        if let heir = json?["heir"] { self.heir = heir.string}
        if let swornMembers = json?["swornMembers"] {
            self.swornMembers = swornMembers.arrayObject as! [String]?
        }
    }
}

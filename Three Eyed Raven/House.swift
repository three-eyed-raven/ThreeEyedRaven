//
//  House.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/2/17.
//
//

import UIKit

class House: NSObject {
    
    var id: Int?
    var name: String?
    var region: String?
    var coatOfArms: String?
    var words: String?
    var currentLord: Character?
    var heir: Character?
    var swornMembers: [Character]?
    
    init(dictionary: Dictionary<String, Any>) {
        if let id = dictionary["id"] { self.id = id as? Int }
        if let name = dictionary["name"] { self.name = name as? String }
        if let region = dictionary["region"] { self.region = region as? String }
        if let coatOfArms = dictionary["coatOfArms"] { self.coatOfArms = coatOfArms as? String }
        if let words = dictionary["words"] { self.words = words as? String }
        if let currentLord = dictionary["currentLord"] { self.currentLord = Character(dictionary: currentLord as! Dictionary) }
        if let heir = dictionary["heir"] { self.heir = Character(dictionary: heir as! Dictionary) }
        if let swornMembers = dictionary["swornMembers"] {
            self.swornMembers = Character.charactersAsArray(dictionaries: swornMembers as! [Dictionary])
        }
    }
    
}

//
//  Character.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/2/17.
//
//

import UIKit

class Character: NSObject {
    
    var name: String?
    var gender: String?
    var culture: String?
    var birthDate: String?
    var allegiances: [String]?
    var house: House?
    var titles: [String]?
    var aliases: [String]?
    var mother: String?
    var father: String?
    var spouse: String?
    var playedBy: [String]?
    var image: UIImage?
    var imageUrl: URL?
    

    init(dictionary: Dictionary<String, Any>) {
        if let name = dictionary["name"] { self.name = name as? String }
        if let gender = dictionary["gender"] { self.gender = gender as? String }
        if let culture = dictionary["culture"] { self.culture = culture as? String }
        if let birthDate = dictionary["born"] { self.birthDate = birthDate as? String }
        if let allegiances = dictionary["allegiances"] { self.allegiances = allegiances as? [String] }
        if let titles = dictionary["titles"] { self.titles = titles as? [String] }
        if let aliases = dictionary["aliases"] { self.aliases = aliases as? [String] }
        if let mother = dictionary["mother"] { self.mother = mother as? String }
        if let father = dictionary["father"] { self.father = father as? String }
        if let spouse = dictionary["spouse"] { self.spouse = spouse as? String }
        if let playedBy = dictionary["playedBy"] { self.playedBy = playedBy as? [String] }
    }
    
    class func charactersAsArray(dictionaries: [Dictionary<String, Any>]) -> [Character]{
        var characters: [Character] = []
        for dictionary in dictionaries {
            let character = Character(dictionary: dictionary)
            characters.append(character)
        }
        return characters
    }
    
}

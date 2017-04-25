//
//  Character.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/2/17.
//
//

import UIKit
import SwiftyJSON
import Alamofire

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
    

    init(json: JSON?) {
        if let name = json?["name"] { self.name = name.string }
        if let gender = json?["gender"] { self.gender = gender.string }
        if let culture = json?["culture"] { self.culture = culture.string }
        if let birthDate = json?["born"] { self.birthDate = birthDate.string }
        if let allegiances = json?["allegiances"] { self.allegiances = allegiances.arrayObject as! [String]? }
        if let titles = json?["titles"] { self.titles = titles.arrayObject as! [String]? }
        if let aliases = json?["aliases"] { self.aliases = aliases.arrayObject as! [String]? }
        if let mother = json?["mother"] { self.mother = mother.string }
        if let father = json?["father"] { self.father = father.string }
        if let spouse = json?["spouse"] { self.spouse = spouse.string }
        if let playedBy = json?["playedBy"] { self.playedBy = playedBy.arrayObject as! [String]? }
    }
    
    func setHouse() {
        if (self.allegiances?.isEmpty)! {
            return
        }
        let houseUrl = (self.allegiances?.first)!
        Alamofire.request(houseUrl).responseJSON { (response) in
            guard let responseValue = response.value else {
                return
            }
            let json = JSON(responseValue)
            let house = House(json: json)
            self.house = house
        }
    }

}

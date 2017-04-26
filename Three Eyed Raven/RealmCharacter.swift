//
//  RealmCharacter.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/23/17.
//
//

import UIKit
import RealmSwift

class RealmCharacter: Object {
    dynamic var name = ""
    dynamic var urlString = ""
    dynamic var playedBy = ""
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

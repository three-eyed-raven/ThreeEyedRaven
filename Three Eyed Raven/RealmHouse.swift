//
//  RealmHouse.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/23/17.
//
//

import UIKit
import RealmSwift

class RealmHouse: Object {
    dynamic var name = ""
    dynamic var urlString = ""
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

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
    @objc dynamic var name = ""
    @objc dynamic var urlString = ""
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

//
//  GoTClient.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/3/17.
//
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import RealmSwift

let MAXCHARACTERPAGE = 43
let MAXHOUSEPAGE = 9
class GoTClient: NSObject {
    static let baseUrl = "https://www.anapioficeandfire.com/api/"
    static var page = 1
    
    class func downloadCharacters(success: @escaping () -> (), failure: @escaping () -> ()) {
        let realm = try! Realm()
        var url: String
        var responsesReceived = 0

        for i in 1...MAXCHARACTERPAGE {
            url = "\(baseUrl)characters?pageSize=50&page=\(i)"
            Alamofire.request(url).responseJSON { (response) in
                guard let responseValue = response.value else {
                    failure()
                    return
                }
                let charactersJson = JSON(responseValue)
                
                for characterJson in charactersJson.array! {
                    let character = RealmCharacter()
                    let name = (characterJson["name"].string)!
                    let playedBy = (characterJson["playedBy"].array)!
                    // Save only characters who have a name and an associated actor
                    if (!name.isEmpty && !playedBy.isEmpty) {
                        character.name = (characterJson["name"].string)!
                        character.urlString = (characterJson["url"].string)!
                        try! realm.write {
                            realm.add(character)
                        }
                    }
                }
                responsesReceived += 1
                if responsesReceived == MAXCHARACTERPAGE {
                    success()
                }
                
            }
        }
    }
    
    class func downloadHouses(success: @escaping () -> (), failure: @escaping () -> ()) {
        let realm = try! Realm()
        var url: String
        var responsesReceived = 0
        
        for i in 1...MAXHOUSEPAGE {
            url = "\(baseUrl)houses?pageSize=50&page=\(i)"
            Alamofire.request(url).responseJSON { (response) in
                guard let responseValue = response.value else {
                    failure()
                    return
                }
                let housesJson = JSON(responseValue)
                
                for houseJson in housesJson.array! {
                    let house = RealmHouse()
                    let name = (houseJson["name"].string)!
                    // Save only houses that have a name
                    if (!name.isEmpty) {
                        house.name = (houseJson["name"].string)!
                        house.urlString = (houseJson["url"].string)!
                        print("Storing house name: \(house.name) | url: \(house.urlString)")
                        try! realm.write {
                            realm.add(house)
                        }
                    }
                }
                responsesReceived += 1
                if responsesReceived == MAXHOUSEPAGE {
                    success()
                }
                
            }
        }
    }
    
    class func get(characters: [RealmCharacter], from startIndex: Int, success: @escaping ([Character]) -> (), failure: @escaping () -> ()) {
        let charactersGroup = DispatchGroup()
        if startIndex >= characters.count {
            failure()
            return
        }
        var charactersArray: [Character] = []
        for i in startIndex...startIndex+10 {
            charactersGroup.enter()
            // The end of the array has been reached so we just return the characters collected so far
            if i == characters.count {
                success(charactersArray)
                return
            }
            guard let url = URL(string: characters[i].urlString) else {
                continue
            }
            print("fetching character at index \(i)")
            Alamofire.request(url).responseJSON { (response) in
                print("got a response")
                if let responseValue = response.value {
                    let json = JSON(responseValue)
                    let character = Character(json: json)
                    charactersArray.append(character)
                    charactersGroup.leave()
                }
            }
        }
        charactersGroup.notify(queue: .main) {
            print("Characters finished fetching")
            success(charactersArray)
        }
    }
    
    class func get(houses: [RealmHouse], from startIndex: Int, success: @escaping ([House]) -> (), failure: @escaping () -> ()) {
        let housesGroup = DispatchGroup()
        if startIndex >= houses.count {
            failure()
            return
        }
        var housesArray: [House] = []
        for i in startIndex..<houses.count {
            housesGroup.enter()
            // The end of the array has been reached so we just return the houses collected so far
            if i == houses.count {
                success(housesArray)
                return
            }
            guard let url = URL(string: houses[i].urlString) else {
                continue
            }
            print("fetching house at index \(i)")
            Alamofire.request(url).responseJSON { (response) in
                print("got a house response")
                if let responseValue = response.value {
                    let json = JSON(responseValue)
                    let house = House(json: json)
                    housesArray.append(house)
                    housesGroup.leave()
                }
            }
        }
        housesGroup.notify(queue: .main) {
            print("Houses finished fetching")
            success(housesArray)
        }
    }
    
    
    
    
    class func getCharacterPhoto(characters: [Character], success: @escaping () -> (), failure: @escaping () -> ()) {
        let photosGroup = DispatchGroup()
        if characters.count == 0 {
            success()
        }
        var photosReceived = 0
        for character in characters {
            photosGroup.enter()
            let photoBaseUrl = "https://api.cognitive.microsoft.com/bing/v5.0/images/search"
            let parameters: Parameters = [
                "q": "\((character.playedBy?.first)!) \(character.name!) Game of Thrones",
                "size": "medium"
            ]
            let headers: HTTPHeaders = [
                "Ocp-Apim-Subscription-Key": "e6f86299db044621b6a632f383c03624",
                "Accept": "application/json"
            ]
            print("Starting request for \(character.name)")
            Alamofire.request(photoBaseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                photosReceived += 1
                photosGroup.leave()
                let json = JSON(response.value!)
                guard let imageUrlString = json["value"][0]["contentUrl"].string else {
                    return
                }
                if let imageUrl = URL(string: imageUrlString) {
                    character.imageUrl = imageUrl
                }
            }
        }
        photosGroup.notify(queue: .main) {
            print("finished all requests")
            success()
        }
    }
    
    class func setHouse(for character: Character, success: @escaping () -> (), failure: @escaping () -> ()) {
        if (character.allegiances?.isEmpty)! {
            return
        }
        let houseUrl = (character.allegiances?.first)!
        Alamofire.request(houseUrl).responseJSON { (response) in
            guard let responseValue = response.value else {
                failure()
                return
            }
            let json = JSON(responseValue)
            let house = House(json: json)
            character.house = house
            success()
        }
    }
    
    class func getCharacterWith(name: String, success: @escaping ([Character]) -> (), failure: @escaping () -> ()) {
        let nameEncoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let endpoint = "characters?name=\(nameEncoded!)"
        let characterUrl = URL(string: "\(baseUrl)\(endpoint)")
        guard let url = characterUrl else {
            failure()
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseArray = try! JSONSerialization.jsonObject(with: data, options:[]) as? [Dictionary<String, Any>] {
                    var characters: [Character] = []
                    for dictionary in responseArray {
                        //characters.append(Character(dictionary: dictionary))
                    }
                    success(characters)
                } else {
                    failure()
                }
            }
        })
        task.resume()
    }
    
    class func getHouseWith(name: String, success: @escaping ([House]) -> (), failure: @escaping () -> ()) {
        let nameEncoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let endpoint = "houses?name=\(nameEncoded!)"
        let houseUrl = URL(string: "\(baseUrl)\(endpoint)")
        guard let url = houseUrl else{
            failure()
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseArray = try! JSONSerialization.jsonObject(with: data, options:[]) as? [Dictionary<String, Any>] {
                    print("RESPONSE: \(responseArray)")
                    var houses: [House] = []
                    for dictionary in responseArray {
                        // houses.append(House(dictionary: dictionary))
                    }
                    success(houses)
                } else {
                    failure()
                }
            }
        })
        task.resume()
    }
}

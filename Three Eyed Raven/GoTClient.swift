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
                    let name = (characterJson["name"].string)!
                    let playedBy = (characterJson["playedBy"].array)!
                    // Save only characters who have a name and an associated actor
                    if (!name.isEmpty && !playedBy.isEmpty) {
                        let character = RealmCharacter(
                            value: [
                                "name": (characterJson["name"].string)!,
                                "urlString": (characterJson["url"].string)!,
                                "playedBy": (characterJson["playedBy"][0].string)!
                            ]
                        )
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
                    let name = (houseJson["name"].string)!
                    // Save only houses that have a name
                    if (!name.isEmpty) {
                        let house = RealmHouse(value: ["name": (houseJson["name"].string)!, "urlString": (houseJson["url"].string)!])
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
                charactersGroup.leave()
                break
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
            failure()
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
    
    class func getCharacter(fromUrlString urlString: String, success: @escaping (Character) -> (), failure: @escaping () -> ()) {
        guard let url = URL(string: urlString) else {
            failure()
            return
        }
        Alamofire.request(url).responseJSON { (response) in
            guard let responseValue = response.value else {
                failure()
                return
            }
            let characterJson = JSON(responseValue)
            let character = Character(json: characterJson)
            success(character)
        }
    }
    
    class func getCharacter(from image: UIImage, success: @escaping (Character) -> (), failure: @escaping () -> ()) {
        let realm = try! Realm()
        let photoBaseUrl = "https://westus.api.cognitive.microsoft.com/vision/v1.0/analyze?details=celebrities&language=en"
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "9344a729bc8845bfb9175b49e81e9be5",
            "Content-Type": "multipart/form-data"
        ]
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let parameters = ["name": "image"]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: photoBaseUrl, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let responseValue = response.result.value {
                        let json = JSON(responseValue)
                        let photoType = json["categories"][0]["name"].string
                        let celebrities = json["categories"][0]["detail"]["celebrities"]
                        if photoType == "people_" && celebrities.isEmpty == false {
                            let name = celebrities[0]["name"]
                            print(celebrities[0]["name"])
                            let characterResult = realm.objects(RealmCharacter.self).filter("playedBy = '\(name)'")
                            if !characterResult.isEmpty {
                                get(characters: characterResult.reversed(), from: 0, success: { (characters: [Character]) in
                                    success(characters.first!)
                                }, failure: { 
                                    failure()
                                })
                            }
                        } else {
                            print("Person not recognized")
                            failure()
                        }
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }

    }
}

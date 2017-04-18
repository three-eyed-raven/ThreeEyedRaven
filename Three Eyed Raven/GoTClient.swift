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

class GoTClient: NSObject {
    static let baseUrl = "https://www.anapioficeandfire.com/api/"
    static var page = 1
    
    class func getCharacters(success: @escaping ([Character]) -> (), failure: @escaping () -> ()) {
        var charactersArray: [Character] = []
        let endpoint = "characters?page=\(page)&pageSize=50"
        page += 1
        let charactersUrl = URL(string: "\(baseUrl)\(endpoint)")
        guard let url = charactersUrl else {
            failure()
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseArray = try! JSONSerialization.jsonObject(with: data, options:[]) as? [Dictionary<String, Any>] {
                    for dictionary in responseArray {
                        let name = dictionary["name"] as! String
                        let playedBy = dictionary["playedBy"] as! [String]
                        if !name.isEmpty && !playedBy.isEmpty {
                            let c = Character(dictionary: dictionary)
                            charactersArray.append(c)
                        }
                    }
                    for character in charactersArray {
                        setHouse(for: character, success: { 
                            
                        }, failure: { 
                            
                        })
                    }
                    getCharacterPhoto(characters: charactersArray, success: {
                        success(charactersArray)
                    }, failure: { 
                        
                    })
                } else {
                    failure()
                }
            }
        })
        task.resume()
    }
    
    class func getCharacterPhoto(characters: [Character], success: @escaping () -> (), failure: @escaping () -> ()) {
        if characters.count == 0 {
            success()
        }
        var photosReceived = 0
        for character in characters {
            let photoBaseUrl = "https://api.cognitive.microsoft.com/bing/v5.0/images/search"
            let parameters: Parameters = [
                "q": "\((character.playedBy?.first)!) Game of Thrones picture",
                "size": "small",
                "aspect": "square"
            ]
            let headers: HTTPHeaders = [
                "Ocp-Apim-Subscription-Key": "ba829953bc8245a7a0cd5b846d76443a",
                "Accept": "application/json"
            ]
            Alamofire.request(photoBaseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                photosReceived += 1
                let json = JSON(response.value)
                guard let imageUrlString = json["value"][0]["contentUrl"].string else {
                    return
                }
                if let imageUrl = URL(string: imageUrlString) {
                    character.imageUrl = imageUrl
                }
                if (photosReceived == characters.count) {
                    success()
                }
            }
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
                        characters.append(Character(dictionary: dictionary))
                    }
                    success(characters)
                } else {
                    failure()
                }
            }
        })
        task.resume()
    }
}

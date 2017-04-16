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
    
    class func getCharacters(success: @escaping ([Character]) -> (), failure: @escaping () -> ()) {
        var charactersArray: [Character] = []
        let endpoint = "characters?page=1&pageSize=50"
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
    
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func getCharacterPhoto(characters: [Character], success: @escaping () -> (), failure: @escaping () -> ()) {
        print(characters.count)
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
            print("getting image for \(character.name!)\n")
            Alamofire.request(photoBaseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                print("got image for \(character.name!)\n")
                photosReceived += 1
                let json = JSON(response.value)
                guard let imageUrlString = json["value"][0]["contentUrl"].string else {
                    return
                }
                if let imageUrl = URL(string: imageUrlString) {
                    character.imageUrl = imageUrl
                }
                print("photos received: \(photosReceived)\n")
                if (photosReceived == characters.count) {
                    print("last photo received\n")
                    success()
                }
            }
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

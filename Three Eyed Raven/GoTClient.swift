//
//  GoTClient.swift
//  Three Eyed Raven
//
//  Created by William Huang on 4/3/17.
//
//

import UIKit
import AFNetworking

class GoTClient: NSObject {
    static let baseUrl = "https://www.anapioficeandfire.com/api/"
    
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
                    //print("RESPONSE: \(responseArray)")
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
                        houses.append(House(dictionary: dictionary))
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

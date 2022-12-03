//
//  GameDataHttpClient.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//


import Foundation
import SwiftyJSON
import WebKit
enum NetworkError: Error{
    case badUrl
    case invalidResponse
    case decodingError
    case invalidURL
    case invalidServerResponse
}

class GameDataHttpClient{
    func getGameList(url:URL)async throws->[InitialGameDetails]{
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else{
            throw NetworkError.invalidResponse
        }
        
        guard let jsonData = try? JSON(data: data) else{
            throw NetworkError.decodingError
        }
      
        let results = jsonData["results"]
        var gameData:Array<InitialGameDetails> = []
        for result in results {
            gameData.append(InitialGameDetails(id: result.1["id"].intValue, name: result.1["name"].stringValue, background_image: result.1["background_image"].stringValue))
        }
        
        return gameData
    }
    
    func getGameDetails(url:URL)async throws->GameData{
        let (data,response) = try await URLSession.shared.data(from: url)
        print(url)
        guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else{
            throw NetworkError.invalidResponse
        }
        
        guard let jsonData = try? JSON(data: data) else{
            throw NetworkError.decodingError
        }
        
        var gameData:GameData = mockData()
        
        var platforms:Array<Platforms> = []
        var genre:Array<Genres> = []
        var stores:Array<Store> = []
        var tags:Array<Tags> = []
        var publisher:Array<Publisher> = []
        for result in jsonData["tags"]{
            tags.append(Tags(tags: result.1["name"].stringValue))
        }
        for result in jsonData["stores"] {
            stores.append(Store(name: result.1["store"]["name"].stringValue))
        }
        for result in jsonData["genres"]{
            genre.append(Genres(name: result.1["name"].stringValue))
        }
        for result in jsonData["publishers"] {
            publisher.append(Publisher(publisher: result.1["name"].stringValue))
        }
        for result in jsonData["platforms"] {
            platforms.append(Platforms(name: result.1["platform"]["name"].stringValue, image_background: result.1["platform"]["image_background"].stringValue, minimum: result.1["requirements"]["minimum"].stringValue, recommended:  result.1["requirements"]["recommended"].stringValue))
                
        }
           
        gameData = GameData(id: jsonData["id"].intValue, name: jsonData["name"].stringValue, background_image: jsonData["background_image"].stringValue, released: jsonData["released"].stringValue, rating: jsonData["rating"].doubleValue,description:jsonData["description_raw"].stringValue,platforms: platforms,genre: genre,stores: stores,tags:tags,publisher:publisher)
        
        return gameData
    }
    

}

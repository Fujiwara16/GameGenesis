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
    func getGameList(url:URL)async throws->[GameData]{
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else{
            throw NetworkError.invalidResponse
        }
        
        guard let jsonData = try? JSON(data: data) else{
            throw NetworkError.decodingError
        }
        let results = jsonData["results"]
        var gameData:Array<GameData> = []
        for result in results {
            var platforms:Array<Platforms> = []
            var genre:Array<Genres> = []
            var stores:Array<Store> = []
            print(result.1)
            for platform in result.1["platforms"]{
                //                print(platform.1)
                platforms.append(Platforms(name: platform.1["platform"]["name"].stringValue
                                           
                                          ))
            }
            for item in result.1["genres"]{
                genre.append(Genres(name: item.1["name"]["name"].stringValue
                                   ))
            }
            for item in result.1["stores"]{
                stores.append(Store(name: item.1["store"]["name"]["name"].stringValue
                                   ))
            }
            gameData.append(GameData(id: result.1["id"].intValue, name: result.1["name"].stringValue, background_image: result.1["background_image"].stringValue, released: result.1["released"].stringValue, rating: result.1["rating"].doubleValue,platforms: platforms,genre: genre,stores: stores))
        }
        
        return gameData
    }
    

}

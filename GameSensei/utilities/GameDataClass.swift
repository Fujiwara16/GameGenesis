//
//  GameDataClass.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import Foundation


struct GameData:Identifiable,Decodable{
    var id:Int
    var name:String
    var background_image:String
    var released:String
    var rating:Double
    var platforms:Array<Platforms>
    var genre:Array<Genres>
    var stores:Array<Store>
}
struct Genres:Decodable,Identifiable{
    var id:UUID = UUID()
    var name:String
 
}
struct Store:Decodable,Identifiable{
    var id:UUID = UUID()
    var name:String

}
struct Platforms:Decodable,Identifiable {
    var id:UUID = UUID()
    var name:String

}
func mockData()->GameData{
    let mock:GameData = GameData(id: 1, name: "no game present", background_image: "https://media.rawg.io/media/games/baf/baf9905270314e07e6850cffdb51df41.jpg", released: "", rating: 0.0,platforms: Array<Platforms>(),genre: Array<Genres>(), stores:Array<Store>())
    return mock
}

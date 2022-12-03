//
//  GameDataClass.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import Foundation


struct InitialGameDetails:Identifiable,Decodable{
    var id:Int
    var name:String
    var background_image:String
}

struct GameData:Identifiable,Decodable{
    var id:Int
    var name:String
    var background_image:String
    var released:String
    var rating:Double
    var description:String
    var platforms:Array<Platforms>
    var genre:Array<Genres>
    var stores:Array<Store>
    var tags:Array<Tags>
    var publisher:Array<Publisher>
}
struct Genres:Decodable,Identifiable{
    var id:UUID = UUID()
    var name:String
 
}
struct Store:Decodable,Identifiable{
    var id:UUID = UUID()
    var name:String
   
}
struct Publisher:Decodable,Identifiable{
    var id:UUID = UUID()
    var publisher:String
}
struct Tags:Decodable,Identifiable{
    var id:UUID = UUID()
    var tags:String
}
struct Platforms:Decodable,Identifiable {
    var id:UUID = UUID()
    var name:String
    var image_background:String
    var minimum:String
    var recommended:String

}
func mockData()->GameData{
    let mock:GameData = GameData(id: 1, name: "", background_image: "https://media.rawg.io/media/games/baf/baf9905270314e07e6850cffdb51df41.jpg", released: "", rating: 0.0, description:"" ,platforms: Array<Platforms>(),genre: Array<Genres>(), stores:Array<Store>(),tags: Array<Tags>(),publisher: Array<Publisher>())
    return mock
}


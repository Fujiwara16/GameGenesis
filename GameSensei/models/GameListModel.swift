//
//  GameListModel.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//


import Foundation
@MainActor
class GameListModel: ObservableObject {
    let client = GameDataHttpClient()
    
    @Published var action:Array<InitialGameDetails> = []
    @Published var indie:Array<InitialGameDetails> = []
    @Published var adventure:Array<InitialGameDetails> = []
    @Published var rpg:Array<InitialGameDetails> = []
    @Published var strategy:Array<InitialGameDetails> = []
    @Published var shooter:Array<InitialGameDetails> = []
    @Published var casual:Array<InitialGameDetails> = []
    @Published var simulation:Array<InitialGameDetails> = []
    @Published var puzzle:Array<InitialGameDetails> = []
    @Published var arcade:Array<InitialGameDetails> = []
    @Published var platformer:Array<InitialGameDetails> = []
    @Published var racing:Array<InitialGameDetails> = []
    @Published var sports:Array<InitialGameDetails> = []
    @Published var fighting:Array<InitialGameDetails> = []
    @Published var educational:Array<InitialGameDetails> = []
    @Published var card:Array<InitialGameDetails> = []
    @Published var family:Array<InitialGameDetails> = []
    @Published var selectedGame:GameData = mockData()
    @Published var selectedTag:String = "searchView"
    @Published var page:Int = Int.random(in: 1...40)
    @Published var selectedVideo = mockVideoData()
    
    func fetchGameList(page:Int) async throws {
        action = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "action"))
        indie = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "indie"))
        adventure = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "adventure"))
        strategy = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "strategy"))
        shooter = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "shooter"))
        casual = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "casual"))
        simulation = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "simulation"))
        puzzle = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "puzzle"))
        arcade = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "arcade"))
        platformer = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "platformer"))
        racing = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "racing"))
        sports = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "sports"))
        fighting = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "fighting"))
        educational = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "educational"))
        card = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "card"))
        family = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "family"))
    }
    
    func fetchGameDetails(id:Int)async throws{
        selectedVideo = try await client.getVideoUrl(videoFetchUrl: URL.finalVideoUrl(id: "\(id)"))
        selectedGame = try await client.getGameDetails(url: URL.finalDetURL(id: "\(id)"))
    }
    
}

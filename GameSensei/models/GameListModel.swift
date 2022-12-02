//
//  GameListModel.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import Foundation

import Foundation
@MainActor
class GameListModel: ObservableObject {
    let client = GameDataHttpClient()
    
    @Published var action:Array<GameData> = []
    @Published var indie:Array<GameData> = []
    @Published var adventure:Array<GameData> = []
    @Published var rpg:Array<GameData> = []
    @Published var strategy:Array<GameData> = []
    @Published var shooter:Array<GameData> = []
    @Published var casual:Array<GameData> = []
    @Published var simulation:Array<GameData> = []
    @Published var puzzle:Array<GameData> = []
    @Published var arcade:Array<GameData> = []
    @Published var platformer:Array<GameData> = []
    @Published var racing:Array<GameData> = []
    @Published var sports:Array<GameData> = []
    @Published var fighting:Array<GameData> = []
    @Published var educational:Array<GameData> = []
    @Published var card:Array<GameData> = []
    @Published var family:Array<GameData> = []
    
    
    
    func fetchGameList(page:Int) async throws {
        action = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "action"))
        indie = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "indie"))
        adventure = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "adventure"))
        rpg = try await client.getGameList(url:URL.finalListUrl(page:page,genre: "rpg"))
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
    
}

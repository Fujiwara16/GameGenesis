//
//  GameListModel.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//


import Foundation
import AVKit
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
    @Published var selectedTag:String = "gotyView"
    @Published var page:Int = Int.random(in: 1...40)
    @Published var selectedVideo = mockVideoData()
    @Published var videoUrl:URL?
    @Published var model:AVPlayer?
    
//    let queue = DispatchQueue(label: "com.app.concurrentQueue", attributes: .concurrent)
    func fetchGameList(page:Int) async throws {
        async let action = try client.getGameList(url:URL.finalListUrl(page:page,genre: "action"))
        async let indie = try client.getGameList(url:URL.finalListUrl(page:page,genre: "indie"))
        async let adventure = try client.getGameList(url:URL.finalListUrl(page:page,genre: "adventure"))
        async let strategy = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "strategy"))
        async let shooter = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "shooter"))
        async let casual = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "casual"))
        async let simulation = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "simulation"))
        async let puzzle = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "puzzle"))
        async let arcade = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "arcade"))
        async let platformer = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "platformer"))
        async let racing = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "racing"))
        async let sports = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "sports"))
        async let fighting = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "fighting"))
        async let educational = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "educational"))
        async let card = try client.getGameList(url:URL.finalListUrl(page:page,genre: "card"))
        async let family = try  client.getGameList(url:URL.finalListUrl(page:page,genre: "family"))
        self.action = try await action
        self.indie = try await indie
        self.adventure = try await adventure
        self.strategy = try await strategy
        self.shooter = try await shooter
        self.casual = try await casual
        self.puzzle = try await puzzle
        self.simulation = try await simulation
        self.arcade = try await arcade
        self.racing = try  await racing
        self.platformer = try  await platformer
        self.indie = try await indie
        self.family = try await family
        self.card = try await card
        self.educational = try await educational
        self.fighting = try await fighting
        self.sports = try await sports

   
        
    }
    
    func fetchGameDetails(id:Int)async throws{
       
//        selectedVideo = try await client.getVideoUrl(videoFetchUrl: URL.finalVideoUrl(id: "\(id)"))\
        selectedGame = try await client.getGameDetails(url: URL.finalDetURL(id: "\(id)"))
        
        videoUrl = URL(string: selectedGame.videoUrl)
        if(!selectedGame.videoUrl.isEmpty){
            model = AVPlayer(url: videoUrl!)
        }
    }
    
}

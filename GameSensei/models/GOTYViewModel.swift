//
//  GOTYViewModel.swift
//  GameSensei
//
//  Created by Nij Mehar on 06/12/22.
//

import Foundation
import SwiftUI
@MainActor
class GOTYViewModel:ObservableObject{
    @Published var gotyList:Array<InitialGameDetails> = []
    @Published var selectedGame:GameData = mockData()
    @Published var selectedVideo = mockVideoData()
    @Published var topColor:Color = .black
    @Published var bottomColor:Color = .purple
    @Published var wholeSize: CGSize = .zero
    @Published var scrollViewSize: CGSize = .zero
    @Published var page:Int = Int.random(in: 1...40)
    let client = GameDataHttpClient()

    func fetchGameList(page:Int) async throws{
        gotyList = try await client.getGameList(url: URL.finalBestOfYearUrl(page:page))
    }
    
    func fetchGameDetails(id:Int)async throws{
//        selectedVideo = try await client.getVideoUrl(videoFetchUrl: URL.finalVideoUrl(id: "\(id)"))
        selectedGame = try await client.getGameDetails(url: URL.finalDetURL(id: "\(id)"))
    }
}

//
//  searchViewModel.swift
//  GameSensei
//
//  Created by Nij Mehar on 05/12/22.
//

import Foundation
import SwiftUI
@MainActor
class SearchViewModel:ObservableObject {
    let client = GameDataHttpClient()
    
    @Published var errorMessage = ""
    @Published var searchedGames:Array<InitialGameDetails> = []
    @Published var selectedGame:InitialGameDetails?
    @Published var searchSelectedGame:GameData = mockData()
    @Published var searchText = ""
    
    var topColor:Color = .black
    var bottomColor:Color = .purple
    var page:Int = 1
    func fetchSearchedGame()async throws{
        if(!searchText.isEmpty)
        {
            searchedGames = try await client.getGameList(url: URL.finalGameSearchUrl(searchText: searchText))
        }
    }

}

//
//  ContentView.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import SwiftUI

struct MainPageView: View {
    @StateObject private var gameListModel:GameListModel = GameListModel()
 
    @State private var searchText = ""
    
    @Environment(\.isSearching) private var isSearching
 
    
    init() {
            //Use this if NavigationBarTitle is with Large Font
        UITabBar.appearance().isHidden = true
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = .black
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    
    
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            TabView(selection: $gameListModel.selectedTag){
                
                GenreView(gameListModel: gameListModel)
                    .tag("genreView")
                SearchView()
                    .tag("searchView")
            }
            HStack(spacing:30){
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .renderingMode(.original)
                    .fontWeight(gameListModel.selectedTag == "searchView" ? .bold : .thin)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .onTapGesture {
                        gameListModel.selectedTag = "searchView"
                    }
                Image(systemName: "tray.full")
                    .resizable()
                    .renderingMode(.original)
                    .fontWeight(gameListModel.selectedTag == "genreView" ? .bold : .thin)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .onTapGesture {
                        gameListModel.selectedTag = "genreView"
                    }
            }
            .frame(width: 130,height: 40)
            .padding(.all,8)
            .background(Color("translucent"))
            .cornerRadius(20)
            .shadow(radius: 8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}


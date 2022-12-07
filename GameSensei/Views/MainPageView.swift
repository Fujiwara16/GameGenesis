//
//  ContentView.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import SwiftUI

struct MainPageView: View {
    @StateObject private var gameListModel:GameListModel = GameListModel()
    @EnvironmentObject private var launchScreenState: LaunchViewModel
    @State private var searchText = ""
    
    @Environment(\.isSearching) private var isSearching
 
    
    init() {
            //Use this if NavigationBarTitle is with Large Font
        UITabBar.appearance().isHidden = true
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white,.font: UIFont.systemFont(ofSize: 30,weight: .bold)]
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    
    
    
    var body: some View {
       GeometryReader{
           proxy in
           ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            TabView(selection: $gameListModel.selectedTag){
                GOTYView()
                    .tag("gotyView")
                GenreView()
                    .tag("genreView")
                SearchView()
                    .tag("searchView")
            }.environmentObject(gameListModel)
            HStack(spacing:30){
                Image(systemName: "star")
                    .resizable()
                    .renderingMode(.template)
                    .fontWeight(gameListModel.selectedTag == "gotyView" ? .bold : .thin)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .foregroundColor(.white)
                    .onTapGesture {
                        gameListModel.selectedTag = "gotyView"
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

            }
            .frame(width: proxy.size.width-200,height: 40)
            .padding(.all,8)
            .background(Color("translucent"))
            .cornerRadius(20)
            .shadow(radius: 8)
            .padding(.bottom,10)
        }}.task {
            
            try? await Task.sleep(for: Duration.seconds(2))
            self.launchScreenState.dismiss()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
            .environmentObject(LaunchViewModel())
    }
}


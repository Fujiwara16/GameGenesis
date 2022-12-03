//
//  ContentView.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import SwiftUI

struct GameListView: View {
    @StateObject private var gameListModel:GameListModel = GameListModel()
    @State private var errorMessage = ""
 
    private var topColor:Color = .black
    private var bottomColor:Color = .purple
    private var page:Int = 1
    @State private var searchText = ""
    @Environment(\.isSearching) private var isSearching
 
    
    init() {
            //Use this if NavigationBarTitle is with Large Font
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = .black
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(colors: [topColor,bottomColor], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                ScrollView{
                    VStack(spacing:40){
                        
                        GenreStack(arr:gameListModel.action,genre: "Action")
                        GenreStack(arr:gameListModel.indie,genre: "Indie")
                        GenreStack(arr:gameListModel.adventure,genre: "Adventure")
                        GenreStack(arr:gameListModel.strategy,genre: "Strategy")
                        GenreStack(arr:gameListModel.shooter,genre: "Shooter")
                        GenreStack(arr:gameListModel.casual,genre: "Casual")
                        GenreStack(arr:gameListModel.simulation,genre: "Simulation")
                        GenreStack(arr:gameListModel.platformer,genre: "Platformer")
                       
                        VStack(spacing:40){
                            GenreStack(arr:gameListModel.racing,genre: "Racing")
                            GenreStack(arr:gameListModel.sports,genre: "Sports")
                            GenreStack(arr:gameListModel.fighting,genre: "Fighting")
                            GenreStack(arr:gameListModel.educational,genre: "Educational")
                            GenreStack(arr:gameListModel.card,genre: "Card")
                            GenreStack(arr:gameListModel.family,genre: "Family")
                        }
                        
                    }
                }
            }
                .navigationTitle(Text("Games"))
                
                .searchable(text: $searchText)
                
            
        }
//        .background(Color.black)
        .task{
            do{
                try await gameListModel.fetchGameList(page:page)
                
            }
            catch{
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView()
    }
}
struct SearchButton: View {
@State private var showModal = false
var body: some View {
    VStack {
        Button(action: {
            doAction()
        }) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .imageScale(.small)
                .frame(width: 26, height: 26)
                .padding(EdgeInsets.init(top: 90, leading: 0, bottom: 0, trailing: -10))
                .foregroundColor(Color.white)

        }
    }
    .padding(.horizontal)
}

func doAction() {
    
}
}

struct GenreStack: View{
     var arr:Array<InitialGameDetails>
     var genre:String
    @State private var selectedGame:InitialGameDetails?
    var body:some View{
        GeometryReader{
            proxy in
            VStack(alignment:.leading){
                Text(genre)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading,20)
                
                ScrollView(.horizontal,showsIndicators: false) {
                    LazyHStack {
                        ForEach(arr){ item in
                            VStack{
                                    AsyncImage(url: URL.finalImageUrl(imageurl: item.background_image)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width:proxy.size.width - 30,height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                                .shadow(radius: 20)
                                        case .failure(let error):
                                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width:proxy.size.width - 50,height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                            let _ = print(error)
                                            Text("error: \(error.localizedDescription)")
                                        case .empty:
                                            ProgressView().foregroundColor(.white)
                                        @unknown default:
                                            fatalError()
                                        }
                                    
                                    }.onTapGesture {
                                        selectedGame = item
                                    }
                                Text(item.name)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                            }.frame(width:proxy.size.width)
                            
                            
                            
                        }
                    }
                }.frame(height:300)
            }
        }.frame(height: 300)
            .sheet(item: $selectedGame){selectedGame in
                GameDet(imageurl: selectedGame.background_image, id:selectedGame.id)
            }
    }
}

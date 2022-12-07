//
//  GenreView.swift
//  GameSensei
//
//  Created by Nij Mehar on 05/12/22.
//

import SwiftUI

struct GenreView: View {
    @EnvironmentObject private var gameListModel:GameListModel
    @State  var errorMessage = ""
    var topColor:Color = .black
    var bottomColor:Color = .purple
    
    var body:some View{
        NavigationView{
            ZStack{
//                LinearGradient(colors: [topColor,bottomColor], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                Color.black
                    .ignoresSafeArea(.all)
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
                .refreshable {
                    Task{
                        do{
                            gameListModel.page = Int.random(in: 1...40)
                            try await gameListModel.fetchGameList(page:gameListModel.page)
                        }
                        catch{
                            errorMessage = error.localizedDescription
                        }
                        
                    }
                }
            } .navigationTitle(Text("Genres"))
                
        }.environmentObject(gameListModel)
        .task{
            do{
//                gameListModel.page = Int.random(in: 1...40)
                try await gameListModel.fetchGameList(page:gameListModel.page)
            }
            catch{
                errorMessage = error.localizedDescription
            }
        }
       
   
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView()
        
            .environmentObject(GameListModel())
    }
}

struct SearchButton: View {
@State private var showModal = false
var body: some View {
    VStack {
        Button(action: {
            
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
}

struct GenreStack: View{
    @EnvironmentObject var gameListModel:GameListModel
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
                    LazyHStack(spacing:10) {
                        ForEach(arr){ item in

                                    AsyncImage(url: URL.finalImageUrl(imageurl: item.background_image), transaction: Transaction(animation: .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
                                        VStack{
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .frame(width:proxy.size.width - 150,height: 200)
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                                    .shadow(radius: 20)
                                                    .transition(.opacity)
                                                    .transition(.scale)
                                            case .failure(_):
                                                Color("translucent")
                                                    .frame(width:proxy.size.width - 150,height: 200)
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                            case .empty:
                                                Color("translucent")
                                                    .frame(width:proxy.size.width - 150,height: 200)
                                                    .aspectRatio(contentMode: .fill)
                                                
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                            @unknown default:
                                                fatalError()
                                            }
                                            Text(item.name)
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                        }
                                    }.frame(width:proxy.size.width - 130)
                            
                                .onTapGesture {
                                    Task{
                                        do{
                                            try await gameListModel.fetchGameDetails(id: item.id)
                                        }
                                        catch{
                                            return
                                        }
                                    }
                                    selectedGame = item
                                }
                        }
                    }
                }.frame(height:250)
            }
        }.frame(height: 260)
            .sheet(item: $selectedGame,onDismiss: didDismiss){selectedGame in
                GameDet(imageurl: selectedGame.background_image, id:selectedGame.id)
                    .environmentObject(gameListModel)
            }
    }
    func didDismiss() {
        gameListModel.model?.pause()
    }
}

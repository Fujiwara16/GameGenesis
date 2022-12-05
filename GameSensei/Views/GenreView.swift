//
//  GenreView.swift
//  GameSensei
//
//  Created by Nij Mehar on 05/12/22.
//

import SwiftUI

struct GenreView: View {
    @StateObject var gameListModel:GameListModel
    @State  var errorMessage = ""
    var topColor:Color = .black
    var bottomColor:Color = .purple
    var page:Int = 1
    var body:some View{
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
        }
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

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView(gameListModel: GameListModel())
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
                            VStack{
                                    AsyncImage(url: URL.finalImageUrl(imageurl: item.background_image)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width:proxy.size.width - 150,height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                                .shadow(radius: 20)
                                        case .failure(_):
                                            ProgressView().foregroundColor(.white)
                                        case .empty:
                                            ProgressView().foregroundColor(.white)
                                        @unknown default:
                                            fatalError()
                                        }
                                    }
                                Text(item.name)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                            }.frame(width:proxy.size.width - 130)
                                .onTapGesture {
                                    selectedGame = item
                                }
                        }
                    }
                }.frame(height:250)
            }
        }.frame(height: 260)
            .sheet(item: $selectedGame){selectedGame in
                GameDet(imageurl: selectedGame.background_image, id:selectedGame.id)
            }
    }
}

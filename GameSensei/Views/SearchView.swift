//
//  SearchView.swift
//  GameSensei
//
//  Created by Nij Mehar on 05/12/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchedViewModel = SearchViewModel()
    @EnvironmentObject var gameListModel:GameListModel
    var body: some View {
        
        GeometryReader{proxy in
            NavigationView{
                ZStack{
//                    LinearGradient(colors: [searchedViewModel.topColor,searchedViewModel.bottomColor], startPoint: .top, endPoint: .bottom)
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    ScrollView(.vertical) {
                        TextField("example text", text: $searchedViewModel.searchText)
                            .frame(width: proxy.size.width-60,height: 15)
                            .padding(.all,14)
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                            .padding(.all,20)
                            .shadow(radius: 8)
                            .onSubmit {
                                Task {
                                    do{
                                        try await searchedViewModel.fetchSearchedGame()
                                    }
                                    catch{
                                        print(error)
                                    }
                                }
                            }
                            LazyVStack(spacing:10) {
                                ForEach(searchedViewModel.searchedGames){ item in
                                   
                                    AsyncImage(url: URL.finalImageUrl(imageurl: item.background_image), transaction: Transaction(animation: .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
                                        VStack{
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .frame(width:proxy.size.width - 60,height: 200)
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                                    .shadow(radius: 20)
                                                    .transition(.opacity)
                                                    .transition(.scale)
                                            case .failure(_):
                                                Color("translucent")
                                                    .frame(width:proxy.size.width - 60,height: 200)
                                                    .aspectRatio(contentMode: .fill)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                            case .empty:
                                                Color("translucent")
                                                    .frame(width:proxy.size.width - 60,height: 200)
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
                                        searchedViewModel.selectedGame = item
                                    }
                                    
                                    .frame(width:proxy.size.width-10,height: 280)
                                       
                                }
                            }
                        
                    }.frame(width:proxy.size.width-10)
                        .refreshable {
                            Task{
                                do{
                                try await searchedViewModel.fetchSearchedGame()
                            }
                                catch{
                                    print(error)
                                }
                                
                            }
                        }
                    
                }
                    .navigationTitle(Text("Search"))
                    .onAppear{
                        if(!searchedViewModel.searchText.isEmpty){
                            Task{
                                do{
                                try await searchedViewModel.fetchSearchedGame()
                            }
                                catch{
                                    print(error)
                                }
                                
                            }
                        }
                    }
                   
            }
            .sheet(item: $searchedViewModel.selectedGame,onDismiss: didDismiss){selectedGame in
                GameDet(imageurl: selectedGame.background_image, id:selectedGame.id)
                    .environmentObject(gameListModel)
            }
        }
    }
    func didDismiss() {

        gameListModel.model?.pause()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(GameListModel())
    }
}

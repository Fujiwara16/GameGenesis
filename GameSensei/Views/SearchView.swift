//
//  SearchView.swift
//  GameSensei
//
//  Created by Nij Mehar on 05/12/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchedViewModel = SearchViewModel()

    var body: some View {
        
        GeometryReader{proxy in
            NavigationView{
                ZStack{
                    LinearGradient(colors: [searchedViewModel.topColor,searchedViewModel.bottomColor], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                    ScrollView{
                        TextField("ex: Grand Theft Auto", text: $searchedViewModel.searchText)
                            .frame(width: proxy.size.width-60)
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
                        
                        ScrollView(.vertical,showsIndicators: false) {
                            LazyVStack(spacing:10) {
                                ForEach(searchedViewModel.searchedGames){ item in
                                    VStack(spacing:20){
                                            AsyncImage(url: URL.finalImageUrl(imageurl: item.background_image)) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .frame(width:proxy.size.width - 60,height: 200)
                                                        .aspectRatio(contentMode: .fill)
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
                                            .lineLimit(1)
                                            .foregroundColor(.white)
                                            .padding(.bottom,20)
                                        
                                    }
                                    .onTapGesture {
                                        searchedViewModel.selectedGame = item
                                    }
                                    
                                    .frame(width:proxy.size.width-10,height: 280)
                                       
                                }
                            }
                        }.frame(width:proxy.size.width-10)
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
            .sheet(item: $searchedViewModel.selectedGame){selectedGame in
                GameDet(imageurl: selectedGame.background_image, id:selectedGame.id)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

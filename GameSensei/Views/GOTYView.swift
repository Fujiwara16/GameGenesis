//
//  GOTYView.swift
//  GameSensei
//
//  Created by Nij Mehar on 06/12/22.
//

import SwiftUI

struct GOTYView: View {
    @EnvironmentObject private var gameListModel:GameListModel
    @StateObject private var gotyViewModel = GOTYViewModel()
    var body: some View {
        GeometryReader{
            proxy in
            NavigationView{
                ZStack{
                    LinearGradient(colors: [gotyViewModel.topColor,gotyViewModel.bottomColor], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea(.all)
                    GridView(width: proxy.size.width, gotyViewModel:gotyViewModel,arr:gotyViewModel.gotyList)
                        .navigationTitle("Best of the year")
                }.task {
                    do{
                        gotyViewModel.page = Int.random(in: 1...20)
                        try await gotyViewModel.fetchGameList(page:gotyViewModel.page)
                    }catch{
                        return
                    }
                }
                
            }.environmentObject(GameListModel())
        }
    }
}

struct GOTYView_Previews: PreviewProvider {
    static var previews: some View {
        GOTYView()
            .environmentObject(GameListModel())
    }
}


struct GridView:View{
    let columns = [
            GridItem(.adaptive(minimum: 150))
        ]
    @EnvironmentObject var gameListModel:GameListModel
    @State var selectedGame:InitialGameDetails?
    var width:CGFloat
    @StateObject var gotyViewModel:GOTYViewModel
    var arr:Array<InitialGameDetails>
    var body: some View{
        ScrollView(.vertical){
           LazyVGrid(columns: columns,spacing: 40){
               ForEach(arr) { item in
                   VStack{
                           AsyncImage(url: URL.finalImageUrl(imageurl: item.background_image)) { phase in
                               switch phase {
                               case .success(let image):
                                   image
                                       .resizable()
                                       .frame(width:160,height: 130)
                                       .aspectRatio(contentMode: .fill)
                                       .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                       .shadow(radius: 20)
                               case .failure(_):
                                   ProgressView().foregroundColor(.white)
                                       .frame(width:160,height: 130)
                               case .empty:
                                   ProgressView().foregroundColor(.white)
                                       .frame(width:160,height: 130)
                               @unknown default:
                                   fatalError()
                               }
                           }
                       Text(item.name)
                           .font(.subheadline)
                           .lineLimit(1)
                           .fontWeight(.bold)
                           .foregroundColor(.white)
                       
                   }.frame(width:150)
                       .onTapGesture {
                           selectedGame = item
                       }
               }
            }.padding(.all,8)
        }.background(
            GeometryReader { proxy in
                Color.clear.onAppear { print(proxy.size.height) }
            }
        )
        
        .sheet(item: $selectedGame,onDismiss: didDismiss){selectedGame in
            GameDet(imageurl: selectedGame.background_image, id:selectedGame.id)
                .environmentObject(GameListModel())
        }
    }
    func didDismiss() {
    
        gameListModel.model?.pause()
    }
}

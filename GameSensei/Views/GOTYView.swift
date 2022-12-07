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
//                    LinearGradient(colors: [gotyViewModel.topColor,gotyViewModel.bottomColor], startPoint: .top, endPoint: .bottom)
                    Color.black
                        .ignoresSafeArea(.all)
                    GridView(width: proxy.size.width, gotyViewModel:gotyViewModel,arr:gotyViewModel.gotyList)
                       
                } .navigationTitle("Best of the year")
                .task {
                    do{
                        gotyViewModel.page = Int.random(in: 1...20)
                        try await gotyViewModel.fetchGameList(page:gotyViewModel.page)
                    }catch{
                        return
                    }
                }
                
            }.environmentObject(gameListModel)
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
                
                   
                   
                   AsyncImage(url: URL.finalImageUrl(imageurl: item.background_image), transaction: Transaction(animation: .spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
                       VStack{
                           switch phase {
                           case .success(let image):
                               image
                                   .resizable()
                                   .frame(width:160,height: 130)
                                   .aspectRatio(contentMode: .fill)
                                   .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                                   .shadow(radius: 20)
                                   .transition(.opacity)
                                   .transition(.scale)
                           case .failure(_):
                               Color("translucent")
                                   .frame(width:160,height: 130)
                                   .aspectRatio(contentMode: .fill)
                               
                                   .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                           case .empty:
                               Color("translucent")
                                   .frame(width:160,height: 130)
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
                   }.frame(width:150)
                   
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
            }.padding(.all,8)
        }.refreshable {
            Task{
                do{
                    gotyViewModel.page = Int.random(in: 1...20)
                    try await gotyViewModel.fetchGameList(page:gotyViewModel.page)
                }catch{
                    return
                }
                
            }
        }
       
        
        .sheet(item: $selectedGame,onDismiss: didDismiss){selectedGame in
            GameDet(imageurl: selectedGame.background_image, id:selectedGame.id)
                .environmentObject(gameListModel)
        }
    }
    func didDismiss() {
    
        gameListModel.model?.pause()
    }
}

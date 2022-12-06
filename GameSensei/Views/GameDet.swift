//
//  GameDet.swift
//  GameSensei
//
//  Created by Nij Mehar on 02/12/22.
//

import SwiftUI
import AVKit
struct GameDet: View {
    var topColor:Color = .black
    var bottomColor:Color = .purple
    var imageurl:String
    @State private var canDismiss = true
    @State private var errorMessage = ""
    @EnvironmentObject private var gameListModel:GameListModel
    var id:Int
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                LinearGradient(colors: [topColor,bottomColor], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                ScrollView(.vertical){
                    VStack(alignment: .center){
                        Text(gameListModel.selectedGame.name)
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.all,20)
                        Text("Release: \(gameListModel.selectedGame.released)")
                            .font(.subheadline)
                            .padding(.leading,20)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .leading)
                        AsyncImage(url: URL.finalImageUrl(imageurl: imageurl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:proxy.size.width - 30,height: 400)
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
                        }.padding(.bottom,19)
                        
                        VStack{
                            Tag(arr: gameListModel.selectedGame.tags,type: "Tags", width: proxy.size.width)
                            Publishers(arr: gameListModel.selectedGame.publisher,type: "Publishers", width: proxy.size.width)
                            Description(selectedGame:gameListModel.selectedGame,type:"Description",width:proxy.size.width)
                            if(!gameListModel.selectedGame.videoUrl.isEmpty)
                            {
                                VideoPlayer(player: gameListModel.model)
                                    .frame(width: proxy.size.width-50, height: 200)
                                    .cornerRadius(10)
                                    .onAppear{
                                        canDismiss = false
                                    }
                                
                                
                            }
                            GenresData(arr: gameListModel.selectedGame.genre,type: "Genres", width: proxy.size.width)
                            
                            StoreStack(arr: gameListModel.selectedGame.stores,type: "Stores", width: proxy.size.width)
                        
                            PlatformStack(arr: gameListModel.selectedGame.platforms,type: "Platforms", width: proxy.size.width)
                            
                            }.frame(width:proxy.size.width-40,alignment: .center)
                                .padding(.all,10)
                                .background(Color("barTintcolor"))
                                .cornerRadius(10)
                                .opacity(gameListModel.selectedGame.description.isEmpty ? 0 : 1)
                                .shadow(radius: 10)
                                
                    }
                        .task{
                            do{
                                try await gameListModel.fetchGameDetails(id: id)
                            }
                            catch{
                                errorMessage = error.localizedDescription
                            }
                        }
                        .gesture(
                           DragGesture().onChanged { value in

                               print(canDismiss)
                               if(gameListModel.selectedGame.videoUrl != "" && gameListModel.model!.isPlaying)
                                    {
                                        canDismiss = true
                                    
                                    }
                               else{
                                   canDismiss = false
                               }
                           }
                        )
                }
            }
        }
        .interactiveDismissDisabled(canDismiss)
        
    }
}

struct GameDet_Previews: PreviewProvider {
    static var previews: some View {
        GameDet(imageurl: "https://media.rawg.io/media/games/baf/baf9905270314e07e6850cffdb51df41.jpg", id: 3498)
            .environmentObject(GameListModel())
    }
}
//struct AVPlayerView: UIViewControllerRepresentable {
//    @EnvironmentObject private var gameListModel:GameListModel
//    var videoURL: URL?
//
//    private var player: AVPlayer {
//        return AVPlayer(url: videoURL!)
//    }
//
//    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
//        playerController.modalPresentationStyle = .fullScreen
//        playerController.player = player
//        gameListModel.canBeDismissed = true
//    }
//
//    func makeUIViewController(context: Context) -> AVPlayerViewController {
//        return AVPlayerViewController()
//    }
//}
struct Description:View{
    var selectedGame:GameData
    var type:String
    var width:CGFloat
    var body:some View{
        VStack(alignment:.leading){
            Text(type)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading,10)
            HStack{
                Text("Rating: \(selectedGame.rating)")
                    .font(.subheadline)
                    .padding(.leading,10)
                    .foregroundColor(.yellow)
                    .frame(alignment: .leading)
                    
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 15)
            }
                
            Text(selectedGame.description)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1000)
                .foregroundColor(.white)
                
                .frame(width:width-40,alignment: .center)
                .padding(.all,10)
                
        }.opacity(selectedGame.description.isEmpty ? 0 : 1)
    }}

struct PlatformStack: View{
    var arr:Array<Platforms>
    var type:String
    var width:Double
    var body:some View{
        VStack(alignment:.leading){
            Text(type)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .center, spacing: 10) {
                    ForEach(arr){ item in
                        Text(item.name)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .padding(.all,10)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
                
            } .padding(.bottom,10)
            VStack(spacing: 10) {
                ForEach(arr,id: \.id){ item in
                    if(!item.minimum.isEmpty){
                        VStack(alignment:.leading){
                            
                            Text(item.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                            
                            Text(item.minimum)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1000)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                            Text(item.recommended)
                                .font(.subheadline)
                                .lineLimit(1000)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                        }
                    }
                }
            }
            
        }.frame(width:width-40,alignment: .leading)
            .padding(.all,10)
            .opacity(arr.isEmpty ? 0 : 1)
            .cornerRadius(10)
            .shadow(radius: 10)
        
    }
}
struct GenresData: View{
    var arr:Array<Genres>
    var type:String
    var width:CGFloat
    var body:some View{
        VStack(alignment:.leading){
            Text(type)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .center, spacing: 10) {
                    ForEach(arr){ item in
                        
                        
                        Text(item.name)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .padding(.all,10)
                            .background(Color.black)
                            .cornerRadius(10)
                        
                        
                    }
                }
                
            }
            
            
            
            
            
        }.frame(width:width-40,alignment: .leading)
            .padding(.bottom,10).opacity(arr.isEmpty ? 0 : 1)
    }
}
struct StoreStack: View{
    var arr:Array<Store>
    var type:String
    var width:CGFloat
    var body:some View{
        VStack(alignment:.leading){
            Text(type)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .center, spacing: 10) {
                    ForEach(arr){ item in
                        
                        
                        Text(item.name)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .padding(.all,10)
                            .background(Color.black)
                            .cornerRadius(10)

                    }
                }
                
            }
            
        }.frame(width:width-40,alignment: .leading)
            .padding(.bottom,10).opacity(arr.isEmpty ? 0 : 1)
    }
}
struct Tag:View{
    var arr:Array<Tags>
    var type:String
    var width:CGFloat
    var body:some View{
        VStack(alignment:.leading){
            Text(type)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .center, spacing: 10) {
                    ForEach(arr){ item in
                        
                        
                        Text(item.tags)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .padding(.all,10)
                            .background(Color.black)
                            .cornerRadius(10)

                    }
                }
                
            }
            
        }.frame(width:width-40,alignment: .leading)
            .padding(.bottom,10).opacity(arr.isEmpty ? 0 : 1)
    }
}
struct Publishers:View{
    var arr:Array<Publisher>
    var type:String
    var width:CGFloat
    var body:some View{
        VStack(alignment:.leading){
            Text(type)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .center, spacing: 10) {
                    ForEach(arr){ item in
                        
                        
                        Text(item.publisher)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(0)
                            .foregroundColor(.white)
                            .padding(.all,10)
                            .background(Color.black)
                            .cornerRadius(10)

                    }
                }
                
            }
            
        }.frame(width:width-40,alignment: .leading)
            .padding(.bottom,10).opacity(arr.isEmpty ? 0 : 1)
    }
}
struct Videos:View{
    var arr:Array<Video>
    var type:String
    var width:CGFloat
    var body:some View{
        VStack(alignment:.leading){
            Text(type)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .center, spacing: 10) {
                    ForEach(arr){ item in
                        
                        
                    }
                }
                
            }
            
        }.frame(width:width-40,alignment: .leading)
            .padding(.bottom,10).opacity(arr.isEmpty ? 0 : 1)
    }
    
}

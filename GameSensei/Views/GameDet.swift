//
//  GameDet.swift
//  GameSensei
//
//  Created by Nij Mehar on 02/12/22.
//

import SwiftUI

struct GameDet: View {
    var topColor:Color = .black
    var bottomColor:Color = .purple
    var imageurl:String
    @State private var errorMessage = ""
    @StateObject private var gameListModel:GameListModel = GameListModel()
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
                            GenresData(arr: gameListModel.selectedGame.genre,type: "Genres", width: proxy.size.width)
                                
                            StoreStack(arr: gameListModel.selectedGame.stores,type: "Stores", width: proxy.size.width)
                               
                            PlatformStack(arr: gameListModel.selectedGame.platforms,type: "Platforms", width: proxy.size.width)
                                
                                
                            Text("\n")
                        }
                    }
                        .task{
                            do{
                                try await gameListModel.fetchGameDetails(id: id)
//                                arr = gameListModel.selectedGame.platforms
                                
                            }
                            catch{
                                errorMessage = error.localizedDescription
                            }
                        }
                    
                }
            }
        }
    }
}

struct GameDet_Previews: PreviewProvider {
    static var previews: some View {
        GameDet(imageurl: "https://media.rawg.io/media/games/baf/baf9905270314e07e6850cffdb51df41.jpg", id: 3498)
    }
}
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
                .padding(.leading,20)
            
           
            VStack(alignment: .center, spacing: 10) {
                ForEach(arr){ item in
                        VStack{
                          
                            Text(item.name)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .lineLimit(0)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                            Text(item.minimum)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .lineLimit(1000)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                            Text(item.recommended)
                                .font(.subheadline)
                                .lineLimit(1000)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                            
                        }
                        
                    }
            }
            .frame(width:width-40,alignment: .center)
                .padding(.all,10)
                .background(Color.black)
                .cornerRadius(10)
            
        
        }
         
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
                .padding(.leading,20)
            
           
            VStack(alignment: .center, spacing: 10) {
                ForEach(arr){ item in
                        VStack{
                          
                            Text(item.name)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .lineLimit(0)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                          
                        }
                        
                    }
            }
            .frame(width:width-40,alignment: .center)
                .padding(.all,10)
                .background(Color.black)
                .cornerRadius(10)
            
        
        }
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
                .padding(.leading,20)
            
           
            VStack(alignment: .center, spacing: 10) {
                ForEach(arr){ item in
                        VStack{
                          
                            Text(item.name)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .lineLimit(0)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                         
                        }
                        
                    }
            }
            .frame(width:width-40,alignment: .center)
                .padding(.all,10)
                .background(Color.black)
                .cornerRadius(10)
            
        
        }

    }
}
//struct DisplayData:View{
//    var url:String
//    var name:String
//    var width:CGFloat
//    var minimum:String
//    var recommended:String
//    var body:some View{
//
//
//    }
//}

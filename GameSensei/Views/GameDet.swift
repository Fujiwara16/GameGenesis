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
    var selectedGame:GameData
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                LinearGradient(colors: [topColor,bottomColor], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                ScrollView{
                    VStack{
                        Text(selectedGame.name)
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.all,20)
                        AsyncImage(url: URL.finalImageUrl(imageurl: selectedGame.background_image)) { phase in
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
                                
                            
                            PlatformStack(arr: selectedGame.platforms, type: "Platforms")
                            
                            
                            Spacer()
                        }
                    }.task {
                       
                    }
                }
            }
        }
    }
}

struct GameDet_Previews: PreviewProvider {
    static var previews: some View {
        GameDet(selectedGame: mockData())
    }
}
struct PlatformStack: View{
    var arr:Array<Platforms>
     var type:String
    var body:some View{
        GeometryReader{
            proxy in
            VStack(alignment:.leading){
                Text(type)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading,20)
                
                ScrollView(.horizontal,showsIndicators: false) {
                    LazyHStack {
                        ForEach(arr){ item in
                            DisplayData(url: item.image_background,name: item.name, width: proxy.size.width,minimum: item.minimum,recommended: item.recommended)
                            
                        }
                    }
                }.frame(height:300)
            }
        }.frame(height: 300)
         
    }
}
//struct GenresData: View{
//    var arr:Array<Genres>
//     var type:String
//    var body:some View{
//        GeometryReader{
//            proxy in
//            VStack(alignment:.leading){
//                Text(type)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.leading,20)
//
//                ScrollView(.horizontal,showsIndicators: false) {
//                    LazyHStack {
//                        ForEach(arr){ item in
//
//                            DisplayData(url: item.image_background,proxy: proxy,name: item.name)
//
//                        }
//                    }
//                }.frame(height:300)
//            }
//        }.frame(height: 300)
//
//    }
//}
//struct StoreStack: View{
//    var arr:Array<Store>
//     var type:String
//    var body:some View{
//        GeometryReader{
//            proxy in
//            VStack(alignment:.leading){
//                Text(type)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.leading,20)
//
//                ScrollView(.horizontal,showsIndicators: false) {
//                    LazyHStack {
//                        ForEach(arr){ item in
//                            DisplayData(url: item.image_background,proxy: proxy,name: item.name)
//
//                        }
//                    }
//                }.frame(height:300)
//            }
//        }.frame(height: 300)
//
//    }
//}
struct DisplayData:View{
    var url:String
    var name:String
    var width:CGFloat
    var minimum:String
    var recommended:String
    var body:some View{
        VStack{
            AsyncImage(url: URL.finalImageUrl(imageurl: url)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:width - 30,height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                        .shadow(radius: 20)
                case .failure(let error):
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:width - 50,height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0,style: .continuous))
                    let _ = print(error)
                    Text("error: \(error.localizedDescription)")
                case .empty:
                    ProgressView().foregroundColor(.white)
                @unknown default:
                    fatalError()
                }
                
            }
            Text(name)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(minimum)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(recommended)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
        }.frame(width:width)
    }
}

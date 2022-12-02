////
////  napCarousel.swift
////  GameSensei
////
////  Created by Nij Mehar on 01/12/22.
////
//
//import SwiftUI
//
//struct SnapCarousel<Content:View,T:Identifiable>: View {
//    var content:(T) -> Content
//    var list: [T]
//
//    @GestureState var offset: CGFloat = 0
//    var spacing:CGFloat
//    var trailingSpace:CGFloat
//    @Binding var index:Int
//
//    init(items: [T], spacing: CGFloat = 15, trailingSpace: CGFloat = 60, index: Binding<Int>,@ViewBuilder content: @escaping (T) -> Content) {
//        self.content = content
//        self.list = items
//        self.spacing = spacing
//        self.trailingSpace = trailingSpace
//        self._index = index
//    }
//    var body: some View{
//        GeometryReader{
//            proxy in
//            HStack(spacing:spacing){
//                ForEach(list){
//                    item in
//                    content(item)
//                        .frame(width: proxy.size.width - trailingSpace)
//                }
//            }.padding(.horizontal,spacing)
//                .offset(x: (CGFloat(index) * -proxy.size.width)+offset)
//                .gesture(
//                    DragGesture()
//                        .updating($offset, body: {
//                            value,out, _ in
//                            out = value.translation.width
//                        })
//                        .onEnded({
//                            value in
//                            let offsetX = value.translation.width
//                            let progress = -offsetX / proxy.size.width;
//                            let roundIndex = progress.rounded()
//                            index = max(min(index + Int(roundIndex),list.count-2),0)
//                        })
//                )
//        }.animation(.easeInOut, value: offset == 0)
//    }
//}
//
//struct SnapCarousel_Previews: PreviewProvider {
//    static var previews: some View {
//        GameListView()
//    }
//}

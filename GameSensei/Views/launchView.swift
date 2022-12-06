//
//  launchScreen.swift
//  GameSensei
//
//  Created by Nij Mehar on 06/12/22.
//

import SwiftUI

struct launchView: View {
    @EnvironmentObject private var launchViewModel:LaunchViewModel
    @State private var firstAnimation = false
    @State private var secondAnimation = false
    @State private var startFadeoutAnimation = false
    
    private var image: some View {
        VStack{
            Text("Game Genesis")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .scaleEffect(firstAnimation ? 1 : 0)
                .font(.system(size: 32))
            Image(systemName: "gamecontroller.fill")
                .resizable()
                .renderingMode(.original)
                .foregroundColor(.white)
                .scaledToFit()
                .frame(width: 100, height: 100)
                .scaleEffect(firstAnimation ? 1 : 0)
                .scaleEffect(secondAnimation ? 0 : 1)
                .offset(y: secondAnimation ? 400 : 0)
        }
    }
    
    private var backgroundColor: some View {
        Color.black.ignoresSafeArea()
        
    }
    
    private let animationTimer = Timer // Mark 5
        .publish(every: 1.4, on: .current, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            backgroundColor
            image
        }.onReceive(animationTimer) { timerValue in
            updateAnimation()  // Mark 5
        }.opacity(startFadeoutAnimation ? 0 : 1)
    }
    
    private func updateAnimation() { // Mark 5
        switch launchViewModel.state {
        case .firstStep:
            withAnimation(.easeInOut(duration: 1.0)) {
                firstAnimation.toggle()
            }
        case .secondStep:
            if secondAnimation == false {
                withAnimation(.linear) {
                    self.secondAnimation = true
                    startFadeoutAnimation = true
                }
            }
        case .finished:
            // use this case to finish any work needed
            break
        }
    }
    
    
}


struct launchScreen_Previews: PreviewProvider {
    static var previews: some View {
        launchView().environmentObject(LaunchViewModel())
    }
}

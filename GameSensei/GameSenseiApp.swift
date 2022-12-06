//
//  GameSenseiApp.swift
//  GameSensei
//
//  Created by Nij Mehar on 01/12/22.
//

import SwiftUI

@main
struct GameSenseiApp: App {
    @StateObject var launchScreenState = LaunchViewModel()
    var body: some Scene {
        WindowGroup {
            ZStack{
                MainPageView()
                if launchScreenState.state != .finished {
                        launchView()
                }
            }.environmentObject(LaunchViewModel())
        }
    }
}

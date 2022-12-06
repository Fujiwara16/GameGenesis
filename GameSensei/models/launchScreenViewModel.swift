//
//  launchScreenViewModel.swift
//  GameSensei
//
//  Created by Nij Mehar on 06/12/22.
//

import Foundation
import SwiftUI

enum LaunchScreenStep {
    case firstStep
    case secondStep
    case finished
}
final class LaunchViewModel: ObservableObject {    @MainActor
    @Published var topColor:Color = .black
    @Published var bottomColor:Color = .purple
    @Published private(set) var state: LaunchScreenStep = .firstStep
        @MainActor
    func dismiss() {
        Task {
            state = .secondStep
            try? await Task.sleep(for: Duration.seconds(1))
            self.state = .finished
        }
    }
}

//
//  ViewController.swift
//  GameSensei
//
//  Created by Nij Mehar on 06/12/22.
//
import Foundation
import AVFoundation

extension AVPlayer {
    
    var isPlaying: Bool {
        print(self.rate)
        if (self.rate != 0 && self.error == nil) {
            return true
        } else {
            return false
        }
    }
    
}

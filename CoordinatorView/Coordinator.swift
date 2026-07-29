//
//  Coordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//
import UIKit
import Foundation

protocol Coordinator: AnyObject {
    func start()
}

protocol ContentNavigating: AnyObject {
    func showMorning()
    func showMusicPage(item : String)
    func showMusicPage2(item : String)
    func dismissMusicPage()
    func showSleepyStory()
    func playOptionPage()
}

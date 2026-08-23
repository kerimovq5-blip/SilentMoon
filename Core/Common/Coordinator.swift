//
//  Coordinator.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 25.06.26.
//
import UIKit
import Foundation
@MainActor
protocol Coordinator: AnyObject {
    func start()
}
@MainActor
protocol ContentNavigating: AnyObject {
    func showMorning()
    func showMusicPage(item : String)
    func showMusicPage2(item : String)
    func showMusicList()
    func showSearchPage()
    func dismissMusicPage()
    func showSleepyStory()
    func playOptionPage()
}

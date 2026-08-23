//
//  AppLayout.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 03.07.26.
//

import CoreGraphics


enum AppLayout: CGFloat {
 
    case smallSpacing  = 8
    case mediumSpacing = 16
    case spacing       = 20
    case largeSpacing  = 30
    case xLargeSpacing = 40
    case textFieldHeight    = 65
    case buttonHeight       = 60
    case buttonHeight2       = 50
    case labelHeight = 102
    case titleHeight = 110
    case leftCardHeight  = 210
    case rightCardHeight = 170
    case bottomInset = -30
 
    var value: CGFloat { rawValue }
}


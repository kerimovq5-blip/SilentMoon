import CoreGraphics

enum AppLayout {
    case smallSpacing
    case mediumSpacing
    case spacing
    case largeSpacing
    case xLargeSpacing
    case cellTitleTopSpacing
    case cellSubtitleTopSpacing
    case cellSmallMargin
    
    case textFieldHeight
    case buttonHeight
    case buttonHeight2
    case labelHeight
    case titleHeight
    case leftCardHeight
    case rightCardHeight
    case bottomInset
    
    case logoHeight
    case illustrationHeight
    case secondaryButtonHeight
    case silentMoonTopInset
    
    case topicItemHeight
    
    case sectionCollectionViewHeight
    case oceanMoonHeight
    case oceanButtonHeight
    case oceanButtonWidth
    case sectionInsetLeft
    case storyCellImageHeight
    case playOptionHeaderHeight
    case relatedCardWidth
    case separatorHeight
    case stackSpacing
    
    case playButtonSize
    case playButtonRadius
    case actionButtonSize
    case actionButtonRadius
    case controlsBottomSpacing
    case timeLabelFontSize
    case seekInterval
    case defaultPadding
    
    var value: CGFloat {
        switch self {
        case .smallSpacing: return 8
        case .mediumSpacing: return 16
        case .spacing: return 20
        case .largeSpacing: return 30
        case .xLargeSpacing , .playButtonRadius , .secondaryButtonHeight: return 40
        case .cellTitleTopSpacing , .stackSpacing : return 10
        case .cellSubtitleTopSpacing: return 4
        case .cellSmallMargin: return 2
        case .textFieldHeight: return 65
        case .buttonHeight , .controlsBottomSpacing: return 60
        case .buttonHeight2, .logoHeight: return 50
        case .labelHeight: return 102
        case .titleHeight: return 110
        case .leftCardHeight: return 210
        case .rightCardHeight: return 170
        case .bottomInset: return -30
        case .illustrationHeight: return 242
        case .silentMoonTopInset: return 160
        case .topicItemHeight: return 260
        case .sectionCollectionViewHeight: return 100
        case .oceanMoonHeight: return 235
        case .oceanButtonHeight: return 35
        case .oceanButtonWidth: return 70
        case .sectionInsetLeft: return 10
        case .storyCellImageHeight: return 120
        case .playOptionHeaderHeight: return 300
        case .relatedCardWidth: return 165
        case .separatorHeight: return 1
            
        case .playButtonSize: return 80
        case .actionButtonSize: return 44
        case .actionButtonRadius: return 22
        case .timeLabelFontSize: return 13
        case .seekInterval: return 15
        case .defaultPadding: return 24
        }
    }
}

extension AppLayout {
    static let frameHeightMultiplier: CGFloat = 0.55
    static let sectionWidthMultiplier: CGFloat = 0.16
}

//
//  SleepyStoryModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 28.07.26.
//




import UIKit

struct SleepyStoryModels : MeditateSectionData {
    
    
    var image: UIImage?
    var title: String
    var durationItem : String
    var isSelected: Bool
    var viewColor: UIColor?
}

extension SleepyStoryModels {
    static var storyData : [SleepyStoryModels] = [
        .init(
            image: nil ,
            title: "Night Island",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false ,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Sweet Sleep",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Good Night",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Moon Clouds",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Sweet Sleep",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Good Night",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Sweet Sleep",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false,
            viewColor: .colorIndigo
            
        ),
        .init(
            image: nil,
            title: "Moon Clouds",
            durationItem: "45 MIN • SLEEP MUSIC",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        
    ]
    
}

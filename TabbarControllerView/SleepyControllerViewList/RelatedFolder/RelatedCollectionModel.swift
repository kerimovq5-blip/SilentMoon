//
//  RelatedCollectionModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//

import UIKit

struct RelatedCollectionModel : MeditateSectionData {
    
    var image: UIImage?
    var title: String
    var durationItem : String
    var isSelected: Bool
    var viewColor: UIColor?
}

extension RelatedCollectionModel {
    static let relatedData : [RelatedCollectionModel] = [
        .init(
            image: nil ,
            title: "Moon Clouds",
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

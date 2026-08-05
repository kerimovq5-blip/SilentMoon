//
//  MeditateCollectionModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 20.07.26.
//


import UIKit

struct MeditateCollectionModels : MeditateSectionData {
    
    
    var image: UIImage?
    var title: String
    var isSelected: Bool
    var viewColor: UIColor?
}

extension MeditateCollectionModels {
    static var meditateData : [MeditateCollectionModels] = [
        .init(
            image: nil ,
            title: "7 Days of Calm",
            isSelected: false ,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Anxiet Release",
            isSelected: false),
        .init(
            image: nil,
            title: "Anxious",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "Sleep",
            isSelected: false,
            viewColor: .colorIndigo
        ),
        .init(
            image: nil,
            title: "",
            isSelected: false,
            viewColor: .colorIndigo
        )
        
    ]
    
}

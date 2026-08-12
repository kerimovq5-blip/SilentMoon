//
//  MeditateSectionModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 19.07.26.
//

import UIKit

struct MeditateSectionModels : MeditateSectionData {
    
    var image: UIImage?
    var title: String
    var isSelected: Bool
    var viewColor: UIColor?
}

extension MeditateSectionModels {
    static let dummyData: [MeditateSectionModels] = [
        .init(image: UIImage(named: "AllSection"), title: "All", isSelected: false),
        .init(image: UIImage(named: "Heart"), title: "My", isSelected: false),
        .init(
            image: UIImage(named: "Anxious"),
            title: "Anxious",
            isSelected: false
        ),
        .init(
            image: UIImage(named: "sleep1"),
            title: "Sleep",
            isSelected: false
        ),
        .init(image: UIImage(named: "Kids"), title: "Kids", isSelected: false)
        
    ]
    
}

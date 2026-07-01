//
//  ChooseTopicModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 01.07.26.
//

import UIKit

struct ChooseTopicModel{
    var pageController : UIImage?
    var title : String
    
}
extension ChooseTopicModel {
    static let topics : [ChooseTopicModel] = [
        ChooseTopicModel(pageController: UIImage(named: "stress"), title: "Reduce Stress"),
        ChooseTopicModel(pageController: UIImage(named: "improve"), title: "Improve Performance"),
        ChooseTopicModel(pageController: UIImage(named: "happiness"), title: "Increase Happiness"),
        ChooseTopicModel(pageController: UIImage(named: "anxiety"), title: "Reduce Anxiety"),
        ChooseTopicModel(pageController: UIImage(named: "growth"), title: "Personal Growth"),
        ChooseTopicModel(pageController: UIImage(named: "sleep"), title: "Better Sleep"),
        ChooseTopicModel(pageController: UIImage(named: ""), title: " "),

        
    ]
}

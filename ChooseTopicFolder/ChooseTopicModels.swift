//
//  ChooseTopicModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.06.26.
import UIKit


enum TopicImage: String {
    case stress      = "stress"
    case improve     = "improve"
    case happiness   = "happiness"
    case anxiety     = "anxiety"
    case growth      = "growth"
    case sleepy      = "sleepy"
    case mindfulness = "mindfulness"

    var image: UIImage? {
       nil
    }
}



struct ChooseTopicModel {
    let image: TopicImage
    let title: String
    let color : UIColor?

    static let all: [ChooseTopicModel] = [
        ChooseTopicModel(
            image: .stress,
            title: "Reduce Stress" ,
            color : .colorIndigo
        ),
        ChooseTopicModel(image: .improve,     title: "Improve Performance" , color : .colorIndigo),
        ChooseTopicModel(image: .happiness,   title: "Increase Happiness", color : .colorIndigo),
        ChooseTopicModel(image: .anxiety,     title: "Reduce Anxiety" , color : .colorIndigo),
        ChooseTopicModel(image: .growth,      title: "Personal Growth", color : .colorIndigo),
        ChooseTopicModel(image: .sleepy,      title: "Better Sleep" , color : .colorIndigo),
        ChooseTopicModel(image: .mindfulness, title: "Mindfulness" , color : .colorIndigo)
    ]
}


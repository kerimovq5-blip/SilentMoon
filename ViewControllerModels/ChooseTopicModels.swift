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
        UIImage(named: rawValue)
    }
}



struct ChooseTopicModel {
    let image: TopicImage
    let title: String

    static let all: [ChooseTopicModel] = [
        ChooseTopicModel(image: .stress,      title: "Reduce Stress"),
        ChooseTopicModel(image: .improve,     title: "Improve Performance"),
        ChooseTopicModel(image: .happiness,   title: "Increase Happiness"),
        ChooseTopicModel(image: .anxiety,     title: "Reduce Anxiety"),
        ChooseTopicModel(image: .growth,      title: "Personal Growth"),
        ChooseTopicModel(image: .sleepy,      title: "Better Sleep"),
        ChooseTopicModel(image: .mindfulness, title: "Mindfulness")
    ]
}

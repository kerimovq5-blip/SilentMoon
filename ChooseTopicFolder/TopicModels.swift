//
//  TopicModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 12.08.26.
//

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
    let id: String
    let image: TopicImage
    let title: String
    let color: UIColor?
    
    static let all: [ChooseTopicModel] = [
        ChooseTopicModel(
            id: "stress",
            image: .stress,
            title: "Reduce Stress",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "improve",
            image: .improve,
            title: "Improve Performance",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "happiness",
            image: .happiness,
            title: "Increase Happiness",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "anxiety",
            image: .anxiety,
            title: "Reduce Anxiety",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "growth",
            image: .growth,
            title: "Personal Growth",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "sleepy",
            image: .sleepy,
            title: "Better Sleep",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "mindfulness",
            image: .mindfulness,
            title: "Mindfulness",
            color: .colorIndigo
        )
    ]
}

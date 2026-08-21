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
    let backendId: Int
    let image: TopicImage
    let title: String
    let color: UIColor?
    
    static let all: [ChooseTopicModel] = [
        ChooseTopicModel(
            id: "stress",
            backendId: 1,
            image: .stress,
            title: "Reduce Stress",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "improve",
            backendId: 2,
            image: .improve,
            title: "Improve Performance",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "happiness",
            backendId: 3,
            image: .happiness,
            title: "Increase Happiness",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "anxiety",
            backendId: 4,
            image: .anxiety,
            title: "Reduce Anxiety",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "growth",
            backendId: 5,
            image: .growth,
            title: "Personal Growth",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "sleepy",
            backendId: 6,
            image: .sleepy,
            title: "Better Sleep",
            color: .colorIndigo
        ),
        ChooseTopicModel(
            id: "mindfulness",
            backendId: 7,
            image: .mindfulness,
            title: "Mindfulness",
            color: .colorIndigo
        )
    ]
}

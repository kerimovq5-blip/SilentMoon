//
//  HomeModels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 10.07.26.
//
import UIKit

enum HomeModels: Int, CaseIterable {
    case courses
    case dailyThought
    case recommended
}

struct CoursesCardItem {
    let title: String
    let category: String
    let duration: String
    let backgroundColor: UIColor
    let image: UIImage?
    let buttonBackgroundColor: UIColor
    let buttonTitleColor: UIColor
    let isSelected: Bool
}

struct DailyThoughtItem {
    let title: String
    let description: String
    let image: UIImage?
    let isSelected: Bool
}

struct RecommendedItem {
    let title: String
    let description: String
    let image: UIImage?
    let isSelected: Bool
}

extension CoursesCardItem {
    static let mockData: [CoursesCardItem] = [
        CoursesCardItem(
            title: "",
            category: "",
            duration: "",
            backgroundColor: .colorIndigo,
            image: nil,
            buttonBackgroundColor: .white,
            buttonTitleColor: .black,
            isSelected: false
        ),
        CoursesCardItem(
            title: "",
            category: "",
            duration: "",
            backgroundColor: UIColor(red: 0.94, green: 0.72, blue: 0.42, alpha: 1.0),
            image: nil,
            buttonBackgroundColor: .textPrimary,
            buttonTitleColor: .white,
            isSelected: false
        )
    ]
}

extension DailyThoughtItem {
    static let mockData: [DailyThoughtItem] = [
        DailyThoughtItem(
            title: "",
            description: "",
            image: nil,
            isSelected: false
        )
    ]
}

extension RecommendedItem {
    static let mockData: [RecommendedItem] = [
        RecommendedItem(
            title: "Focus",
            description: "MEDITATION • 3-10 MIN ",
            image: nil,
            isSelected: false
        ),
        RecommendedItem(
            title: "Happiness",
            description: "MEDITATION • 3-10 MIN",
            image: nil,
            isSelected: false
        ),
        RecommendedItem(
            title: "Focus",
            description: "MEDITATION • 3-10 MIN ",
            image: nil,
            isSelected: false
        )
    ]
}

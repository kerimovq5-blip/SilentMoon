//
//  CourseDetailModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 18.07.26.
//


import Foundation

struct CourseSessionItem {
    let title: String
    let duration: String
    let isHighlighted: Bool
}

extension CourseSessionItem {
    static let mockData: [CourseSessionItem] = [
        CourseSessionItem(title: "Focus Attention", duration: "10 MIN", isHighlighted: true),
        CourseSessionItem(title: "Body Scan", duration: "5 MIN", isHighlighted: false),
        CourseSessionItem(title: "Making Happiness", duration: "3 MIN", isHighlighted: false)
    ]
}

//
//  ReminderModel.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 08.07.26.
//
import UIKit

struct ReminderDayItem: ReminderCellData {
    var title: String
    var isSelected: Bool
    
    
  static  let weeknames : [ ReminderDayItem] = [
        .init(title: "Sunday", isSelected: false),
        .init(title: "Monday", isSelected: false),
        .init(title: "Tuesday", isSelected: false),
        .init(title: "Wednesday", isSelected: false),
        .init(title: "Thursday", isSelected: false),
        .init(title: "Friday", isSelected: false),
        .init(title: "Saturday", isSelected: false)
    ]
}

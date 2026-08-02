//
//  Searchmodels.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 02.08.26.
//

import Foundation

struct CourseSummary: Decodable {
    let id: String
    let title: String
    let subtitle: String?
    let type: String
    let categoryId: String?
    let imageUrl: String?
    let durationSec: Int
    let isFeatured: Bool?
    let narrators: [String]?
}

struct PaginationMeta: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
}

struct SearchResponse: Decodable {
    let query: String
    let data: [CourseSummary]
    let meta: PaginationMeta
}

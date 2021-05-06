//
//  PlanModel.swift
//  BackAware
//
//  Created by Muhammad Ali on 18/04/2021.
//

import Foundation
struct PlanModel: Codable {
    let total: Int?
    let plans: [Plan]?
    let trainings:[Plan]?
}

// MARK: - Plan
struct Plan: Codable {
    let id: Int?
    let name, shortDescription, fullDescription, image: String?
    let duration: String?
    let isFree: Bool?
    let steps: [Step]?
}

// MARK: - Step
struct Step: Codable {
    let stepDescription, video: String?

    enum CodingKeys: String, CodingKey {
        case stepDescription = "description"
        case video
    }
}

struct TrackTimeModel{
    let testName:String
    let good:String
    let poorFlex:String
    let poorExt:String
}

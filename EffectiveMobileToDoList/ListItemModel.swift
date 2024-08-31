//
//  ListItemModel.swift
//  EffectiveMobileToDoList
//
//  Created by Антон Разгуляев on 30.08.2024.
//

import Foundation

struct JSONDataModel: Codable {
        let todos: [ListItemModel]
        let total, skip, limit: Int
    }

    // MARK: - Todo
    struct ListItemModel: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}

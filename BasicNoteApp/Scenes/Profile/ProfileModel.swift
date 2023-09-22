//
//  ProfileModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 1.08.2023.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let code: String
    let data: data
    let message: String
}

// MARK: - DataClass
struct data: Codable {
    let id: Int
    let fullName, email: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
    }
}
extension ProfileModel {
    func asDictionary() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        var dict: [String: Any] = [:]
        for child in mirror.children {
            if let label = child.label {
                dict[label] = child.value
            }
        }
        return dict
    }
}

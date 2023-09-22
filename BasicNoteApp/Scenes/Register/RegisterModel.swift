//
//  RegisterModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 17.07.2023.
//

import Foundation

struct RegisterModel: Encodable{
    let full_name: String
    let email: String
    let password: String
}

struct RegisterResponse: Decodable {
    let code: String
    let data: DataClass
    let message: String
}

struct DataClass: Decodable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

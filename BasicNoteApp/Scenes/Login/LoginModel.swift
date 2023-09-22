//
//  LoginModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 17.07.2023.
//

import Foundation
import UIKit

struct LoginModel: Encodable{
    let email: String
    let password: String
}


struct LoginResponse: Decodable {
    let code: String
    let data: Data
    let message: String
}

struct Data: Decodable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

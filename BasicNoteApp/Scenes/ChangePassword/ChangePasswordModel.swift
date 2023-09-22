//
//  ChangePasswordModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 27.07.2023.
//

import Foundation

struct changePasswordModel: Encodable{
    let password: String
    let new_password: String
    let new_password_confirmation: String
    }

struct ChangePasswordResponse: Decodable {
    let code: String
    let data: String
    let message: String
}


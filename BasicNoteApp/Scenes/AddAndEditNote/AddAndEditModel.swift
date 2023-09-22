//
//  AddAndEditModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 31.07.2023.
//

import Foundation

struct addNoteModel: Encodable{
    let title: String
    let note: String
}

struct updateNoteModel: Encodable{
    let title: String
    let note: String
}

// MARK: - AddNote
struct AddNoteResponse: Codable {
    let code: String?
    let data: Datas?
    let message: String?
}

// MARK: - DataClass
struct Datas: Codable {
    let title, note: String?
    let id: Int?
}



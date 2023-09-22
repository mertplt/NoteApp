//
//  AddAndEditNoteViewModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 13.08.2023.
//

import Foundation

class AddAndEditNoteViewModel {

    // MARK: - Properties

    var isAdd: Bool = false
    var noteID: Int = 0
    var noteText: String = ""
    var noteTitle: String = ""
    
    let ApiManager = APIManager()
    
    // MARK: - Initialization

    init(noteID: Int, noteText: String, noteTitle: String) {
        self.isAdd = false
        self.noteID = noteID
        self.noteText = noteText
        self.noteTitle = noteTitle
    }
    
    // MARK: - Computed Properties
    
    var isSaveButtonEnabled: Bool {
        return isTitleValid && isNoteValid
    }
    
    var isTitleValid: Bool {
        return Validation().validateTitle(title: noteTitle)
    }
    
    var isNoteValid: Bool {
        return Validation().validateNote(note: noteText)
    }
    
    // MARK: - Methods

    func updateNoteText(_ text: String) {
        noteText = text
    }
    
    func updateNoteTitle(_ title: String) {
        noteTitle = title
    }
    
    var noteTitlePlaceholder: String {
        return "Enter Title"
    }
    
    var noteTextPlaceholder: String {
        return "Enter Text"
    }

    func saveNote(completion: @escaping (Result<Int?, Error>) -> Void) {
        if isAdd {
            ApiManager.callingAddNoteAPI(addNote: addNoteModel(title: noteTitle, note: noteText)) { result in
                switch result {
                case .success(let json):
                    if let jsonData = json as? [String: Any], let data = jsonData["data"] as? [String: Any], let ID = data["id"] as? Int {
                        completion(.success(ID))
                    } else {
                        completion(.failure(APIErrors.custom(message: "Failed to parse response.")))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            ApiManager.callingUpdateNoteAPI(noteID: noteID, updatedNote: updateNoteModel(title: noteTitle, note: noteText)) { result in
                switch result {
                case .success(_):
                    completion(.success(nil))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

//
//  NotesViewModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 13.08.2023.
//

import Foundation

class NotesViewModel {
    // MARK: - Properties

    private var data: [Datum] = []
    private var filteredData: [Datum] = []
    private let apiManager: APIManager
    
    // MARK: - Initialization
    init(apiManager: APIManager = APIManager.shareInstance) {
        self.apiManager = apiManager
    }
    
    // MARK: - Callbacks

    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Methods

    func fetchNotes() {
        let noteBody = NoteBody(Authorization: KeychainService().getAccessToken()!)
        
        apiManager.callingNoteAPI(note: noteBody) { [weak self] isSuccess in
            if isSuccess {
                self?.data = self?.apiManager.notes?.data.data ?? []
                self?.onDataUpdated?()
            } else {
                self?.onError?("Error fetching notes")
            }
        }

    }
    
    func getNumberOfNotes(with searchText: String?) -> Int {
        
        if let searchText = searchText, !searchText.isEmpty{
            return filteredData.count
        } else {
            return data.count
        }
    }
    
    func getNote(at index: Int,with searchText: String?) -> Datum {

        if let searchText = searchText, !searchText.isEmpty{
            return filteredData[index]
        } else {
            return data[index]
        }
    }
    
    func deleteNote(at index: Int, completion: @escaping (Bool) -> Void) {
        let note = filteredData.isEmpty ? data[index] : filteredData[index]
        
        apiManager.callingdeleteNoteAPI(id: note.id) { [weak self] isSuccess in
            if isSuccess {
                if self?.filteredData.isEmpty == false {
                    if let index = self?.data.firstIndex(where: { $0.id == note.id }) {
                        self?.data.remove(at: index)
                    }
                } else {
                    self?.data.remove(at: index)
                }
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func filterNotes(with searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredData = data.filter { note in
                return note.title.localizedCaseInsensitiveContains(searchText) ||
                    note.note.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            filteredData = data
        }
        onDataUpdated?()
    }
}

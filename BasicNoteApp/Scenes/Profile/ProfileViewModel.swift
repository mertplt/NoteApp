//
//  ProfileViewModel.swift
//  BasicNoteApp
//
//  Created by mert polat on 14.08.2023.
//

import Foundation

final class ProfileViewModel {
    
    // MARK: - State
    
    enum State {
        case loading
        case loaded(User)
        case error(Error)
    }
    
    // MARK: - Properties
    
    private(set) var state: State = .loading {
        didSet { stateDidChange() }
    }
    
    private let stateDidChange: () -> Void
    
    // MARK: - Initialization
    
    init(stateDidChange: @escaping () -> Void) {
        self.stateDidChange = stateDidChange
    }
    
    // MARK: - Methods
    
    func fetchUserData() {
        state = .loading
        
        APIManager.shareInstance.callingGetUserMeAPI { result in
            switch result {
            case .success(let data):
                if let userData = data as? [String: Any], let userDict = userData["data"] as? [String: Any] {
                    let user = User(fullName: userDict["full_name"] as? String, email: userDict["email"] as? String)
                    self.state = .loaded(user)
                }
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    func updateUserData(fullName: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        APIManager.shareInstance.updateUserMe(fullName: fullName, email: email) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - User

struct User {
    let fullName, email: String?
}


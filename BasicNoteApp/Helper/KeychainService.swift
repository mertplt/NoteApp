//
//  KeychainService.swift
//  BasicNoteApp
//
//  Created by mert polat on 20.07.2023.
//

import Foundation
import KeychainAccess

class KeychainService {
    private let accessTokenKey = "accessToken"
    private let keychain = Keychain(service: "com.example.BasicNoteApp")

    func saveAccessToken(_ accessToken: String) {
        do {
            try keychain.set(accessToken, key: accessTokenKey)
        } catch let error {
            print("Error saving AccessToken to Keychain: \(error)")
        }
    }

    func getAccessToken() -> String? {
        do {
            return try keychain.get(accessTokenKey)
        } catch let error {
            print("Error retrieving AccessToken from Keychain: \(error)")
            return nil
        }
    }

    func deleteAccessToken() {
        do {
            try keychain.remove(accessTokenKey)
        } catch let error {
            print("Error deleting AccessToken from Keychain: \(error)")
        }
    }
}

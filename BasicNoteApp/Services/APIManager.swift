//
//  APIManager.swift
//  BasicNoteApp
//
//  Created by mert polat on 17.07.2023.
//

import Foundation
import Alamofire
import KeychainAccess

enum APIErrors: Error {
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIErrors>) -> Void

class APIManager{
    static let shareInstance = APIManager()
    var notes: Notes?

    // MARK: Register API

    func callingRegisterAPI(register: RegisterModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let data = data, let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data) {
                    if response.response?.statusCode == 200 {
                        KeychainService().saveAccessToken(registerResponse.data.accessToken)
                        
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                } else {
                    completionHandler(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    // MARK: Login API
    
    func callingLoginAPI(login: LoginModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(login_url, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let data = data, let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    if response.response?.statusCode == 200 {
                        KeychainService().saveAccessToken(loginResponse.data.accessToken)
    
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                } else {
                    completionHandler(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    // MARK: Forgot Password API

        func callingForgotPasswordAPI(forgotPassword: ForgotPasswordModel,completionHandler: @escaping Handler){
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(forgot_password_url,method: .post,parameters: forgotPassword,encoder: JSONParameterEncoder.default,headers: headers).response{ response in
            debugPrint(response)
            switch response.result{
            case.success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data!,options: [])
                    if response.response?.statusCode == 200{
                        completionHandler(.success(json))
                    }else {
                        completionHandler(.failure(.custom(message: "Please check your network connectivity")))
                    }
                }catch{
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again")))
                }
            case.failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: Note API
    
    func callingNoteAPI(note: NoteBody, completionHandler: @escaping (Bool) -> ()) {
            let headers: HTTPHeaders = [
                .contentType("application/json"),
                .authorization(bearerToken: KeychainService().getAccessToken()!)
            ]
            
            AF.request(notes_url, method: .get, parameters: note.asDictionary(), encoding: URLEncoding(destination: .queryString), headers: headers).response { response in
                debugPrint(response)
                switch response.result {
                case .success(let data):
                    if let data = data, let notes = try? JSONDecoder().decode(Notes.self, from: data) {
                        self.notes = notes
                        if response.response?.statusCode == 200 {
                            completionHandler(true)
                        } else {
                            completionHandler(false)
                        }
                    } else {
                        completionHandler(false)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                    completionHandler(false)
                }
            }
        }
    
    // MARK: Change Password API
    
    func callingChangePasswordAPI(changePassword: changePasswordModel, completionHandler: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: KeychainService().getAccessToken()!)
        ]
        
        AF.request(changePassword_url, method: .put, parameters: changePassword, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let jsonData = data as? [String: Any], let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        completionHandler(true)
                    } else {
                        let errorMessage = jsonData["message"] as? String ?? "An error occurred."
                        print("Change password error: \(errorMessage)")
                        completionHandler(false)
                    }
                } else {
                    print("Invalid response data for change password.")
                    completionHandler(false)
                }
            case .failure(let error):
                print("Change password request failed: \(error.localizedDescription)")
                completionHandler(false)
            }
        }
    }
    
     // MARK: Delete Note API
     
     func callingdeleteNoteAPI(id noteID: Int, completion: @escaping (Bool) -> Void) {
           let deleteURL = "\(base_url)notes/\(noteID)"
        
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: KeychainService().getAccessToken()!)
        ]

           AF.request(deleteURL, method: .delete, headers: headers).response { response in
               switch response.result {
               case .success(let data):
                   if let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any], let message = json["message"] as? String {
                       if message == "Resource has been deleted." {
                           completion(true)
                       } else {
                           completion(false)
                       }
                   } else {
                       completion(false)
                   }
               case .failure:
                   completion(false)
               }
           }
       }
    
    // MARK: Add Note API
      
    func callingAddNoteAPI(addNote: addNoteModel,completionHandler: @escaping Handler){
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: KeychainService().getAccessToken()!)
        ]
    
    AF.request(addNote_url,method: .post,parameters: addNote,encoder: JSONParameterEncoder.default,headers: headers).response{ response in
        debugPrint(response)
        switch response.result{
        case.success(let data):
            do{
                let json = try JSONSerialization.jsonObject(with: data!,options: [])
                if response.response?.statusCode == 200{
                    completionHandler(.success(json))
                }else {
                    completionHandler(.failure(.custom(message: "Please check your network connectivity")))
                }
            }catch{
                print(error.localizedDescription)
                completionHandler(.failure(.custom(message: "Please try again")))
            }
        case.failure(let err):
            print(err.localizedDescription)
        }
    }
}
    
    // MARK: Update Note API

    func callingUpdateNoteAPI(noteID: Int, updatedNote: updateNoteModel, completionHandler: @escaping Handler) {
        let updateURL = "\(base_url)notes/\(noteID)"

        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: KeychainService().getAccessToken()!)
        ]

        AF.request(updateURL, method: .put, parameters: updatedNote, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    } else {
                        completionHandler(.failure(.custom(message: "Please check your network connectivity")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again")))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: Get User Me API

    func callingGetUserMeAPI(completionHandler: @escaping Handler) {
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: KeychainService().getAccessToken()!)
        ]
        
        AF.request(getMe_url, method: .get, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    } else {
                        completionHandler(.failure(.custom(message: "Please check your network connectivity")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again")))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: Update User Me API

    func updateUserMe(fullName: String, email: String, completionHandler: @escaping Handler) {
        let updateMeURL = "\(base_url)users/me"
        
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .authorization(bearerToken: KeychainService().getAccessToken()!)
        ]
        
        let parameters: [String: Any] = [
            "full_name": fullName,
            "email": email
        ]
        
        AF.request(updateMeURL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(json))
                    } else {
                        completionHandler(.failure(.custom(message: "Please check your network connectivity")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again")))
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

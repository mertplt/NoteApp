//
//  Validation.swift
//  BasicNoteApp
//
//  Created by mert polat on 17.07.2023.
//

import Foundation

public class Validation{
    func validatePassword(password: String) -> Bool{
        return password.count >= 6 && password.count <= 255

    }

    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func validateName(name: String) -> Bool{
        return name.count >= 3 && name.count <= 255
        }
    
    func validateTitle(title: String) -> Bool{
        return title.count >= 0 && title.count <= 250 && title != "Enter Title"
        }
    
    func validateNote(note: String) -> Bool{
        return note.count >= 0 && note != "Enter Text"
        }
    }
    


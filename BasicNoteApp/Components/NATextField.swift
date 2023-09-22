//
//  NATextField.swift
//  BasicNoteApp
//
//  Created by mert polat on 25.07.2023.
//

import UIKit

enum NaTextFieldStyle{
    case name
    case email
    case password
}

class NaTextField: UITextField {
    var placeholderText: String? {
        didSet {
            self.placeholder = placeholderText
        }
    }
    
    var textContentTypeValue: UITextContentType? {
        didSet {
            self.textContentType = textContentTypeValue
        }
    }
    
    var isSecureTextEntryValue: Bool = false {
        didSet {
            self.isSecureTextEntry = isSecureTextEntryValue
        }
    }
    
    var style: NaTextFieldStyle? {
          didSet {
              applyStyle()
          }
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTextField()
    }
    
    private func setTextField() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "Border Color")!.cgColor
        self.textColor = UIColor(named: "Text Primary")
        self.size(CGSize(width: 327, height: 53))
        self.font = UIFont(name: "Inter-Medium", size: 14)
        self.addPaddingToTextField()

    }
    
    
    private func applyStyle() {
        
        guard let style = style else { return }
               
               switch style {
               case .name:
                   configureNameStyle()
               case .email:
                   configureEmailPasswordStyle()
               case .password:
                   configurePasswordStyle()
               }
        
    }
    
    private func configureNameStyle(){
        self.placeholderText = "Full Name"
        self.isSecureTextEntryValue = false
        self.textContentType = .name
        self.setPlaceholderColor(UIColor.color(.TextSecondary))
        
    }
    
    private func configureEmailPasswordStyle(){
        self.placeholderText = "Email Address"
        self.isSecureTextEntryValue = false
        self.textContentType = .emailAddress
        self.setPlaceholderColor(UIColor.color(.TextSecondary))

    }
    
    private func configurePasswordStyle(){
        self.placeholderText = "Password"
        self.isSecureTextEntryValue = true
        self.textContentType = .password
        self.setPlaceholderColor(UIColor.color(.TextSecondary))

    }
    
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholderText = placeholderText else { return }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font ?? UIFont.font(.interMedium, size: .normal)
        ]
        
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }

}

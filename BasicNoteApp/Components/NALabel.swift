//
//  NALabel.swift
//  BasicNoteApp
//
//  Created by mert polat on 25.07.2023.
//

import Foundation
import UIKit

enum NaLabelStyle{
    case primary
    case explanation
    case withButton
}

class NaLabel: UILabel {
    var labelText: String? {
        didSet {
            self.text = labelText
        }
    }
    
    var textAlignmentValue: NSTextAlignment = .left {
        didSet {
            self.textAlignment = textAlignmentValue
        }
    }
    
    var textColorValue: UIColor = .black {
        didSet {
            self.textColor = textColorValue
        }
    }
    
    var fontNameValue: String = "Helvetica" {
        didSet {
            setFont()
        }
    }
    
    var fontSizeValue: CGFloat = 17 {
        didSet {
            setFont()
        }
    }
    
    var style: NaLabelStyle? {
          didSet {
              applyStyle()
          }
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setFont() {
        self.font = UIFont(name: fontNameValue, size: fontSizeValue)
    }
}

extension NaLabel{
    private func applyStyle(){
        guard let style = style else { return }
               
               switch style {
               case .primary:
                   configurePrimaryStyle()
               case .explanation:
                   configureExplanationStyle()
               case .withButton:
                   configureWithButtonStyle()
               }
    }
    
    private func configurePrimaryStyle() {
        self.fontNameValue = "Inter-SemiBold"
        self.fontSizeValue = 26
        self.textAlignment = .center
        
    }
    


    private func configureExplanationStyle() {
        self.fontNameValue = "Inter-Medium"
        self.fontSizeValue = 15
        self.textColor = UIColor.color(.TextSecondary)
        self.textAlignment = .center
    }

        private func configureWithButtonStyle() {
            self.fontNameValue = "Inter-Medium"
            self.fontSizeValue = 15
            self.textColor = UIColor.color(.TextSecondary)

            self.labelText = "Sign Up"
            self.textAlignment = .center
        }
}

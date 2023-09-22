//
//  NAButton.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.07.2023.
//

import UIKit

enum NaButtonStyle{
    case primary
    case forgotPassword
    case withLabel
}

class NaButton: UIButton{
    override var isEnabled: Bool{
        didSet{
            configureEnabledStates()
        }
    }
    
    var leftImage: UIImage?{
        didSet{
            configureLeftImage()
        }
    }
    
    var buttonTitle: String? {
    didSet {
        setButtonTitle()
        }
    }
    
    var style: NaButtonStyle? {
          didSet {
              applyStyle()
          }
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
        configureButtonTitle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setButton()
        configureButtonTitle()
    }
}
   extension NaButton{
       
       private func applyStyle(){
           guard let style = style else { return }
                  
                  switch style {
                  case .primary:
                      configurePrimaryStyle()
                  case .forgotPassword:
                      configureForgotPasswordStyle()
                  case .withLabel:
                      configureWithLabelStyle()
                  }
       }
       
       private func configurePrimaryStyle() {
           self.backgroundColor = UIColor.color(.ActionPrimaryDisabled)
           titleLabel?.font = UIFont.font(.interSemiBold, size: .normal)
           setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
          
           self.height(63)
       }


       private func configureForgotPasswordStyle() {
           setTitleColor(UIColor.color(.TextPrimary), for: .normal)
           titleLabel!.font = UIFont.font(.interMedium, size: .small)
           self.buttonTitle = "Forgot Password?"
           
       }

           private func configureWithLabelStyle() {
               backgroundColor = UIColor.color(.White)
               setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
               titleLabel?.font = UIFont.font(.interMedium, size: .custom(size: 15))
               
           }
       
       private func setButton(){
           self.layer.cornerRadius = 6
       }
       
       private func configureButtonTitle(){
           if let titleLabel = self.titleLabel{
               if style == .primary{
                   titleLabel.font = UIFont.font(.interSemiBold, size: .large)
               } else if style == .forgotPassword{
                   titleLabel.font = UIFont.font(.interMedium, size: .small)
               }else if style == .withLabel{
                   titleLabel.font = UIFont.font(.interMedium, size: .normal)
               }
           }
       }
    
    private func configureEnabledStates(){
        if isEnabled{
            if style == .primary{
                self.backgroundColor = UIColor.color(.ActionPrimaryEnable)
                setTitleColor(UIColor.color(.White), for: .normal)
            }else if style == .forgotPassword{
                self.backgroundColor = UIColor.color(.White)
                setTitleColor(UIColor.color(.TextPrimary), for: .normal)
            }else if style == .withLabel{
                self.backgroundColor = UIColor.color(.White)
                setTitleColor(UIColor.color(.ActionPrimaryDisabled), for: .normal)
            }
            
            
        }
        if !isEnabled{
            if style == .primary{
                self.backgroundColor = UIColor.color(.ActionPrimaryDisabled)
                setTitleColor(UIColor.color(.ActionPrimaryEnable), for: .normal)
            }
        }
    }
    
    private func configureLeftImage(){
        if let image = self.leftImage{
            self.setImage(image, for: .normal)
            let edgeInset = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
            imageEdgeInsets = edgeInset
        }
    }
    
    private func setButtonTitle() {
        if let buttonTitle = self.buttonTitle {
            self.setTitle(buttonTitle, for: .normal)
        }
    }

}

//
//  NAErrorIcon.swift
//  BasicNoteApp
//
//  Created by mert polat on 25.07.2023.
//

import UIKit

class NaErrorIcon: UIImageView {
    var isHiddenValue: Bool = true {
        didSet {
            self.isHidden = isHiddenValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setImage()
    }
    
    private func setImage() {
        let image = UIImage(named: "ic_error")
        self.image = image
        self.size(CGSize(width: 16, height: 16))
        self.isHidden = true
    }
}

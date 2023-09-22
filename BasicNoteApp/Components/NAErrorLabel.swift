//
//  NaErrorLabel.swift
//  BasicNoteApp
//
//  Created by mert polat on 25.07.2023.
//

import UIKit

class NaErrorLabel: UILabel {
    var isHiddenValue: Bool = true {
        didSet {
            self.isHidden = isHiddenValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLabel()
    }
    
    private func setLabel() {
        self.textColor = UIColor(named: "Helper Color-Red")
        self.isHidden = true
    }
}

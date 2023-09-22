//
//  UIColor+Extensions.swift
//  BasicNoteApp
//
//  Created by mert polat on 23.07.2023.
//

import UIKit

extension UIColor {

  enum Colors {
      case ActionPrimaryEnable
      case ActionPrimaryDisabled
      case BorderColor
      case Green
      case Red
      case Yellow
      case White
      case TextPrimary
      case TextSecondary
      case costum(colorName: String)
  }

    static func color(_ color: Colors) -> UIColor {
      let SelectedColor: UIColor
        switch color {
        case .ActionPrimaryEnable :
            SelectedColor = UIColor(named: "Action Primary -100")!
        case .ActionPrimaryDisabled:
            SelectedColor = UIColor(named: "Action Primary-50")!
        case .BorderColor:
            SelectedColor = UIColor(named: "Border Color")!
        case .Green:
            SelectedColor = UIColor(named: "Helper Color-Green")!
        case .Red:
            SelectedColor = UIColor(named: "Helper Color-Red")!
        case .Yellow:
            SelectedColor = UIColor(named: "Helper Color-Yellow")!
        case .White:
            SelectedColor = UIColor(named: "System Color-White")!
        case .TextPrimary:
            SelectedColor = UIColor(named: "Text Primary")!
        case .TextSecondary:
            SelectedColor = UIColor(named: "Text Secondary")!
        case .costum(colorName: let colorName):
            SelectedColor = UIColor(named: colorName)!
        }
      return SelectedColor
  }
}

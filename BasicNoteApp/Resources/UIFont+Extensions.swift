//
//  Font.swift
//  BasicNoteApp
//
//  Created by mert polat on 22.07.2023.
//

import UIKit

extension UIFont {

  enum FontWeight {
      case interMedium
      case interSemiBold
  }

  enum FontSize {
      /// 14
      case small

      /// 26
      case large

      /// 16
      case normal

      /// custom
      case custom(size: CGFloat)

      public var rawValue: CGFloat {
          switch self {
          case .small: return 14
          case .normal: return 16
          case .large:  return 26
          case .custom(let size):return size
          }
      }
  }
    
  static func font(_ weight: UIFont.FontWeight, size: FontSize) -> UIFont {
      let font: UIFont
      switch weight {
          
      case .interMedium:
          font = UIFont(name: "Inter-Medium", size: size.rawValue)!
      case .interSemiBold:
          font = UIFont(name: "Inter-SemiBold", size: size.rawValue)!
      }
      return font
  }
}

//
//  CustomLabel.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import Foundation
import UIKit

@IBDesignable
class CustomLabel : UILabel {
    
    enum CustomLabelType {
        case title
        case body
    }
    
    public init(text: String = "", type: CustomLabelType = .body) {
        self.customType = type
        super.init(frame: .zero)
        self.cor = AppColor.primaryButton
        self.texto = text
        self.fontSize = customType == .title ? 18 : 12
        self.cor = customType == .title ? AppColor.title : AppColor.body
        updateTitulo()
        updateFont()
    }
    
    required init?(coder: NSCoder) {
        self.customType = .body
        super.init(coder: coder)
    }
    
    // Constants
    private let customType: CustomLabelType
    
    // Interface Builder Fields
    
    @IBInspectable
    var texto : String = "" {
        didSet {
            self.updateTitulo()
        }
    }
    
    @IBInspectable
    var fontSize : CGFloat = 12 {
        didSet {
            self.updateFont()
        }
    }
    
    @IBInspectable
    var cor : UIColor = AppColor.body {
        didSet {
            self.textColor = cor
        }
    }
    
    private func updateTitulo() {
        self.text = texto
    }
    
    private func updateFont() {
        if customType == .title {
            self.font = .boldSystemFont(ofSize: fontSize)
        } else {
            self.font = .systemFont(ofSize: fontSize)
        }
    }
}



//
//  CustomLabel.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import Foundation
import UIKit
import SwiftUI

@IBDesignable
class CustomLabel : UILabel {
    
    enum CustomLabelType {
        case title
        case body
    }
    
    public init(text: String? = "", type: CustomLabelType = .body) {
        self.customType = type
        super.init(frame: .zero)
        self.cor = AppColor.primaryButton
        self.texto = text ?? ""
        self.fontSize = customType == .title ? 20 : 15
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
        self.numberOfLines = 0
    }
    
    private func updateFont() {
        if customType == .title {
            self.font = .boldSystemFont(ofSize: fontSize)
        } else {
            self.font = .systemFont(ofSize: fontSize)
        }
    }
}

struct CustomLabelView: UIViewRepresentable {
    var text: String?
    var type: CustomLabel.CustomLabelType
    var textSize: Float = 15

    func makeUIView(context: Context) -> CustomLabel {
        let label = CustomLabel(text: text, type: type)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }

    func updateUIView(_ uiView: CustomLabel, context: Context) {
        uiView.texto = text ?? ""
        uiView.fontSize = CGFloat(textSize)
        uiView.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32
    }
}

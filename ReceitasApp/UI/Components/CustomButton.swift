//
//  CustomButton.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import Foundation
import UIKit

@IBDesignable
class CustomButton : UIButton {
    
    enum CustomButtonType {
        case primary
        case secondary
    }
    
    public init(type: CustomButtonType = .primary, text: String = "", onTap: (() -> Void)? = nil) {
        self.customType = type
        super.init(frame: .zero)
        self.cor = AppColor.primaryButton
        self.preenchimento = type == .primary
        setup()
        self.texto = text
        self.onTap = onTap
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        setTitle(texto.uppercased(), for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize:fontSize)
    }
    
    required init?(coder: NSCoder) {
        self.customType = .primary
        super.init(coder: coder)
        setup()
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        onTap?()
    }
    
    // Constants
    private let customType: CustomButtonType
    private var onTap: (() -> Void)?
    private let cornerRadius : CGFloat = 24
    private var activityIndicator: UIActivityIndicatorView?
    
    // Interface Builder Fields
    
    @IBInspectable
    var texto : String = "" {
        didSet {
            setTitle(texto.uppercased(), for: .normal)
        }
    }
    
    @IBInspectable
    lazy var preenchimento : Bool = true {
        didSet {
            refreshBackground()
        }
    }
    
    @IBInspectable
    var arredondado : Bool = true {
        didSet {
            refreshCorner()
        }
    }
    
    @IBInspectable
    var fontSize : CGFloat = 16 {
        didSet {
            titleLabel?.font = UIFont.boldSystemFont(ofSize:fontSize)
        }
    }
    
    @IBInspectable
    var cor : UIColor = AppColor.primaryButton {
        didSet {
            refreshBackground()
        }
    }
    
    @IBInspectable
    var tamanhoBorda : Int = 1 {
        didSet {
            refreshBackground()
        }
    }
    
    @IBInspectable
    var habilitado : Bool = true {
        didSet {
            if habilitado {
                ativar()
            }
            else {
                desativar()
            }
        }
    }
    
    var defaultHeight: CGFloat = 48 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        let original = super.intrinsicContentSize
        return CGSize(width: original.width, height: defaultHeight)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        refreshBackground()
    }
    
    private func setup() {
        refreshBackground()
        refreshCorner()
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.boldSystemFont(ofSize:fontSize)
    }
    
    private func ativar(){
        self.isEnabled = true
        cor = AppColor.primaryButton
        refreshBackground()
    }
    
    private func desativar(){
        self.isEnabled = false
        cor = AppColor.primaryButtonDisabled
        refreshBackground()
    }
    
    // Set up view
    
    private func refreshCorner() {
        if (arredondado) {
            layer.cornerRadius = cornerRadius
        } else {
            layer.cornerRadius = 0
        }
    }
    
    private func refreshBackground() {
        let mainColor = cor
        
        if preenchimento { // preenche o botão
            layer.backgroundColor = mainColor.cgColor
            layer.borderWidth = 0
            setTitleColor(AppColor.background, for: .normal)
        } else {
            layer.backgroundColor = UIColor.clear.cgColor
            layer.borderColor = mainColor.cgColor
            setTitleColor(mainColor, for: .normal)
            layer.borderWidth = CGFloat(tamanhoBorda)
        }
    }
    
    public func setLoading(visible: Bool) {
        if visible {
            if activityIndicator == nil {
                let indicator = UIActivityIndicatorView(style: .medium)
                indicator.color = self.titleColor(for: .normal)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                addSubview(indicator)
                NSLayoutConstraint.activate([
                    indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                    indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
                activityIndicator = indicator
            }
            setTitleColor(.clear, for: .normal)
            titleLabel?.layer.opacity = 0
            isEnabled = false
            activityIndicator?.startAnimating()
        } else {
            setTitleColor(preenchimento ? AppColor.body : cor, for: .normal)
            titleLabel?.layer.opacity = 1
            isEnabled = true
            activityIndicator?.stopAnimating()
        }
    }
}

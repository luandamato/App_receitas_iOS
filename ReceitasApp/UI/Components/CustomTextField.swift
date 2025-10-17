//
//  CustomTextField.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//


import Foundation
import UIKit

@IBDesignable
class CustomEditText : UIView, UITextFieldDelegate {
    
    private var editText: UITextField = UITextField() {
        didSet {
            //Default editText
            self.editText.textColor = AppColor.body
            self.editText.font = UIFont.systemFont(ofSize: 16)
            self.editText.delegate = self
        }
    }
    var stack: UIStackView = UIStackView()
    var viewBorda: UIView = UIView()
    var viewBlock: UIView = UIView()
    var lbl: UILabel = UILabel()
    var lblErro: UILabel = UILabel()
    var altura: CGFloat = 63
    // Constants
    
    let borderWidth : CGFloat = 1
    let fontSize : CGFloat = 12
    let cornerRadius : CGFloat = 5
    
    
    
    @IBInspectable
    var titulo : String = "" {
        didSet {
            self.updateTitulo()
        }
    }
    
    @IBInspectable
    var placeholder : String = "" {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    @IBInspectable
    var texto : String = "" {
        didSet {
            self.editText.text = texto
            self.editText.font = UIFont.systemFont(ofSize: 16)
            self.editText.textColor = AppColor.body
        }
    }
    
    @IBInspectable
    var arredondado : Bool = true {
        didSet {
            refreshCorner()
        }
    }
    
    @IBInspectable
    var senha : Bool = false {
        didSet {
            if senha{
                self.editText.isSecureTextEntry = true
                
                let button = UIButton(type: .custom)
                let image = getImageEye()
                
                button.setImage(image, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 5, right: 10)
                button.frame = CGRect(x: self.frame.size.width , y: 5, width: 30, height: 30)
                button.addTarget(self, action: #selector(verCampo), for: .touchUpInside)
                self.editText.rightView = button
                self.editText.rightViewMode = .always
            }
        }
    }
    
    
    @IBInspectable
    var enable : Bool = true {
        didSet {
            self.viewBlock.isHidden = enable
            self.editText.isEnabled = enable
            if !enable{
                self.editText.textColor = AppColor.divider
            }
        }
    }
    
    @IBInspectable
    var autocapitalizationType : UITextAutocapitalizationType = .sentences {
        didSet {
            if !senha{
                self.editText.autocapitalizationType = autocapitalizationType
            }
        }
    }
    
    @IBInspectable
    var tipoTeclado : UIKeyboardType = .default {
        didSet {
            self.editText.keyboardType = tipoTeclado
        }
    }
    
    public init(titulo: String = "", placeholder: String = "") {
        super.init(frame: .zero)
        self.setup()
        self.titulo = titulo
        self.placeholder = placeholder
        updateTitulo()
        updatePlaceholder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func updateTitulo() {
        lbl.text = titulo
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = AppColor.body
    }

    private func updatePlaceholder() {
        editText.placeholder = placeholder
    }
    
    @objc private func checkAction(sender : UITapGestureRecognizer) {
        self.editText.becomeFirstResponder()
    }
    
    private func getImageEye(name: String = "Show") -> UIImage? {
        let image = UIImage(named: name)
        return image?.resize(maxWidthHeight: 30)
    }
    
    @objc private func verCampo(_ sender: UIButton) {
        
        self.editText.isSecureTextEntry = !self.editText.isSecureTextEntry
        
        if self.editText.isSecureTextEntry {
            let image = getImageEye(name: "Show")
            sender.setImage(image, for: .normal)
        } else {
            let image = getImageEye(name: "Hide")
            sender.setImage(image, for: .normal)
        }
    }
    
    private func setup() {
        setLblColor()
        setBorderColor()
        setBackgroundColor()
        refreshCorner()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.addGestureRecognizer(gesture)
        
        self.viewBorda.layer.borderColor = AppColor.divider.cgColor
        self.viewBorda.layer.borderWidth = 1

        
        self.lblErro.numberOfLines = 0
        self.lblErro.font = UIFont.systemFont(ofSize: 12)
        self.lbl.numberOfLines = 0
        self.editText.delegate = self
        
        
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 12
        
        viewBorda.addSubview(viewBlock)
        viewBorda.addSubview(editText)
        
        self.editText.translatesAutoresizingMaskIntoConstraints = false
        self.editText.leadingAnchor.constraint(equalTo: self.viewBorda.leadingAnchor, constant: 15).isActive = true
        self.editText.trailingAnchor.constraint(equalTo: self.viewBorda.trailingAnchor, constant: -15).isActive = true
        self.editText.topAnchor.constraint(equalTo: self.viewBorda.topAnchor, constant: 15).isActive = true
        self.editText.bottomAnchor.constraint(equalTo: self.viewBorda.bottomAnchor, constant: -15).isActive = true
        
        self.viewBlock.translatesAutoresizingMaskIntoConstraints = false
        self.viewBlock.leadingAnchor.constraint(equalTo: self.viewBorda.leadingAnchor, constant: 0).isActive = true
        self.viewBlock.trailingAnchor.constraint(equalTo: self.viewBorda.trailingAnchor, constant: 0).isActive = true
        self.viewBlock.topAnchor.constraint(equalTo: self.viewBorda.topAnchor, constant: 0).isActive = true
        self.viewBlock.bottomAnchor.constraint(equalTo: self.viewBorda.bottomAnchor, constant: 0).isActive = true
        viewBlock.isHidden = true
        viewBlock.backgroundColor = AppColor.divider.withAlphaComponent(0.7)
        
        stack.addArrangedSubview(lbl)
        stack.addArrangedSubview(viewBorda)
        stack.addArrangedSubview(lblErro)
        
        addSubview(stack)
        
        
        self.stack.translatesAutoresizingMaskIntoConstraints = false
        self.stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true

        self.lblErro.isHidden = true
    }
    
    public func setErro(erro: String){
        lblErro.isHidden = erro.isEmpty
        lblErro.text = erro
        self.lblErro.textColor = AppColor.error
        self.viewBorda.layer.borderColor = AppColor.error.cgColor
        self.viewBorda.layer.borderWidth = 1
    }
    
    public func setOK(){
        lblErro.isHidden = true
        self.viewBorda.layer.borderColor = AppColor.divider.cgColor
        self.viewBorda.layer.borderWidth = 1
        setLblColor()
        setBorderColor()
        refreshCorner()
    }
    
    // Set up view
    
    private func refreshCorner() {
        if (arredondado) {
            self.viewBorda.layer.cornerRadius = cornerRadius
            self.viewBlock.layer.cornerRadius = cornerRadius
        } else {
            self.viewBorda.layer.cornerRadius = 0
            self.viewBlock.layer.cornerRadius = 0
        }
    }
    
    private func setLblColor() {
        self.lbl.textColor = AppColor.title
        self.editText.textColor = AppColor.title
        self.editText.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func setBorderColor() {
        self.viewBorda.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setBackgroundColor() {
        self.backgroundColor = .clear
        self.stack.backgroundColor = .clear
        self.viewBorda.backgroundColor = AppColor.background
            
    }
    
}

extension CustomEditText{
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
    
    // MARK: - Gets
    
    func getTexto() -> String?{
        return self.editText.text
    }
}

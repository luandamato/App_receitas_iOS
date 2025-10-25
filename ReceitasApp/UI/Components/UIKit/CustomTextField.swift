//
//  CustomTextField.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//


import Foundation
import UIKit
import SwiftUI

protocol SearchDelegate {
    func searchLocal(value: String)
    func searchRemote(value: String)
}

@IBDesignable
class CustomEditText : UIView, UITextFieldDelegate {
    
    private var widthConstraint: NSLayoutConstraint?
    enum CustomEditTextType {
        case normal
        case password
        case search
    }
    private var debounceTimer: Timer?
    var searchDelegate: SearchDelegate?
    fileprivate var editText: UITextField = UITextField() {
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
    var lbl: CustomLabel = CustomLabel(type: .body)
    var lblErro: UILabel = UILabel()
    var altura: CGFloat = 63
    // Constants
    
    let borderWidth : CGFloat = 1
    let fontSize : CGFloat = 12
    let cornerRadius : CGFloat = 5
    
    override var intrinsicContentSize: CGSize {
        // Permite que o SwiftUI defina a largura
        return CGSize(width: UIView.noIntrinsicMetric, height: altura)
    }
    
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
    private var texto : String = "" {
        didSet {
            self.editText.text = texto
        }
    }
    
    @IBInspectable
    var arredondado : Bool = true {
        didSet {
            refreshCorner()
        }
    }
    
    var type: CustomEditTextType = .normal {
        didSet {
            switch type {
            case .normal:
                break
                
            case .password:
                self.editText.isSecureTextEntry = true
                setButtonImage(named: "Show", action: #selector(verCampo))
                break
                
            case .search:
                self.editText.returnKeyType = .search
                setButtonImage(named: "search", action: #selector(search))
                break
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
            if type == .normal {
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
    }

    private func updatePlaceholder() {
        editText.placeholder = placeholder
    }
    
    @objc private func checkAction(sender : UITapGestureRecognizer) {
        self.editText.becomeFirstResponder()
    }
    
    private func setButtonImage(named: String, action: Selector){
        let button = UIButton(type: .custom)
        let image = getImage(name: named)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: self.frame.size.width , y: 5, width: 30, height: 30)
        button.addTarget(self, action: action, for: .touchUpInside)
        self.editText.rightView = button
        self.editText.rightViewMode = .always
    }
    
    private func getImage(name: String) -> UIImage? {
        let image = UIImage(named: name)
        return image?.resize(maxWidthHeight: 30)
    }
    
    @objc private func verCampo(_ sender: UIButton) {
        self.editText.isSecureTextEntry = !self.editText.isSecureTextEntry
        if self.editText.isSecureTextEntry {
            let image = getImage(name: "Show")
            sender.setImage(image, for: .normal)
        } else {
            let image = getImage(name: "Hide")
            sender.setImage(image, for: .normal)
        }
    }
    
    @objc private func search(_ sender: UIButton) {
        endEditing(true)
        guard let value = self.editText.text else {
            return
        }
        self.searchDelegate?.searchRemote(value: value)
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
        
        
        self.stack.alignment = .fill
        self.stack.distribution = .equalSpacing
        self.stack.axis = .vertical
        self.stack.spacing = 12
        
        self.editText.font = UIFont.systemFont(ofSize: 16)
        self.editText.textColor = AppColor.body
        
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
    
    func setWidth(_ width: CGFloat) {
        if let widthConstraint = widthConstraint {
            widthConstraint.constant = width
        } else {
            widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
            widthConstraint?.isActive = true
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}

extension CustomEditText{
    
    func getTexto() -> String{
        return self.editText.text ?? ""
    }
    
    func set(texto: String){
        self.editText.text = texto
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if type != .search { return true }
        
        // ao digitar procura resultado localmente, se parar de digitar por 2 segundos busca novos resultados na API
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        self.searchDelegate?.searchLocal(value: newText)
        
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            guard let value = self?.editText.text else {
                return
            }
            self?.searchDelegate?.searchRemote(value: value)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        if type != .search { return true }
        debounceTimer?.invalidate()
        guard let value = self.editText.text else {
            return true
        }
        self.searchDelegate?.searchRemote(value: value)
        return true
    }
}

@IBDesignable
class CustomTextArea: UIView, UITextViewDelegate {
    
    private var widthConstraint: NSLayoutConstraint?

    // MARK: - Subviews
    
    fileprivate lazy var editText: UITextView = {
        let view = UITextView()
        view.textColor = AppColor.body
        view.font = UIFont.systemFont(ofSize: 16)
        view.delegate = self
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        return view
    }()
    
    private var stack = UIStackView()
    private var viewBorda = UIView()
    private var viewBlock = UIView()
    private var lbl: CustomLabel = CustomLabel(type: .body)
    private var lblErro = UILabel()
    private var lblContador = UILabel()

    private var alturaConstraint: NSLayoutConstraint?
    
    // MARK: - Constants
    
    private let borderWidth: CGFloat = 1
    private let fontSize: CGFloat = 12
    private let cornerRadius: CGFloat = 5
    
    // MARK: - Inspectables
    
    @IBInspectable
    var titulo: String = "" {
        didSet { updateTitulo() }
    }
    
    @IBInspectable
    private var texto: String = "" {
        didSet { editText.text = texto }
    }
    
    @IBInspectable
    var arredondado: Bool = true {
        didSet { refreshCorner() }
    }
    
    @IBInspectable
    var limiteCaracteres: Int = 200 {
        didSet { updateContador() }
    }
    
    @IBInspectable
    var exibeLimite: Bool = true {
        didSet { updateContador() }
    }
    
    // MARK: - Init
    
    public init(titulo: String = "") {
        super.init(frame: .zero)
        setup()
        self.titulo = titulo
        updateTitulo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        setLblColor()
        setBorderColor()
        setBackgroundColor()
        refreshCorner()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction))
        addGestureRecognizer(gesture)
        
        viewBorda.layer.borderColor = AppColor.divider.cgColor
        viewBorda.layer.borderWidth = 1
        
        lblErro.numberOfLines = 0
        lblErro.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        lblContador.font = UIFont.systemFont(ofSize: 12)
        lblContador.textColor = AppColor.body
        lblContador.textAlignment = .right
        
        // Stack principal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 8
        
        viewBorda.addSubview(viewBlock)
        viewBorda.addSubview(editText)
        
        // Constraints da área de texto
        editText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editText.leadingAnchor.constraint(equalTo: viewBorda.leadingAnchor, constant: 15),
            editText.trailingAnchor.constraint(equalTo: viewBorda.trailingAnchor, constant: -15),
            editText.topAnchor.constraint(equalTo: viewBorda.topAnchor, constant: 15),
            editText.bottomAnchor.constraint(equalTo: viewBorda.bottomAnchor, constant: -15)
        ])
        
        // View de bloqueio
        viewBlock.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewBlock.leadingAnchor.constraint(equalTo: viewBorda.leadingAnchor),
            viewBlock.trailingAnchor.constraint(equalTo: viewBorda.trailingAnchor),
            viewBlock.topAnchor.constraint(equalTo: viewBorda.topAnchor),
            viewBlock.bottomAnchor.constraint(equalTo: viewBorda.bottomAnchor)
        ])
        viewBlock.isHidden = true
        viewBlock.backgroundColor = AppColor.divider.withAlphaComponent(0.7)
        
        // Define altura fixa (5 linhas)
        let lineHeight: CGFloat = editText.font?.lineHeight ?? 20
        let totalHeight = lineHeight * 5 + 30 // padding 15 em cima e 15 embaixo
        alturaConstraint = viewBorda.heightAnchor.constraint(equalToConstant: totalHeight)
        alturaConstraint?.isActive = true
        
        // Montagem da stack
        stack.addArrangedSubview(lbl)
        stack.addArrangedSubview(viewBorda)
        stack.addArrangedSubview(lblContador)
        stack.addArrangedSubview(lblErro)
        
        addSubview(stack)
        
        // Constraints da stack
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        lblErro.isHidden = true
        updateContador()
    }
    
    // MARK: - Updates
    
    private func updateTitulo() {
        lbl.text = titulo
    }
    
    private func updateContador() {
        let count = editText.text.count
        lblContador.text = "\(count)/\(limiteCaracteres)"
        lblContador.textColor = count > limiteCaracteres ? AppColor.error : AppColor.body
        lblContador.isHidden = !exibeLimite
    }
    
    // MARK: - Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        updateContador()
    }
    
    // MARK: - Actions
    
    @objc private func checkAction(sender: UITapGestureRecognizer) {
        editText.becomeFirstResponder()
    }
    
    // MARK: - Visual helpers
    
    public func setErro(erro: String) {
        lblErro.isHidden = erro.isEmpty
        lblErro.text = erro
        lblErro.textColor = AppColor.error
        viewBorda.layer.borderColor = AppColor.error.cgColor
        viewBorda.layer.borderWidth = 1
    }
    
    public func setOK() {
        lblErro.isHidden = true
        viewBorda.layer.borderColor = AppColor.divider.cgColor
        viewBorda.layer.borderWidth = 1
        setLblColor()
        setBorderColor()
        refreshCorner()
    }
    
    private func refreshCorner() {
        let radius = arredondado ? cornerRadius : 0
        viewBorda.layer.cornerRadius = radius
        viewBlock.layer.cornerRadius = radius
    }
    
    private func setLblColor() {
        lbl.textColor = AppColor.title
        editText.textColor = AppColor.title
        editText.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func setBorderColor() {
        viewBorda.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setBackgroundColor() {
        backgroundColor = .clear
        stack.backgroundColor = .clear
        viewBorda.backgroundColor = AppColor.background
    }
    
    func set(texto: String){
        self.editText.text = texto
    }
    
    func setWidth(_ width: CGFloat) {
        if let widthConstraint = widthConstraint {
            widthConstraint.constant = width
        } else {
            widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
            widthConstraint?.isActive = true
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

struct CustomEditTextView: UIViewRepresentable {
    @Binding var text: String
    var title: String
    var placeholder: String
    var type: CustomEditText.CustomEditTextType
    var enable: Bool = true
    var onSearchLocal: ((String) -> Void)? = nil
    var onSearchRemote: ((String) -> Void)? = nil

    func makeUIView(context: Context) -> CustomEditText {
        let view = CustomEditText(titulo: title, placeholder: placeholder)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.type = type
        view.enable = enable
        view.searchDelegate = context.coordinator
        view.set(texto: text)
        view.editText.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: CustomEditText, context: Context) {
        if uiView.getTexto() != text {
            uiView.set(texto: text)
        }
        uiView.enable = enable
        uiView.type = type
        DispatchQueue.main.async {
            if let superview = uiView.superview {
                uiView.setWidth(superview.bounds.width)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, SearchDelegate, UITextFieldDelegate {
        var parent: CustomEditTextView
        init(parent: CustomEditTextView) { self.parent = parent }
        func searchLocal(value: String) { parent.onSearchLocal?(value) }
        func searchRemote(value: String) { parent.onSearchRemote?(value) }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

struct CustomTextAreaView: UIViewRepresentable {
    @Binding var text: String
    var title: String
    var showLimit = true
    var characterLimit = 200

    func makeUIView(context: Context) -> CustomTextArea {
        let view = CustomTextArea(titulo: title)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set(texto: text)
        view.exibeLimite = showLimit
        view.limiteCaracteres = characterLimit
        view.editText.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: CustomTextArea, context: Context) {
        if uiView.editText.text != text {
            uiView.set(texto: text)
        }
        DispatchQueue.main.async {
            if let superview = uiView.superview {
                uiView.setWidth(superview.bounds.width)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // ✅ Coordinator responsável por sincronizar o texto UIKit → SwiftUI
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextAreaView
        init(parent: CustomTextAreaView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

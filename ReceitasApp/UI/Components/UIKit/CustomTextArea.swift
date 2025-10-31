//
//  CustomTextArea.swift
//  Recipes
//
//  Created by Luan Damato on 25/10/25.
//

import UIKit
import SwiftUI

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

    public func setError(_ error: String?){
        guard let error else {
            setOK()
            return
        }
        lblErro.isHidden = error.isEmpty
        lblErro.text = error
        self.lblErro.textColor = AppColor.error
        self.viewBorda.layer.borderColor = AppColor.error.cgColor
        self.viewBorda.layer.borderWidth = 1
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
    
    func set(texto: String?){
        self.editText.text = texto ?? ""
    }
    
    func getTexto() -> String{
        return editText.text ?? ""
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

//
//  CustomLoader.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import Foundation
import UIKit


class CustomLoader: UIView{
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
        $0.distribution = .equalCentering
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.backgroundColor = .clear
        return $0
    }(UIStackView())
    
    lazy var circle1: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.masksToBounds = true
        circle.backgroundColor = AppColor.primary
        circle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        circle.layer.cornerRadius = 5
        return circle
    }()
    
    lazy var circle2: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.masksToBounds = true
        circle.backgroundColor = AppColor.primary
        circle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        circle.layer.cornerRadius = 5
        return circle
    }()
    
    lazy var circle3: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.masksToBounds = true
        circle.backgroundColor = AppColor.primary
        circle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        circle.widthAnchor.constraint(equalToConstant: 10).isActive = true
        circle.layer.cornerRadius = 5
        return circle
    }()
    
    private lazy var circles = [circle1, circle2, circle3]
    
    func animate(){
        var delay: TimeInterval = 0
        for circle in circles{
            UIView.animate(withDuration: 0.5, delay: delay, options: [.repeat, .autoreverse], animations: {
                circle.alpha = 0
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: delay + 0.5, options: [.repeat, .autoreverse], animations: {
                circle.alpha = 1
            }, completion: nil)
            
            delay += 0.25
        }
    }
    
    init(){
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setFullScreen(_ value: Bool){
        self.backgroundColor = value ? AppColor.background : .clear
    }
    
    func configure(){
        self.backgroundColor = AppColor.background
        addSubview(stackView)
        stackView.addArrangedSubview(circle1)
        stackView.addArrangedSubview(circle2)
        stackView.addArrangedSubview(circle3)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

//
//  SwiftUiVC.swift
//  Recipes
//
//  Created by Luan Damato on 23/10/25.
//

import UIKit
import SwiftUI

class SwiftUiVC<Content: View>: BaseViewController {
    
    private let swiftUIView: Content
    private var screenTitle: String = ""
    
    init(swiftUIView: Content, title: String = "") {
        self.swiftUIView = swiftUIView
        self.screenTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton(title: screenTitle)
        // Cria o UIHostingController que embala a view SwiftUI
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Adiciona como filho do VC UIKit
        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}


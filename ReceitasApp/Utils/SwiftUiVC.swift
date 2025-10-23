//
//  SwiftUiVC.swift
//  Recipes
//
//  Created by Luan Damato on 23/10/25.
//

import UIKit
import SwiftUI

class SwiftUiVC<Content: View>: UIViewController {
    
    private let swiftUIView: Content
    
    init(swiftUIView: Content) {
        self.swiftUIView = swiftUIView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cria o UIHostingController que embala a view SwiftUI
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Adiciona como filho do VC UIKit
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}


//
//  BaseViewController.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import Foundation
import UIKit

class BaseViewController: UIViewController{
    
    let loadView = CustomLoader()
    
    override func viewDidLoad() {
        self.view.backgroundColor = AppColor.background
        loadView.translatesAutoresizingMaskIntoConstraints = false
        loadView.tag = 12321
        loadView.setFullScreen(true)
        self.view.addSubview(loadView)
        NSLayoutConstraint.activate([
            loadView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            loadView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            loadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.loadView.alpha = 0
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setLoading(visible: Bool, fullScreen: Bool = true){
        self.view.bringSubviewToFront(loadView)
        if !visible{
            UIView.animate(withDuration: 0.5) {
                self.loadView.alpha = 0
            }
            return
        }
        loadView.setFullScreen(fullScreen)
        loadView.animate()
        loadView.alpha = 1.0
    }
}

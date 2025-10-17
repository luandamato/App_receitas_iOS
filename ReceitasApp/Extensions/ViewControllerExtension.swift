//
//  ViewControllerExtension.swift
//  Recipes
//
//  Created by Luan Damato on 17/10/25.
//

import UIKit

extension UIViewController {
    
    func showToast(message : String) {
        let window: UIView = UIApplication.shared.keyWindow ?? self.view
        let toastLabel = UILabel(frame: CGRect(x: 30, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 60, height: 50))
        toastLabel.backgroundColor = AppColor.divider.withAlphaComponent(0.9)
        toastLabel.textColor = AppColor.body
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        window.addSubview(toastLabel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    func closeKeyboardOnTouch(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func removeSubview(withTag: Int){
        if let viewWithTag = self.view.viewWithTag(withTag) {
            viewWithTag.removeFromSuperview()
        }
    }
}

extension UIViewController {

    /// Chame no `viewDidLoad` passando a sua scrollview.
    func setupKeyboardHandling(_ scrollView: UIScrollView) {
        
        NotificationCenter.default.addObserver(forName:UIResponder.keyboardWillShowNotification, object:nil, queue:.main) { [weak self] notification in
            
            guard let userInfo = notification.userInfo,
                  let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
            var insets = scrollView.contentInset
            insets.bottom = keyboardFrame.height + 16 // margem extra opcional
            
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            
            // Se algum campo estiver focado, rola até ele:
            if let firstResponder = self?.view.findFirstResponder(),
               let responderFrameInScroll = firstResponder.superview?.convert(firstResponder.frame, to: scrollView) {
                scrollView.scrollRectToVisible(responderFrameInScroll, animated:true)
            }
            
         }
        
         NotificationCenter.default.addObserver(forName:UIResponder.keyboardWillHideNotification, object:nil, queue:.main) { _ in
            
             var insets = scrollView.contentInset
             insets.bottom = 0
            
             scrollView.contentInset = insets
             scrollView.scrollIndicatorInsets = insets
            
         }
     }
}

// Helper para achar o responder atual:
extension UIView {
    func findFirstResponder() -> UIView? {
       if isFirstResponder { return self }
       for subview in subviews {
           if let responder = subview.findFirstResponder() { return responder }
       }
       return nil
   }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var getTopViewController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        
        if let presentedController = viewController as? UITabBarController {
            viewController = presentedController.selectedViewController
        }
        
        while let presentedController = viewController?.presentedViewController {
            if let presentedController = presentedController as? UITabBarController {
                viewController = presentedController.selectedViewController
            } else {
                viewController = presentedController
            }
        }
        
        return viewController
    }
    
}

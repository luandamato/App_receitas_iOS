//
//  StringExtension.swift
//  Recipes
//
//  Created by Luan Damato on 17/10/25.
//

import UIKit

extension String {
    static func stringFor(text: String) -> String {
        return NSLocalizedString(text, comment: "")
    }
    
}

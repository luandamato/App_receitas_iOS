//
//  StringExtension.swift
//  Recipes
//
//  Created by Luan Damato on 17/10/25.
//

import UIKit

extension String {
    static func stringFor(text: StringNameConstants) -> String {
        return NSLocalizedString(text.rawValue, comment: "")
    }
    
}

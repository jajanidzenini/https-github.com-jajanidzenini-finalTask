//
//  StringExtension.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 19.01.24.
// 
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "\(self) could not be found in Localizable.strings")
    }
}

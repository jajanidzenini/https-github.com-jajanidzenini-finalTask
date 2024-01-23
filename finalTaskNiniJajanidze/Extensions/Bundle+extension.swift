//
//  Bundle+extension.swift
//  FinalApplication
//
//  Created by Admin on 22.01.24.
//

import Foundation

private var kBundleKey: UInt8 = 0

class LocalizedBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, &kBundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, LocalizedBundle.self)
        }

        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let newBundle = Bundle(path: path) else { return }
        
        objc_setAssociatedObject(Bundle.main, &kBundleKey, newBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

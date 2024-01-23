//
//  UIViewController+Extension.swift
//  FinalApplication
//
//  Created by Admin on 18.01.24.
//

import UIKit
import AVFAudio

extension UIViewController {
    func showToast(_ message: String) {
        let messageLbl = UILabel()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = UIFont.systemFont(ofSize: 14)
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let textSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, self.view.frame.width - 40)
        
        messageLbl.frame = CGRect(x: 20, y: self.view.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
        messageLbl.center.x = self.view.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height / 2
        messageLbl.layer.masksToBounds = true
        self.view.addSubview(messageLbl)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1, animations: {
                messageLbl.alpha = 0
            }) { _ in
                messageLbl.removeFromSuperview()
            }
        }
    }
}

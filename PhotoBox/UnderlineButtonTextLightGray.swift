//
//  UnderlineButtonText.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class UnderlineButtonTextLightGray: UIButton {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: .normal)
        self.setAttributedTitle(self.attributedString(), for: .normal)
    }
    
    private func attributedString() -> NSAttributedString? {
        let lightGray = UIColor(named: "textLightGray") ?? .lightGray
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : lightGray,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        return attributedString
    }
}

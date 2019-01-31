//
//  Extensions.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/24/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

extension Date {
    
    func formattedString() -> String {

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        let dateString = formatter.string(from: self)
        return dateString
    }
    
}

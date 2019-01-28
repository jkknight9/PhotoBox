//
//  LoggedOutViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class LoggedOutViewController: UIViewController {

    @IBOutlet weak var logBackInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logBackInButton.backgroundColor = UIColor(displayP3Red: 0.61, green: 0.61, blue: 0.61, alpha: 1)
        logBackInButton.layer.cornerRadius = logBackInButton.frame.height / 2
    }
    
    @IBAction func logBackInButtonTapped(_ sender: UIButton) {
        
    }
}

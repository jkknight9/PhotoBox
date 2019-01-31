//
//  ModalPopUpViewController.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/31/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class ModalPopUpViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        label.text = message
        popUpView.layer.cornerRadius = 10
        popUpView.layer.shadowOpacity = 0.5
        popUpView.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        popUpView.layer.shadowRadius = 10
        popUpView.layer.cornerRadius = 10
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  CreateEventTableViewController.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/22/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class CreateEventTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

     //   MARK: - Outlets
    @IBOutlet weak var selectCoverPhotoButton: UnderlineButtonTextPurple!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var eventNameTextField: PaddingTextField!
    @IBOutlet weak var startTimeTextField: PaddingTextField!
    @IBOutlet weak var endTimeTextField: PaddingTextField!
    @IBOutlet weak var eventLocationTextField: PaddingTextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    var startTime: TimeInterval?
    var endTime: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New PhotoBox"
        selectCoverPhotoButton.setTitle("Choose Photo", for: .normal)
        
        eventNameTextField.setPadding(left: 20)
        startTimeTextField.setPadding(left: 20)
        endTimeTextField.setPadding(left: 20)
        eventLocationTextField.setPadding(left: 20)
        
        let borderColor = UIColor(displayP3Red: 0.42, green: 0.48, blue: 0.56, alpha: 1).cgColor
        eventNameTextField.layer.cornerRadius = eventNameTextField.frame.height / 2
        eventNameTextField.layer.borderWidth = 2
        eventNameTextField.layer.borderColor = borderColor
        eventNameTextField.clipsToBounds = true
        
        startTimeTextField.layer.cornerRadius = startTimeTextField.frame.height / 2
        startTimeTextField.layer.borderWidth = 2
        startTimeTextField.layer.borderColor = borderColor
        startTimeTextField.clipsToBounds = true

        endTimeTextField.layer.cornerRadius = endTimeTextField.frame.height / 2
        endTimeTextField.layer.borderWidth = 2
        endTimeTextField.layer.borderColor = borderColor
        endTimeTextField.clipsToBounds = true

        eventLocationTextField.layer.cornerRadius = eventLocationTextField.frame.height / 2
        eventLocationTextField.layer.borderWidth = 2
        eventLocationTextField.layer.borderColor = borderColor
        eventLocationTextField.clipsToBounds = true

        eventDetailsTextView.layer.cornerRadius = 9
        eventDetailsTextView.layer.borderWidth = 2
        eventDetailsTextView.layer.borderColor = borderColor
        eventDetailsTextView.clipsToBounds = true
        
        createEventButton.layer.cornerRadius = createEventButton.frame.height / 2
        cameraImageView.tintColor = UIColor.gray
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "buttonPurple")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case eventNameTextField:
            startTimeTextField.becomeFirstResponder()
        case startTimeTextField:
            endTimeTextField.becomeFirstResponder()
        case endTimeTextField:
            eventLocationTextField.becomeFirstResponder()
        case eventLocationTextField:
            eventDetailsTextView.becomeFirstResponder()
        default:
            eventDetailsTextView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func selectCoverPhotoButtonTapped(_ sender: Any) {
        
        let backgroundimage = UIImagePickerController()
        backgroundimage.delegate = self
        backgroundimage.sourceType = UIImagePickerController.SourceType.photoLibrary
        backgroundimage.allowsEditing = true
        backgroundimage.setEditing(true, animated: true)
        self.present(backgroundimage, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.backgroundImage.image = image
            selectCoverPhotoButton.isHidden = true
            cameraImageView.isHidden = true
        } else if let image = info[.originalImage] as? UIImage {
            backgroundImage.image = image
            selectCoverPhotoButton.isHidden = true
            cameraImageView.isHidden = true
        } else {
            print("Error picking image)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startTime(_ sender: UITextField) {
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.minimumDate = Date(timeIntervalSinceNow: 0)
        datePicker.minuteInterval = 1
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        sender.text = dateFormatter.string(from: datePicker.date)
        startTime = datePicker.date.timeIntervalSince1970
    
        sender.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: #selector(startTimePickerNextButtonPressed))
        toolBar.setItems([space, nextButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        sender.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(CreateEventTableViewController.startDatePickerValueChanged), for: UIControl.Event.valueChanged)
    }

    
    @objc func startDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        startTimeTextField.text = dateFormatter.string(from: sender.date)
        startTime = sender.date.timeIntervalSince1970
    }
    
    @IBAction func endTime(_ sender: UITextField) {
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        if let startTime = startTime {
            datePicker.minimumDate = Date(timeIntervalSince1970: startTime)
            datePicker.minuteInterval = 1
//            datePicker.setDate(Date(timeIntervalSinceNow: (60*60)), animated: true)
        } else {
            datePicker.minimumDate = Date(timeIntervalSinceNow: 0)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        sender.text = dateFormatter.string(from: datePicker.date)
        endTime = datePicker.date.timeIntervalSince1970
        
        sender.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.done, target: self, action: #selector(endTimePickerNextButtonPressed))
        toolBar.setItems([space, nextButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        sender.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(CreateEventTableViewController.endDatePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func endDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        endTimeTextField.text = dateFormatter.string(from: sender.date)
        endTime = sender.date.timeIntervalSince1970
    }
    
    
    @objc func startTimePickerNextButtonPressed() {
        endTimeTextField.becomeFirstResponder()
    }
    
    @objc func endTimePickerNextButtonPressed() {
        eventLocationTextField.becomeFirstResponder()
    }
    
    @IBAction func createEventButtonTapped(_ sender: Any) {
        guard let eventName = eventNameTextField.text,
            !eventName.isEmpty,
            let currentUser = UserController.shared.currentUser,
            let startTime = startTime,
            startTimeTextField.text != "",
            let endTime = endTime,
            endTimeTextField.text != "",
            let eventLocation = eventLocationTextField.text,
            let eventDetails = eventDetailsTextView.text
            else { presentRequiredFieldAlert() ; return }
        
        EventController.shared.createAnEvent(eventName: eventName, creatorID: currentUser.uuid , memberIDs: [currentUser.uuid], startTime: startTime, endTime: endTime, details: eventDetails, location: eventLocation) { (event) in
            if let event = event {
                if let backgroundImage = self.backgroundImage.image {
                    let backgroundPhoto = Photo(image: backgroundImage, eventID: event.uuid, creatorID: currentUser.uuid, creatorName: currentUser.name)
                    event.coverPhoto = backgroundImage
                    FirebaseManager.uploadPhotoToFirebase(backgroundPhoto, completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        if let url = url {
                            event.coverPhotoURL = "\(url)"
                            FirebaseManager.updateData(obect: event, dictionary: event.dictionary as [String : Any], completion: { (error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    print("success adding coverPhotoURL to new event.")
                                }
                            })
                        }
                    })
                }
                if currentUser.eventIDs == nil {
                    currentUser.eventIDs = [event.uuid]
                } else {
                    currentUser.eventIDs?.append(event.uuid)
                }
                UserController.shared.changeUserInfo(user: currentUser, completion: { (success) in
                    if success {
                        print("success adding new event to the user's events array")
                    } else {
                        print("error adding new event to the user's events array")
                    }
                })
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let eventDetailVC = storyboard.instantiateViewController(withIdentifier: "eventDetailVC") as! EventDetailTableViewController
                
                eventDetailVC.event = event
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(eventDetailVC, animated: true)
                }
            }
        }
    }
    
    func presentRequiredFieldAlert() {
        presentPhotoBoxModalVC(message: "Event Name, Start Time, and End Time are required fields.")
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    

}

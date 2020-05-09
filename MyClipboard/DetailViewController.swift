//
//  DetailViewController.swift
//  MyClipboard
//
//  Created by Muhammet Gürbüz on 7.05.2020.
//  Copyright © 2020 Muhammet Gürbüz. All rights reserved.
//

import UIKit
import Speech
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var choosenNoteId: String?
    var choosenNoteName: String?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var captionText: UITextField!
    
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var voiceImageView: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        SelectMode()
        
        let cameraGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectCameraImage))
        cameraImageView.addGestureRecognizer(cameraGestureRecognizer)
        
        let voiceGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartVoiceRecognizer))
        voiceImageView.addGestureRecognizer(voiceGestureRecognizer)
        
        if choosenNoteName == "" {
            btnUpdate.isHidden = true
        } else{
            captionText.text = choosenNoteName
            btnSave.isHidden = true
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let mode = traitCollection.userInterfaceStyle
        if mode == .dark {
            cameraImageView.image = UIImage(named: "camera_icon_light")
            voiceImageView.image = UIImage(named: "mic_icon_light")
        } else {
            cameraImageView.image = UIImage(named: "camera_icon_dark")
            voiceImageView.image = UIImage(named: "mic_icon_dark")
        }
               
    }
    
    func SelectMode() {
        let mode = traitCollection.userInterfaceStyle
        if mode == .dark {
            cameraImageView.image = UIImage(named: "camera_icon_light")
            voiceImageView.image = UIImage(named: "mic_icon_light")
        } else {
            cameraImageView.image = UIImage(named: "camera_icon_dark")
            voiceImageView.image = UIImage(named: "mic_icon_dark")
        }
    }
    
    @objc func SelectCameraImage() {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func StartVoiceRecognizer() {
        
    }

    @IBAction func SaveButtonClick(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MyNotes", into: context)
        
        
        if captionText.text != "" {
            if let caption = captionText.text {
                if let comment = commentText.text {
                    if let image = cameraImageView.image?.jpegData(compressionQuality: 0.5) as? Data{
                        entity.setValue(image, forKey: "image")
                    }
                    entity.setValue(caption, forKey: "caption")
                    entity.setValue(comment, forKey: "comment")
                    entity.setValue(UUID(), forKey: "id")
                    
                    do {
                        try context.save()
                        print("Success")

                    } catch {
                        print("Error")
                    }
                }
            }
            
        } else {
            ShowAlert(title: "Error", subTitle: "Caption is not be empty")
        }
        
        
        
        
        
        
    }
    
    
    @IBAction func btnUpdateClick(_ sender: Any) {
        
        
    }
    
    
    func ShowAlert(title: String, subTitle: String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
}

//
//  DetailViewController.swift
//  MyClipboard
//
//  Created by Muhammet Gürbüz on 7.05.2020.
//  Copyright © 2020 Muhammet Gürbüz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var choosenNoteId: String?
    var choosenNoteName: String?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var captionText: UITextField!
    @IBOutlet weak var commnetText: UITextView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var voiceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        SelectMode()
        
        let cameraGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectCameraImage))
        cameraImageView.addGestureRecognizer(cameraGestureRecognizer)
        
        let voiceGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartVoiceRecognizer))
        voiceImageView.addGestureRecognizer(voiceGestureRecognizer)
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

}

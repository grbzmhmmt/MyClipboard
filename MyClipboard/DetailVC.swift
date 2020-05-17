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

class DetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(ShareNoteClick))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(BackButtonClicked))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        
        let cameraGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectCameraImage))
        cameraImageView.addGestureRecognizer(cameraGestureRecognizer)
        
        let voiceGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StartVoiceRecognizer))
        voiceImageView.addGestureRecognizer(voiceGestureRecognizer)
        
        if NotesModule.instanceClone.noteCaption == "" {
            btnUpdate.isHidden = true
        } else{
            btnSave.isHidden = true
            GetData()
            
        }
        
    }
    
    @objc func ShareNoteClick() {
        print("Share Icon Clicked")
    }
    
    @objc func BackButtonClicked() {
        performSegue(withIdentifier: "toNotesVC", sender: nil)
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
                        performSegue(withIdentifier: "toNotesVC", sender: nil)
                    } catch {
                        print("Error")
                    }
                }
            }
            
        } else {
            ShowAlert(title: "Error", subTitle: "Caption is not be empty")
        }
    }
    
    func GetData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSFetchRequest<NSFetchRequestResult>(entityName: "MyNotes")
        entity.predicate = NSPredicate(format: "id = %@", NotesModule.instanceClone.noteId)
        
        do {
            let results = try context.fetch(entity)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    captionText.text = NotesModule.instanceClone.noteCaption
                    
                    if let comment = result.value(forKey: "comment") as? String {
                        commentText.text = comment
                    }
                    if let imageData = result.value(forKey: "image") as? Data {
                        cameraImageView.image = UIImage(data: imageData)
                    }
                }
            }
            
        } catch {
            print("Error data dont fetch")
        }
    }
    
    
    @IBAction func btnUpdateClick(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSFetchRequest<NSFetchRequestResult>(entityName: "MyNotes")
        entity.predicate = NSPredicate(format: "id = %@", NotesModule.instanceClone.noteId)
        
        do {
            let results = try context.fetch(entity)
            if results.count > 0 {
                let result = results[0] as! NSManagedObject
                
                if captionText.text != "" {
                    if let caption = captionText.text {
                        if let comment = commentText.text {
                            
                            result.setValue(caption, forKey: "caption")
                            result.setValue(comment, forKey: "comment")
                            if let image = cameraImageView.image?.jpegData(compressionQuality: 0.5) as? Data{
                                result.setValue(image, forKey: "image")
                            }
                            do {
                                try context.save()
                                print("Success")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
                                navigationController?.popViewController(animated: true)
                            } catch {
                                print("Error")
                            }
                        }
                    }
                } else {
                    ShowAlert(title: "Error", subTitle: "Caption is not be empty")
                }
            }
        } catch {
            print("Error")
        }
        
        
        
    }
    
    
    func ShowAlert(title: String, subTitle: String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
}

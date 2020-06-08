//
//  ViewController.swift
//  MyClipboard
//
//  Created by Muhammet Gürbüz on 7.05.2020.
//  Copyright © 2020 Muhammet Gürbüz. All rights reserved.
//

import UIKit
import CoreData

class NotesVC: UIViewController, UIGestureRecognizerDelegate, NotesTableViewCellDelegate {
/*
    func PlayShowAlert(time: Int, title: String, subtitle: String) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
 
 */
    //Todo! Yapılacaklar
    /*
     Cell View Update edilecek
     CameraImage view gesturerecognizer eklenecek
     Voice eklenecek
     Alternatif uygulamalar incelenecek
    
    
    */
    var noteCaptionArr = [String]()
    var noteIdArr = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Clipboard App"
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(AddNewNote))
        
        tableView.delegate = self
        tableView.dataSource = self
                
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 2 // 2 second press
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateTableData), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
        GetData()
    }
    
    @objc func UpdateTableData() {
        GetData()
    }
    

    @objc func AddNewNote() {
        NotesModule.instanceClone.noteCaption = ""
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destinationVC = segue.destination as? DetailVC {
                
            }
            
        }
    }
    
    func GetData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSFetchRequest<NSFetchRequestResult>(entityName: "MyNotes")
        
        do {
            let results = try context.fetch(entity)
            
            if results.count > 0 {
                noteIdArr.removeAll(keepingCapacity: false)
                noteCaptionArr.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject]{
                    if let caption = result.value(forKey: "caption") as? String{
                        noteCaptionArr.append(caption)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        noteIdArr.append(id.uuidString)
                    }
                }
                tableView.reloadData()
            }
        } catch {
            print("Error Datas Cnat Fetching")
        }
    }
    
    func GetDataComment() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSFetchRequest<NSFetchRequestResult>(entityName: "MyNotes")
        entity.predicate = NSPredicate(format: "id = %@", NotesModule.instanceClone.noteId)
        
        do {
            let results = try context.fetch(entity)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        if id.uuidString == NotesModule.instanceClone.noteId {
                            if let comment = result.value(forKey: "comment") as? String{
                                return comment
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error Datas Cnat Fetching")
        }
        return "Data Cant find! Please try again!"
    }

}

extension NotesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteCaptionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotesTableViewCell
        cell.alertDelegate = self
        //let cell = UITableViewCell()
        cell.noteId = noteIdArr[indexPath.row]
        cell.noteNameLabel.text = noteCaptionArr[indexPath.row]
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotesModule.instanceClone.noteCaption = noteCaptionArr[indexPath.row]
        NotesModule.instanceClone.noteId = noteIdArr[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
          if gestureRecognizer.state == .began {
              let touchPoint = gestureRecognizer.location(in: tableView)
              if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                  
                  var selectedRow = Int(indexPath[1])
                  
                  print("noteCaptionArr", noteCaptionArr.count)
                  print("noteIdArr", noteIdArr.count)
                  
                  NotesModule.instanceClone.noteId = noteIdArr[selectedRow]
                  NotesModule.instanceClone.noteCaption = noteCaptionArr[selectedRow]
                  
                  let selectedItemCommentText = GetDataComment()
                  
                  // set up activity view controller
                  let textToShare = [ selectedItemCommentText ]
                  let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                  activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

                  // exclude some activity types from the list (optional)
                  activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

                  // present the view controller
                  self.present(activityViewController, animated: true, completion: nil)

              }
          }
      }
    
    func ShowAlertWithTime() {
        
    }
    
    
}



/*
 
 
 
 @IBAction func shareTextButton(_ sender: UIButton) {

     // text to share
     let text = "This is some text that I want to share."

     // set up activity view controller
     let textToShare = [ text ]
     let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
     activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

     // exclude some activity types from the list (optional)
     activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

     // present the view controller
     self.present(activityViewController, animated: true, completion: nil)

 }

 // share image
 @IBAction func shareImageButton(_ sender: UIButton) {

     // image to share
     let image = UIImage(named: "Image")

     // set up activity view controller
     let imageToShare = [ image! ]
     let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
     activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

     // exclude some activity types from the list (optional)
     activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]

     // present the view controller
     self.present(activityViewController, animated: true, completion: nil)
 }
 
 
 */


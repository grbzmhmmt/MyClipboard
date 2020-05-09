//
//  ViewController.swift
//  MyClipboard
//
//  Created by Muhammet Gürbüz on 7.05.2020.
//  Copyright © 2020 Muhammet Gürbüz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var noteCaptionArr = [String]()
    var noteIdArr = [String]()
    var selectedNoteId: String?
    var selectedNoteName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(AddNewNote))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        GetData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateTableData), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
    
    @objc func UpdateTableData() {
        GetData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteCaptionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = noteCaptionArr[indexPath.row]
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedNoteName = noteCaptionArr[indexPath.row]
        selectedNoteId = noteIdArr[indexPath.row]
        performSegue(withIdentifier: "toDetailVC", sender: nil)
        
    }
    
    @objc func AddNewNote() {
        selectedNoteName = ""
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.choosenNoteId = selectedNoteId
                destinationVC.choosenNoteName = selectedNoteName
                
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

}


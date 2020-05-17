//
//  NotesTableViewCell.swift
//  MyClipboard
//
//  Created by Muhammet Gürbüz on 15.05.2020.
//  Copyright © 2020 Muhammet Gürbüz. All rights reserved.
//

import UIKit
import CoreData

protocol NotesTableViewCellDelegate {
    func PlayShowAlert(time: Int, title: String, subtitle: String)
}


class NotesTableViewCell: UITableViewCell {
    var alertDelegate: NotesTableViewCellDelegate?
    
    var noteId = ""
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var copyImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        copyImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CopyComment))
        copyImageView.addGestureRecognizer(gestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc func CopyComment() {
        
        
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        let entity = NSFetchRequest<NSFetchRequestResult>(entityName: "MyNotes")
        entity.predicate = NSPredicate(format: "id = %@", noteId)
        
        do {
            let results = try context.fetch(entity)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let commentText = result.value(forKey: "comment") as? String {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = commentText
                        
                        alertDelegate?.PlayShowAlert(time: 2, title: "Success", subtitle: "Coppied")
                    }
                    
                }
            }
            
        } catch {
            print("Error")
        }
        
        
        
        print(noteId, noteNameLabel.text, "mumi")
    }
    
    

}


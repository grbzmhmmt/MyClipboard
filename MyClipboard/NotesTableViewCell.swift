//
//  NotesTableViewCell.swift
//  MyClipboard
//
//  Created by Muhammet Gürbüz on 15.05.2020.
//  Copyright © 2020 Muhammet Gürbüz. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

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
        print(noteId, noteNameLabel.text, "mumi")
    }

}

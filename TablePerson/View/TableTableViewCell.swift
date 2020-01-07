//
//  TableTableViewCell.swift
//  TablePerson
//
//  Created by Филипп on 10/19/19.
//  Copyright © 2019 Filipp. All rights reserved.
//

import UIKit

class TableTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCell: UIImageView! {
        didSet {
            imageViewCell.layer.cornerRadius = imageViewCell.frame.size.height / 2
            imageViewCell.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var surnameName: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!


}

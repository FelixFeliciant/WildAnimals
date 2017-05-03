//
//  AnimalCell.swift
//  Wild Animals
//
//  Created by Felix Feliciant on 4/30/17.
//  Copyright © 2017 FelixFeliciant. All rights reserved.
//

import UIKit

class AnimalCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var info: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

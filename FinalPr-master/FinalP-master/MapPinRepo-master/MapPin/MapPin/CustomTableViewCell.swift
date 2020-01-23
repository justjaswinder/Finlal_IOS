//
//  CustomTableViewCell.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-20.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var genderTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var birthTxt: UITextField!
     @IBOutlet weak var countryTxt: UITextField!
    
    @IBOutlet weak var latText: UITextField!
    
    @IBOutlet weak var longTxt: UITextField!
    @IBOutlet weak var imgv: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

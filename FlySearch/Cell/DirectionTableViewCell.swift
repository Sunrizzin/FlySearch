//
//  DirectionTableViewCell.swift
//  FlySearch
//
//  Created by Aleksey Usanov on 30.04.2020.
//  Copyright © 2020 Aleksey Usanov. All rights reserved.
//

import UIKit

class DirectionTableViewCell: UITableViewCell {

   
    @IBOutlet weak var startCityLabel: UILabel!
    @IBOutlet weak var startCountryLabel: UILabel!
    @IBOutlet weak var stopCountryLabel: UILabel!
    @IBOutlet weak var stopCityLabel: UILabel!
    @IBOutlet weak var startIATALabel: UILabel!
    @IBOutlet weak var stopIATALabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

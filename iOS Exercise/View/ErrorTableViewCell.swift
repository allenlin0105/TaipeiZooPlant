//
//  ErrorTableViewCell.swift
//  iOS Exercise
//
//  Created by allen on 2022/2/16.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {

    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

//
//  ContentTableViewCell.swift
//  iOS Exercise
//
//  Created by 林承濬 on 2022/1/14.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantLocation: UILabel!
    @IBOutlet weak var plantFeature: UILabel!
    @IBOutlet weak var innerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.plantImage.contentMode = .top
        self.plantImage.clipsToBounds = true
        
        innerStackView.setCustomSpacing(0, after: plantLocation)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

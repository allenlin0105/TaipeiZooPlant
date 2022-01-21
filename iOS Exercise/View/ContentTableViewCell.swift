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
        innerStackView.setCustomSpacing(0, after: plantLocation)
    }
    
    func bind(data: PlantData) {
        plantName.text = data.name
        plantLocation.text = data.location
        plantFeature.text = data.feature
        plantImage.image = data.image?.resizeTopAlignedToFill(newWidth: 100) ?? nil
    }
}

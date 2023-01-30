//
//  NasaTableViewCell.swift
//  NASA
//
//  Created by Nuntapat Hirunnattee on 27/1/2566 BE.
//

import UIKit

class NasaTableViewCell: UITableViewCell {

    @IBOutlet weak var APODCellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  DocumentsTableViewCell.swift
//  Documents
//
//  Created by Brady Webb on 8/30/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

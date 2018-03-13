//
//  DetailSeriesTableViewCell.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 12/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class DetailSeriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var detailOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

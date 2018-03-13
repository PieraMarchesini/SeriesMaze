//
//  TesteTitleTableViewCell.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 13/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class DetailTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    var serie: Series? {
        didSet {
            self.title.text = serie?.show.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

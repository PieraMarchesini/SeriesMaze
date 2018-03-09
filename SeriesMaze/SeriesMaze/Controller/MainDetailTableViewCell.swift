//
//  MainDetailedTableViewCell.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 08/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class MainDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageDetailOutlet: UIImageView!
    @IBOutlet weak var nameDetailOutlet: UILabel!
    
    var serie: Serie? {
        didSet {
            guard let serie = serie else { return }
            self.nameDetailOutlet.text = serie.show.name
            guard let image = serie.show.image?.original else { return }
            self.imageDetailOutlet.downloadedFrom(link: image, contentMode: .scaleAspectFill)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

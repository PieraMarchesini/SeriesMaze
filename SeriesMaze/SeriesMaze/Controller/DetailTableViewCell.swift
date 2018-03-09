//
//  DetailTableViewCell.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 08/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDetailOutlet: UILabel!
    @IBOutlet weak var imageDetailOutlet: UIImageView!
    /*
    var detailedSerie: Serie? {
        didSet {
            var allGenres = ""
            if let serie = detailedSerie {
                for genre in serie.show.genres {
                    if genre != serie.show.genres.last {
                        allGenres += genre+", "
                    } else {
                        allGenres += genre
                    }
                }
                self.labelDetailOutlet.textAlignment = .right
                self.labelDetailOutlet.text = allGenres
                self.imageDetailOutlet.image = #imageLiteral(resourceName: "labelImg")
            }
        }
    }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

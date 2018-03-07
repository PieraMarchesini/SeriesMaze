//
//  SeriesTableViewCell.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 07/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class SeriesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameSerieOutlet: UILabel!
    @IBOutlet weak var genresSerieOutlet: UILabel!
    @IBOutlet weak var imageSerieOutlet: UIImageView!
    
    var serie: Serie? {
        didSet {
            guard let serie = serie else { return }
            var genres = ""
            self.nameSerieOutlet.text = serie.show.name
            for genre in serie.show.genres {
                if genre != serie.show.genres.last {
                    genres += genre+", "
                } else {
                    genres += genre
                }
            }
            self.genresSerieOutlet.text = genres
            if let image = serie.show.image?.medium {
                self.imageSerieOutlet.downloadedFrom(link: image)
            } else {
                self.imageSerieOutlet.image = UIImage()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

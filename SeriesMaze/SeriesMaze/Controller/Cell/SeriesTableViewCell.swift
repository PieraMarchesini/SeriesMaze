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
            self.nameSerieOutlet.text = serie.show.name
            let genres = Util.transform(list: serie.show.genres)
            if genres == "" {
                genresSerieOutlet.text = "There is no classified genre"
            } else {
                genresSerieOutlet.text = genres
            }
            if let image = serie.show.image?.medium {
                self.imageSerieOutlet.downloadedFrom(link: image)
            } else {
                self.imageSerieOutlet.image = #imageLiteral(resourceName: "noImageShort")
            }
        }
    }
}

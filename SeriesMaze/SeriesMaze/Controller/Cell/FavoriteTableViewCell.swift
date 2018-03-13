//
//  FavoriteTableViewCell.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 12/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var nameSerieOutlet: UILabel!
    @IBOutlet weak var genresSerieOutlet: UILabel!
    @IBOutlet weak var imageSerieOutlet: UIImageView!
    
    var serie: Series? {
        didSet {
            guard let serie = serie else { return }
            self.nameSerieOutlet.text = serie.show.name
            let genres = Util.transform(list: serie.show.genres)
            if genres == "" {
                genresSerieOutlet.text = "There is no classified genre"
            } else {
                genresSerieOutlet.text = genres
            }
            if let image = serie.show.image?.medium, image != "" {
                self.imageSerieOutlet.downloadedFrom(link: image)
            } else {
                self.imageSerieOutlet.image = #imageLiteral(resourceName: "noImageShort")
            }
        }
    }

}

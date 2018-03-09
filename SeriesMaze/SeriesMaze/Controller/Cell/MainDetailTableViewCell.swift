//
//  MainDetailedTableViewCell.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 08/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class MainDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var nameDetailOutlet: UILabel!
    
    var serie: Serie? {
        didSet {
            guard let serie = serie else { return }
            self.nameDetailOutlet.text = serie.show.name
        }
    }
}

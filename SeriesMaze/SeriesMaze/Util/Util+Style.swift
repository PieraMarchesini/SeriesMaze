//
//  Util.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 09/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class Util {
    class func transform(list: [String]) -> String {
        var word = ""
        for aWord in list {
            if aWord != list.last {
                word += aWord+", "
            } else {
                word += aWord
            }
        }
        return word
    }
}

struct Style {
    static let yellow = UIColor(red: 248/255, green: 215/255, blue: 1/255, alpha: 1)
    static let darkYellow = UIColor(red: 249/255, green: 204/255, blue: 2/255, alpha: 1)
    static let darkGray = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
    static let lightGray = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
}


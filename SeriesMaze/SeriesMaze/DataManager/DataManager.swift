//
//  JSONReader.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 07/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import Foundation

class DataManager {
    
    class func downloadJSON(search: String, completed: @escaping ([Serie]) -> ()) {
        let jsonUrlString = "https://api.tvmaze.com/search/shows?q="+search
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let series = try JSONDecoder().decode([Serie].self, from: data)
                DispatchQueue.main.sync {
                    completed(series)
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }
}
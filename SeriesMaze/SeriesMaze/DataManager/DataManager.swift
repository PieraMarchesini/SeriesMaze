//
//  JSONReader.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 07/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    class func downloadJSON(search: String, completed: @escaping ([Series]) -> ()) {
        let jsonUrlString = "https://api.tvmaze.com/search/shows?q="+search
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let series = try JSONDecoder().decode([Series].self, from: data)
                DispatchQueue.main.sync {
                    completed(series)
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }
    
    class func searchFavorite(id: Int) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Serie")
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
                request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
            }
            if result.count == 0 {
                return false
            } else {
                return true
            }
        } catch {
            print("Failed")
            return false
        }
    }
    
    class func searchFavorites() -> [Series] {
        var favSeries = [Serie]()
        var series = [Series]()
        do {
            favSeries = try context.fetch(Serie.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        for fav in favSeries {
            let serie = Series(score: 0, show: Series.Show(id: Int(fav.id), name: fav.name ?? "", genres: [fav.genres ?? ""], premiered: fav.premiered, image: Series.Image(medium: fav.imageMedium ?? "", original: fav.imageOriginal ?? ""), summary: fav.summary))
            series.append(serie)
        }
        return series
    }
    
    class func addFavorite(series: Series) {
        let favSerie = Serie(context: self.context)
        favSerie.id = Int32(series.show.id)
        favSerie.name = series.show.name
        favSerie.genres = Util.transform(list: series.show.genres)
        favSerie.premiered = Util.format(dateText: series.show.premiered ?? "")
        favSerie.summary = series.show.summary
        favSerie.imageMedium = series.show.image?.medium
        favSerie.imageOriginal = series.show.image?.original
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    class func deleteFavorite(id: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Serie")
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }
}

//
//  FavoriteSeriesTableViewController.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 12/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class FavoriteSeriesTableViewController: UITableViewController {
    var favoriteSeries = [Series]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK - Methods
    func reload() {
        self.favoriteSeries = DataManager.searchFavorites()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteSeries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        cell.serie = favoriteSeries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailTableView", sender: self)
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailSeriesTableViewController, let row = self.tableView.indexPathForSelectedRow?.row {
            destination.detailedSeries = favoriteSeries[row]
            destination.isFavorite = true
        }
     }
}

// MARK: - Swipe Actions
extension FavoriteSeriesTableViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfavorite = unfavoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [unfavorite])
    }
    
    func unfavoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Unfavorite") { (action, view, completion) in
            DataManager.deleteFavorite(id: self.favoriteSeries[indexPath.row].show.id)
            self.reload()
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "swipeUnfavoriteButton")
        action.backgroundColor = Style.yellow
        
        return action
    }
}

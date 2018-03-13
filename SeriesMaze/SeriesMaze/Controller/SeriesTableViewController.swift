//
//  SeriesTableViewController.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 06/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class SeriesTableViewController: UITableViewController {
    var series = [Series]()
    var searchedSeries = [Series]()
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reload()
    }
    
    // MARK: - Methods
    @objc
    func reload(){
        var text = "rick"
        if self.searchText != "" { text = self.searchText }
        DataManager.downloadJSON(search: text) { (results) in
            self.series = results
            self.tableView.reloadData()
        }
    }
    
    func searchInJSON(text: String) {
        self.searchText = Util.formatSearch(text: text)
        DataManager.downloadJSON(search: self.searchText) { (results) in
            self.searchedSeries = results
            self.tableView.reloadData()
        }
    }
    
    // MARK: - SearchBar
    func setUpNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search your favorites series"
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        guard let searchController = navigationItem.searchController else { return true }
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isSearching() -> Bool {
        guard let searchController = navigationItem.searchController else { return false }
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching(){
            return self.searchedSeries.count
        }
        return self.series.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "serieCell", for: indexPath) as? SeriesTableViewCell else { return UITableViewCell() }
        cell.serie = isSearching() ? searchedSeries[indexPath.row] : series[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailTableView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailSeriesTableViewController, let row = self.tableView.indexPathForSelectedRow?.row {
            destination.detailedSeries = isSearching() ? searchedSeries[row] : series[row]
        }
     }
}

// MARK: - Search Delegate
extension SeriesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text != "" {
            searchInJSON(text: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        reload()
    }
}

// MARK: - Swipe Actions
extension SeriesTableViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        let serie = isSearching() ? searchedSeries[indexPath.row] : series[indexPath.row]
        let isFavorite = DataManager.searchFavorite(id: serie.show.id)
        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completion) in
            if isFavorite {
                DataManager.deleteFavorite(id: serie.show.id)
            } else {
                DataManager.addFavorite(series: serie)
            }
            completion(true)
        }
        if isFavorite {
            action.title = "Unfavorite"
            action.image = #imageLiteral(resourceName: "swipeUnfavoriteButton")
        } else {
            action.image = #imageLiteral(resourceName: "swipeFavoriteButton")
        }
        action.backgroundColor = Style.yellow
        return action
    }
}

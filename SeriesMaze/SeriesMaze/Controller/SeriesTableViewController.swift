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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let refreshManager = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
//        setRefreshController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reload()
    }
    
    func setRefreshController(){
        self.tableView.refreshControl = refreshManager
        refreshManager.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        // Use attributes to change whatever you want of text in refrash label
//        let attributes = [NSAttributedStringKey.foregroundColor: Styles.darkGreen, NSAttributedStringKey.font : UIFont(name: Styles.champagneFont, size: 15)!]
//        refreshManager.attributedTitle = NSAttributedString(string: "Atualizando Lista", attributes: attributes)
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
    
    func searchInJSON(text: String) {
        var search = text.replacingOccurrences(of: " ", with: "+")
        if search.last == "+" {
            search.remove(at: search.index(before: search.endIndex))
        }
        self.searchText = search
        DataManager.downloadJSON(search: search) { (results) in
            self.searchedSeries = results
            self.tableView.reloadData()
        }
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
        self.performSegue(withIdentifier: "toDetailSerie", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailSerieTableViewController, let row = self.tableView.indexPathForSelectedRow?.row {
            destination.detailedSerie = isSearching() ? searchedSeries[row] : series[row]
        }
     }
}

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

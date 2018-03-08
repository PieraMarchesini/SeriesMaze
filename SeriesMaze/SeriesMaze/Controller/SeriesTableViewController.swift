//
//  SeriesTableViewController.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 06/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class SeriesTableViewController: UITableViewController {
    var series = [Serie]()
    var searchedSeries = [Serie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        JSONReader.shared.downloadJSON(search: "rick") { (results) in
            self.series = results
            self.tableView.reloadData()
        }
    }
    
    // MARK: - SearchBar
    func setUpNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search your favorites series"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func searchInJSON(text: String) {
        var search = text.replacingOccurrences(of: " ", with: "+")
        if search.last == "+" {
            search.remove(at: search.index(before: search.endIndex))
        }
        JSONReader.shared.downloadJSON(search: search) { (results) in
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
        if isSearching() {
            cell.serie = searchedSeries[indexPath.row]
        } else {
            cell.serie = series[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailedSerie", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailedSerieTableViewController, let row = self.tableView.indexPathForSelectedRow?.row {
            destination.detailedSerie = series[row]
        }
     }
}

extension SeriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text != "" {
            searchInJSON(text: text)
        }
    }
}

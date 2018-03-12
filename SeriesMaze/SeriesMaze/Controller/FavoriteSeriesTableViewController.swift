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
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(favoriteSeries)
    }
    
    func reloadData() {
        favoriteSeries = DataManager.searchFavorites()
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
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FavoriteSeriesTableViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfavorite = unfavoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [unfavorite])
    }
    
    func unfavoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Unfavorite") { (action, view, completion) in
            DataManager.deleteFavorite(id: self.favoriteSeries[indexPath.row].show.id)
            self.reloadData()
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "swipeUnfavoriteButton")
        action.backgroundColor = Style.yellow
        
        return action
    }
}

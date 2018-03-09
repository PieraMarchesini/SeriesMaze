//
//  DetailedSerieTableViewController.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 07/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class DetailSerieTableViewController: UITableViewController {
    
    var detailedSerie: Serie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Selected Serie"
        self.navigationItem.largeTitleDisplayMode = .never
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serie = detailedSerie else { return UITableViewCell() }
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainDetailCell", for: indexPath) as? MainDetailTableViewCell else { return UITableViewCell() }
            cell.serie = serie
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
            switch indexPath.row {
            case 1:
                var allGenres = ""
                for genre in serie.show.genres {
                    if genre != serie.show.genres.last {
                        allGenres += genre+", "
                    } else {
                        allGenres += genre
                    }
                }
                cell.imageDetailOutlet.image = #imageLiteral(resourceName: "labelImg")
                cell.labelDetailOutlet.text = allGenres
            case 2:
                cell.imageDetailOutlet.image = #imageLiteral(resourceName: "dateImg")
                cell.labelDetailOutlet.text = serie.show.premiered ?? "Premiered date is unknown"
            case 3:
                cell.imageDetailOutlet.image = #imageLiteral(resourceName: "summaryImg")
                cell.labelDetailOutlet.text = serie.show.summary ?? "Summary is unknown"
            default:
                break
            }
            cell.imageDetailOutlet.contentMode = .scaleAspectFit
//            cell.detailedSerie = serie
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 480
        case 3:
            return 100
        default:
            return 50
        }
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

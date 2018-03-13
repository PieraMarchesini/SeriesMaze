//
//  TesteTableViewController.swift
//  SeriesMaze
//
//  Created by Piera Marchesini on 13/03/18.
//  Copyright © 2018 Piera Marchesini. All rights reserved.
//

import UIKit

class DetailSeriesTableViewController: UITableViewController {

    @IBOutlet weak var favoriteButtonOutlet: UIBarButtonItem!
    var detailedSeries: Series?
    var isFavorite = false
    var headerView: DetailHeaderView!
    var headerMaskLayer: CAShapeLayer!
    
    private let tableHeaderViewHeight: CGFloat = 460.0
    private let tableHeaderViewCutaway: CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        //Deal with the Navigation Bar
        if let serie = detailedSeries {
            if DataManager.searchFavorite(id: serie.show.id){
                self.isFavorite = true
                self.favoriteButtonOutlet.image = #imageLiteral(resourceName: "favoriteButton")
            }
        }
        self.navigationItem.largeTitleDisplayMode = .never
        
        //Set up the stretchy header effect
        if let headerView = tableView.tableHeaderView as? DetailHeaderView {
            self.headerView = headerView
            if let image = self.detailedSeries?.show.image?.original {
                headerView.imageView.downloadedFrom(link: image)
            } else {
                headerView.imageView.image = #imageLiteral(resourceName: "noImage")
            }
            tableView.tableHeaderView = nil
            tableView.addSubview(headerView)
            
            tableView.contentInset = UIEdgeInsets(top: tableHeaderViewHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderViewHeight + 64)
            //Cut away header view
            self.headerMaskLayer = CAShapeLayer()
            self.headerMaskLayer.fillColor = UIColor.black.cgColor
            self.headerView.layer.mask = self.headerMaskLayer
            
            let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2.5
            tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
            tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
            
            updateHeaderView()
        }
    }
    
    // MARK: - Stretchy header effect
    func updateHeaderView() {
        let effectiveHeight = tableHeaderViewHeight - tableHeaderViewCutaway/2.5
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderViewHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderViewCutaway/2.5
        }
        self.headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height-self.tableHeaderViewCutaway))
        
        self.headerMaskLayer?.path = path.cgPath
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let series = self.detailedSeries else { return UITableViewCell() }
        if indexPath.row == 0 {
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "testeTitleCell", for: indexPath) as? DetailTitleTableViewCell else { return UITableViewCell() }
            titleCell.serie = series
            return titleCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "testeCell", for: indexPath) as? DetailSeriesTableViewCell else { return UITableViewCell() }
            switch indexPath.row {
            case 1:
                cell.titleOutlet.text = "Genres"
                let genres = Util.transform(list: series.show.genres)
                if genres == "" {
                    cell.detailOutlet.text = "There is no classified genre"
                } else {
                    cell.detailOutlet.text = genres
                }
            case 2:
                cell.titleOutlet.text = "Premiered"
                if let premiered = series.show.premiered {
                    cell.detailOutlet.text = Util.format(dateText: premiered) ?? "Premiered date is unknown"
                } else {
                    cell.detailOutlet.text = "Premiered date is unknown"
                }
            case 3:
                cell.titleOutlet.text = "Summary"
                if let summary = series.show.summary {
                    cell.detailOutlet.attributedText = summary.htmlAttributed(size: 11)
                } else {
                    cell.detailOutlet.text = "Summary is unknown"
                }
            default:
                break
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: //Title
            return 58
        case 3: //Summary
            return 330
        default:
            return 64
        }
    }
 
    // MARK: - ScrollView method
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    // MARK: - Favorite Method
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        var title = ""
        var message = ""
        if self.isFavorite {
            title = "Unfavorite"
            message = "Do you want to remove this series from favorites?"
        } else {
            title = "Favorite"
            message = "Do you want to add this series to favorites?"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = Style.darkYellow
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            //Add/Remove from favorites
            if let serie = self.detailedSeries {
                if self.isFavorite {
                    DataManager.deleteFavorite(id: serie.show.id)
                    self.favoriteButtonOutlet.image = #imageLiteral(resourceName: "favoriteEditButton")
                    self.isFavorite = false
                } else {
                    DataManager.addFavorite(series: serie)
                    self.favoriteButtonOutlet.image = #imageLiteral(resourceName: "favoritedEditButton")
                    self.isFavorite = true
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    }
}

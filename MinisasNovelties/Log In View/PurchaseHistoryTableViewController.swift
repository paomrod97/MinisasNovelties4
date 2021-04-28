//
//  PurchaseHistoryTableViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/2/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class PurchaseHistoryTableViewController: UITableViewController {
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var itemArray: [Item] = []
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
        
    }

// MARK: - Table View Data Source * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }
    
//MARK: Load Items * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func loadItems() {
        
        downloadItems(MUser.currentUser()!.purchasedItemsIds) { (allItems) in
            
            self.itemArray = allItems
            print("We have \(allItems.count) purchased items")
            self.tableView.reloadData()
            
        }
        
    }
    
}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension PurchaseHistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        
        return NSAttributedString(string: "No hay articulos para mostrar")
        
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return UIImage(named: "empty-box")
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "Intente más tarde")
        
    }
    
}


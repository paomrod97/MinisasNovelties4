//
//  InventoryTableViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/20/21.
//

import UIKit
import EmptyDataSet_Swift

class InventoryTableViewController: UITableViewController {
    
    //MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
    //var category: Category?
    
    var item: Item?
        
    var itemArray: [Item] = []
    
    //var searchResults: [Item] = []
    
    //MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.tableView.reloadData()
            loadItems()
                        
            tableView.tableFooterView = UIView()
            
            //self.title = category?.name
            self.title = item?.name
            
//            tableView.emptyDataSetSource = self
//            tableView.emptyDataSetDelegate = self
            
            //print("we have selected", category?.name)
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false

            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            //self.tableView.reloadData()
            //if item != nil {
//                loadItems()
                
            //}
        }

    // MARK: - Table View Data Source * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return itemArray.count
            //return 0
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

            cell.generateCell(itemArray[indexPath.row])
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
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    //MARK: - Table View Delegate * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
        override func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)
            showItemView(itemArray[indexPath.row])
        }
        
        
    // MARK: - Navigation * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "categoryToInventorySeg" {

                let vc = segue.destination as! InventoryTableViewController
                vc.item = item!
            }
        }

        private func showItemView (_ item: Item) {

            let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
            itemVC.item = item
            self.navigationController?.pushViewController(itemVC, animated: true)
        }
        
        
    //MARK: - Load Items * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
            private func loadItems() {
                
                downloadAllItemsFromFirebase() { (allItems) in

//                    //print("We have \(allItems.count) items for this category")
                      self.itemArray = allItems
                      self.tableView.reloadData()
                        self.tableView.reloadData()
                    
                    
                }
            }

//MARK: - Handle Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
private func handleEdit(_ rowID: Int) {
        // EDIT CODE GOES HERE
        //itemArray[rowID].id
    
    let alert = UIAlertController(title: "Editar Artículo", message: "Seguro que deseas editar este artículo?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Si", style: .default, handler: {_ in
        
        self.showEditItemView()
        
    }))

    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

    self.present(alert, animated: true)
    
    }
    
private func handleDelete(_ rowID: Int) {
    
    let alert = UIAlertController(title: "Eliminar Artículo", message: "Seguro que deseas eliminar permanentemente el artículo?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: {_ in
                
            deleteItemInFirestore(self.itemArray[rowID].id)  { (error) in
               
            if error != nil {
                  
                print("Error updating inventory", error)
                //print("Error updating inventory", error.localizedDescription)
                            
                }
            }
            
            print(self.itemArray[rowID].id!)
            
            self.itemArray.remove(at: rowID)
            
            self.tableView.reloadData()


        }))
    
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    
    }
    
    private func showEditItemView() {
        
        let editItemView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "editItemView")
        
        self.present(editItemView, animated: true, completion: nil)
        
    }
    
//MARK: - Delegate Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    
    //EDIT
//override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let action = UIContextualAction(style: .normal, title: "Edit", handler: {
//            [weak self] (action, view, completionHandler) in
//
//            self?.editSlide(indexPath.row)
//            completionHandler(true)
//        })
//
//        action.backgroundColor = .systemBlue
//
//        return UISwipeActionsConfiguration(actions: [action])
//    }
    
    
    
override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    let edit = UIContextualAction(style: .normal, title: "Editar") {
        [weak self] (action, view, completionHandler) in
        
        self?.handleEdit(indexPath.row)
        completionHandler(true)
            }
    
    let delete = UIContextualAction(style: .normal, title: "Eliminar") {
        [weak self] (action, view, completionHandler) in
                    
        self?.handleDelete(indexPath.row)
        completionHandler(true)
            
        }
    
        edit.backgroundColor = .systemBlue

        delete.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])

        return configuration
    }
}

    //MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

//    extension ItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
//
//        func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//
//
//            return NSAttributedString(string: "No hay articulos para mostrar")
//
//        }
//
//        func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//
//            return UIImage(named: "empty-box")
//        }
//
//        func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//
//            return NSAttributedString(string: "Intente más tarde")
//        }

//}

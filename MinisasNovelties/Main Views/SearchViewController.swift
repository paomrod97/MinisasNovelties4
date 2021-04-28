//
//  SearchViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 4/5/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class SearchViewController: UIViewController {

//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchOptionsView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
//MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var searchResults: [Item] = []
    
    var activityIndicator: NVActivityIndicatorView?
        
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.329379946, green: 0.3294321001, blue: 0.3293685317, alpha: 1), padding: nil)
        
    }
    
//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    @IBAction func showSearchBarButtonPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        showSearchField()
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        if searchTextField.text != "" {
            
            searchInFirebase(forName: searchTextField.text!)
            
            emptyTexField()
            
            animateSearchOptionsIn()
            
            dismissKeyboard()
            
        }
        
    }
    
//MARK: - Search Database * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func searchInFirebase(forName: String) {
        
        showLoadingIndicator()
        
        searchAlgolia(searchString: forName) { (itemIds) in
            
            downloadItems(itemIds) { (allItems) in
                
                self.searchResults = allItems
                
                self.tableView.reloadData()
                
                self.hideLoadingIndicator()
                
            }
            
        }
        
    }
    
//MARK: - Helpers * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func emptyTexField() {
        
        searchTextField.text = ""
        
    }
    
    private func dismissKeyboard() {
        
        self.view.endEditing(false)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("typing")
        
        searchButtonOutlet.isEnabled = textField.text != ""
            
            if searchButtonOutlet.isEnabled {
                
                searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.1882352941, blue: 0.4509803922, alpha: 1)
                
            } else {
                
                disableSearchButton()
                
            }
        
    }
    
    private func disableSearchButton() {
        
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    private func showSearchField() {
        
        disableSearchButton()
        emptyTexField()
        animateSearchOptionsIn()
        
    }
    
//MARK: - Animations * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func animateSearchOptionsIn() {
        
        UIView.animate(withDuration: 0.5) {
            
            self.searchOptionsView.isHidden = !self.searchOptionsView.isHidden
        }
        
    }
    
//MARK: - Activity Indicator * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
        
        self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        
        }
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
            
        }
        
    }
    
    private func showItemView(withItem: Item){
        
        let itemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
        
    }
    
}



//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
                
        return cell
        
    }
    
//MARK: - UITable View Delegate * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemView(withItem: searchResults[indexPath.row])
        
    }
    
}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        
        return NSAttributedString(string: "No hay articulos para mostrar")
        
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return UIImage(named: "empty-box")
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "Intente más tarde")
        
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        
        return UIImage(named: "search")
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        
        return NSAttributedString(string: "Comenzar búsqueda")
        
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        
        showSearchField()
        
    }
}

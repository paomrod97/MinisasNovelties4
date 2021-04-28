//
//  BasketViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/29/21.
//  Copyright © 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import JGProgressHUD
import Stripe

class BasketViewController: UIViewController {
    
//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var basketTotalPriceLabel: UILabel!
    
    @IBOutlet weak var totalItemsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    
    @IBOutlet weak var basketSubtotal: UILabel!
    
    @IBOutlet weak var basketStateTax: UILabel!
   
    @IBOutlet weak var basketMunGeneralTax: UILabel!
    
    @IBOutlet weak var basketStripePaymentFee: UILabel!
    //MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds: [String] = []
    
    let hud = JGProgressHUD(style: .light)
    var totalPrice = 0.0
    var subtotal = 0.0
    var stateTax = 0.0
    var munGeneralTax = 0.0
    var stripePaymentFee = 0.0
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
               
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if MUser.currentUser() != nil {
            
            loadBasketFromFirestore()

        } else {
            
            self.updateTotalLabels(true)
            
        }
    }
    

//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

    @IBAction func checkOutButtonPressed(_ sender: Any) {
        
        
        if MUser.currentUser()!.onBoard {
                                
            showPaymentOptions()
            
        } else {
            
            self.showNotification(text: "Please complete your profile", isError: true)
            
        }
    }
    
//MARK: Download Basket * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func loadBasketFromFirestore () {
        
        downloadBasketFromFirestore(MUser.currentId()) { (basket) in
            
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems() {
        
        if basket != nil {
            
            downloadItems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
                
            }
        }
    }
    
//MARK: - Helper Functions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            
            
            
            totalItemsLabel.text = "0"
            basketTotalPriceLabel.text = returnBasketTotalPrice()
            basketSubtotal.text =
            returnBasketSubtotal()
            basketStateTax.text =
            returnBasketStateTax()
            basketMunGeneralTax.text =
            returnBasketMunGeneralTax()
            basketStripePaymentFee.text =
            returnBasketStripePaymentFee()
            
            
        } else {
            
            totalItemsLabel.text = "\(allItems.count)"
            basketTotalPriceLabel.text = returnBasketTotalPrice()
            basketSubtotal.text =
            returnBasketSubtotal()
            basketStateTax.text =
            returnBasketStateTax()
            basketMunGeneralTax.text =
            returnBasketMunGeneralTax()
            basketStripePaymentFee.text =
            returnBasketStripePaymentFee()
            
        }
        
        checkOutButtonStatusUpdate()
        
    }
    
    private func returnBasketSubtotal() -> String {

        var subtotal = 0.0

        for item in allItems {

            subtotal += item.price

        }

        return "Subtotal: " + convertToCurrency(subtotal)
    }

    private func returnBasketStateTax() -> String {

        var stateTax = 0.0

        for item in allItems {

            stateTax += item.price

        }

        stateTax = stateTax * 0.105

        return "Tax Estatal: " + convertToCurrency(stateTax)
    }

    private func returnBasketMunGeneralTax() -> String {

        var munGeneralTax = 0.0

        for item in allItems {

            munGeneralTax += item.price

        }

        munGeneralTax = munGeneralTax * 0.01

        return "Tax Municipal: " + convertToCurrency(munGeneralTax)
    }
    
    private func returnBasketStripePaymentFee() -> String {
    
        var stripePaymentFee = 0.0
        
        for item in allItems {
            
            stripePaymentFee += item.price
            
        }
        
        stripePaymentFee = (stripePaymentFee * 0.029) + 0.30
    
    
    return "Tarifa Pago Online: " + convertToCurrency(stripePaymentFee)
    
    }
    
    private func returnBasketTotalPrice() -> String  {
                            
        var stateTax = 0.0
        
        var munGeneralTax = 0.0
        
        var totalPrice = 0.0
        
        var stripePaymentFee = 0.0
        
        for item in allItems {
                    
            stateTax += item.price
            
            munGeneralTax += item.price
            
            totalPrice += item.price
            
            stripePaymentFee += item.price
            
        }
        
        stateTax = stateTax * 0.105
        
        munGeneralTax = munGeneralTax * 0.01
        
        stripePaymentFee = (stripePaymentFee * 0.029) + 0.30
        
        totalPrice = totalPrice + stateTax + munGeneralTax + stripePaymentFee
        
            return "Total: " + convertToCurrency(totalPrice)
            
        }
    
    private func emptyTheBasket() {
        
        purchasedItemIds.removeAll()
        
        allItems.removeAll()
        
        tableView.reloadData()
        
        basket!.itemIds = []
        
        updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket!.itemIds]) { (error) in
            
            if error != nil {
                
                print("Error updating basket ", error!.localizedDescription)
                
            }
            
            self.getBasketItems()
            
        }
        
    }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]) {
        
        if MUser.currentUser() != nil {
            
            let newItemIds = MUser.currentUser()!.purchasedItemsIds + itemIds
            
            updateCurrentUserInFirestore(withValues: [kPURCHASEDITEMSIDS: newItemIds]) { (error) in
                
                if error != nil {
                    
                    print("Error Adding Purchased Items", error!.localizedDescription)
                    
                }
            }
        }
        
    }
    
//MARK: Navigation * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func showItemView(withItem: Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
        
    }
    
//MARK: - Control checkOutButton * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func checkOutButtonStatusUpdate() {
        
        checkOutButtonOutlet.isEnabled = allItems.count > 0
        
        if checkOutButtonOutlet.isEnabled {
            
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.1882352941, blue: 0.4509803922, alpha: 1)
            
        } else {
            disableCheckOutButton()
        }
        
    }
    
    private func disableCheckOutButton() {
        
        checkOutButtonOutlet.isEnabled = false
        checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
    
    private func removeItemFromBasket(itemId: String) {
        
        for i in 0..<basket!.itemIds.count {
            
            if itemId == basket!.itemIds[i] {
                
                basket!.itemIds.remove(at: i)
                
                return
                
            }
            
        }
        
    }
    
    private func finishPayment(token: STPToken) {
                
        self.stateTax = 0.0
        
        self.munGeneralTax = 0.0
        
        self.stripePaymentFee = 0.0
        
        self.totalPrice = 0.0
            
        for item in allItems {
            
            purchasedItemIds.append(item.id)
                        
            self.stateTax += item.price
            
            self.munGeneralTax += item.price
            
            self.stripePaymentFee += item.price
            
            self.totalPrice += item.price
                        
        }
        
        self.stateTax = self.stateTax * 0.105
        
        self.munGeneralTax = self.munGeneralTax * 0.01
        
        self.stripePaymentFee = (self.stripePaymentFee * 0.029) + 0.30

        
        self.totalPrice = (self.totalPrice + self.stateTax + self.munGeneralTax + self.stripePaymentFee) * 100
                
        print(totalPrice)
        
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: Int(totalPrice)) { (error) in
            
            if error == nil {
                
                self.emptyTheBasket()
                self.addItemsToPurchaseHistory(self.purchasedItemIds)
                
                //show notification
                self.showNotification(text: "Pago Exitoso", isError: false)
                
            } else {
                
                self.showNotification(text: "Pago No Procesado", isError: true)
                print("Error", error!.localizedDescription)
                
            }
            
        }
        
    }
    
    private func showNotification(text: String, isError: Bool) {
        
        if isError {
            
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            
            
        } else {
            
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            
        }
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
        
    }
    
    private func showPaymentOptions() {
        
        let alertController = UIAlertController(title: "Opciones de pago", message: "Elija su opción de pago preferida", preferredStyle: .actionSheet)
        
        let cardAction2 = UIAlertAction(title: "Pagar en tienda", style: .default) { (action) in

            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CardInfoViewController

            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        let cardAction = UIAlertAction(title: "Pagar con tarjeta", style: .default) { (action) in
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "cardInfoVC") as! CardInfoViewController
            
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cardAction)
        alertController.addAction(cardAction2)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
  
}
//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }

//MARK: UITableView Delegate * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemId: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket!.itemIds]) { (error) in
                
                if error != nil {
                    print("Error updating the basket", error!.localizedDescription)
                }
                self.getBasketItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension BasketViewController: CardInfoViewControllerDelegate {
    
    func didClickDone(_ token: STPToken) {
        
        finishPayment(token: token)
    }
    
    func didClickCancel() {
        
        showNotification(text: "Pago Cancelado", isError: true)
    }
    
}




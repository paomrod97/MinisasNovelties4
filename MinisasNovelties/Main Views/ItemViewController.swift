//
//  ItemViewController.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/23/21.
//  Copyright © 2021 Paola Rodriguez. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {

//MARK: - IBOutlets * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var counterStepper: UIStepper!
    
    @IBOutlet weak var itemNumberLabel: UILabel!
    
    
    //MARK: - Variables * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .light)
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight: CGFloat = 196.0
    private let itemsPerRow: CGFloat = 1
    
//MARK: - View Lifecycle * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Item name is", item.name)
        
        setUpUI()
        downloadPictures()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToBasket"), style: .plain, target: self, action: #selector(self.addToBasketButtonPressed))]
        // Do any additional setup after loading the view.
    }
    
//MARK: - Download Pictures * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func downloadPictures() {
        
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                    
                }
            }
            
        }
    }
    
//MARK: - Setup UI * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func setUpUI(){
        
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
            //counterLabel.text = item.quantity
            itemNumberLabel.text = "Total en inventario: \(item.quantity!)"
        }
        
    }
    
//MARK: - IBActions * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc func addToBasketButtonPressed() {
                   
        if MUser.currentUser() != nil {
        
            downloadBasketFromFirestore(MUser.currentId()) { (basket) in
            if basket == nil {
            self.createNewBasket()
        } else {
            basket!.itemIds.append(self.item.id)
            self.updateBasket(basket: basket!, withValues: [kITEMIDS: basket!.itemIds])
                }
            }
            
        } else {
            
            showLogInView()
            
        }
}
    @IBAction func counterStepper(_ sender: Any) {
        
        self.counterLabel.text = "\(Int(counterStepper.value))"
    }
    
//MARK: - Add To basket * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        
     private func createNewBasket() {
            
            let newBasket = Basket()
            newBasket.id = UUID().uuidString
            newBasket.ownerId = MUser.currentId()
            newBasket.itemIds = [self.item.id]
            newBasket.clientQuantity = Int(counterLabel.text!)
            self.item.clientQuantity2 = Int(counterLabel.text!)
        
            saveBasketToFirestore(newBasket)
            
            self.hud.textLabel.text = "Added to basket!"
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
        
     private func updateBasket(basket: Basket, withValues: [String : Any]) {
            
          updateBasketInFirestore(basket, withValues: withValues) { (error) in
                
               if error != nil {
                
                    self.hud.textLabel.text = "Error: \(error!.localizedDescription)!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                print("error updating basket", error!.localizedDescription)
                    
                } else {
            
                    self.hud.textLabel.text = "Added to basket!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        }
    
//MARK: - Show Log In View * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    private func showLogInView() {
        
        let logInView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "logInView")
        
        self.present(logInView, animated: true, completion: nil)
        
    }
}


//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1: itemImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
            
        }
        
        
        return cell
    }
    
}

//MARK: - Extension * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let availableWidth = collectionView.frame.width - sectionInsets.left

        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> UIEdgeInsets{
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGFloat {
        
        return sectionInsets.left
    }
    
}

//
//  ImageCollectionViewCell.swift
//  MinisasNovelties
//
//  Created by Paola Rodriguez on 3/23/21.
//  Copyright @ 2021 Paola Rodriguez. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
//MARK: IBOutlet * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
        
    }
}

//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
  
  @IBOutlet weak var captionLabel: UILabel!

  var photo: Photo? {
    didSet {
      if let photo = photo {
        captionLabel.text = photo.caption
      }
    }
  }
}

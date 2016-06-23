//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by ernesto on 01/06/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
protocol PinterestLayoutDelegate {
  func collectionView(collectionView:UICollectionView, widthAtIndexPath indexPath:NSIndexPath) -> CGFloat
//  // 2. Method to ask the delegate for the height of the annotation text
//  func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat

}


class PinterestLayout: UICollectionViewLayout {
  //1. Pinterest Layout Delegate
  var delegate:PinterestLayoutDelegate!
  
  //2. Configurable properties
  var numberOfColumns = 2
  var cellPadding: CGFloat = 10.0
  
  //3. Array to keep a cache of attributes.
  private var cache = [UICollectionViewLayoutAttributes]()
  
  //4. Content height and size
  private var contentHeight:CGFloat  = 300
  private var contentWidth:CGFloat = 0
  
  override class func layoutAttributesClass() -> AnyClass {
    return UICollectionViewLayoutAttributes.self
  }
  
  override func prepareLayout() {
    // 1. Only calculate once
    if cache.isEmpty {
      
      // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
      let rowHeight = CGFloat(35)
      var yOffset = [CGFloat]()
      for row in 0 ..< 5 {
        yOffset.append(CGFloat(row) * CGFloat(rowHeight) )
      }
      var xOffset = [CGFloat](count: 5, repeatedValue: 0)
      let itemCount = collectionView!.numberOfItemsInSection(0)
      for batch in 0 ..< Int(itemCount + 5 / 5) {
        for i in 0 ..< 5 {
          if (batch * 5 + i < itemCount) {
            let indexPath = NSIndexPath(forItem: batch * 5 + i, inSection: 0)

            let width = cellPadding + delegate.collectionView(collectionView!, widthAtIndexPath: indexPath) + cellPadding
            let minXIndex = xOffset.enumerate().reduce(0) { (acc, ele) -> Int in
              return xOffset[acc] < ele.1 ? acc : ele.0
            }
            let frame = CGRect(x: xOffset[minXIndex], y: yOffset[minXIndex], width: width, height: rowHeight)
            xOffset[minXIndex] += CGFloat(width)
            let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentWidth = max(contentWidth, xOffset[minXIndex])
          }
        }
      }
    }
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Loop through the cache and look for items in the rect
    for attributes  in cache {
      if CGRectIntersectsRect(attributes.frame, rect ) {
        layoutAttributes.append(attributes)
      }
    }
    return layoutAttributes
  }
}



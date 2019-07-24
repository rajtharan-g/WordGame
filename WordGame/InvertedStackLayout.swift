//
//  InvertedStackLayout.swift
//  WordGame
//
//  Created by Rajtharan G on 24/07/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class InvertedStackLayout: UICollectionViewLayout {
    
    var cellSize: CGFloat = 0.0
    var numOfCells = 0
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = [UICollectionViewLayoutAttributes]()
        if let collectionView = self.collectionView {
            for section in 0 ..< collectionView.numberOfSections {
                if let numberOfSectionItems = numberOfItemsInSection(section) {
                    for item in 0 ..< numberOfSectionItems {
                        let indexPath = IndexPath(item: item, section: section)
                        let layoutAttr = layoutAttributesForItem(at: indexPath)
                        if let layoutAttr = layoutAttr {
                            layoutAttrs.append(layoutAttr)
                        }
                    }
                }
            }
        }
        
        return layoutAttrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let x = self.collectionView!.bounds.width - (cellSize * (CGFloat(indexPath.item % 5) + 1.0))
        let y = self.collectionView!.bounds.height - (cellSize * (CGFloat(indexPath.item / 5) + 1.0))
        print("x -> \(x) y -> \(y)")
        print("indexpath -> \(indexPath.item)")
        layoutAttr.frame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
        return layoutAttr
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int? {
        return numOfCells
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            cellSize = self.collectionView!.bounds.size.height / 5.0
            return CGSize(width: self.collectionView!.bounds.size.width / 5.0, height: self.collectionView!.bounds.size.height / 5.0)
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = self.collectionView?.bounds, oldBounds.width != newBounds.width || oldBounds.height != newBounds.height {
            return true
        }
        return false
    }

}

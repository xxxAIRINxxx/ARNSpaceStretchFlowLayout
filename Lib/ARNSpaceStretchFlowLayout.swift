//
//  ARNSpaceStretchFlowLayout.swift
//  ARNSpaceStretchFlowLayout
//
//  Created by xxxAIRINxxx on 2015/02/08.
//  Copyright (c) 2015 Airin. All rights reserved.
//

import UIKit

public class ARNSpaceStretchFlowLayout : UICollectionViewFlowLayout {
    
    public var scrollResistanceDenominator : CGFloat = 0.0
    
    public var overflowPadding : UIEdgeInsets {
        get {
            return self.contentOverflowPadding
        }
        set (overflowPadding) {
            self.contentOverflowPadding = overflowPadding
            self.bufferedContentInsets = overflowPadding
            self.bufferedContentInsets.top *= -1
            self.bufferedContentInsets.bottom *= -1
        }
    }
    
    var contentOverflowPadding : UIEdgeInsets = UIEdgeInsetsZero
    var bufferedContentInsets : UIEdgeInsets = UIEdgeInsetsZero
    var transformsNeedReset : Bool = false
    
    public override func collectionViewContentSize() -> CGSize {
        var contentSize = super.collectionViewContentSize()
        contentSize.height += self.contentOverflowPadding.top + self.contentOverflowPadding.bottom
        
        return contentSize
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var newRect = UIEdgeInsetsInsetRect(rect, self.bufferedContentInsets)
        
        var items = super.layoutAttributesForElementsInRect(newRect) as! [UICollectionViewLayoutAttributes]?
        
        if let _items = items {
            
            for item in _items {
                var center = item.center
                center.y += self.contentOverflowPadding.top
                item.center = center
            }
            
            let collectionViewHeight = super.collectionViewContentSize().height
            let topOffset = self.contentOverflowPadding.top
            let bottomOffset = collectionViewHeight - self.collectionView!.frame.size.height + self.contentOverflowPadding.top
            let yPosition = self.collectionView!.contentOffset.y
            
            if yPosition < topOffset {
                let stretchDelta = topOffset - yPosition
                
                for item in _items {
                    let distanceFromTop = item.center.y - self.contentOverflowPadding.top
                    let scrollResistance = distanceFromTop / self.scrollResistanceDenominator
                    item.transform = CGAffineTransformMakeTranslation(0, -stretchDelta + (stretchDelta * scrollResistance))
                }
                
                self.transformsNeedReset = true
                
            } else if yPosition > bottomOffset {
                let stretchDelta = yPosition - bottomOffset
                
                for item in _items {
                    let distanceFromBottom = collectionViewHeight + self.contentOverflowPadding.top - item.center.y
                    let scrollResistance = distanceFromBottom / self.scrollResistanceDenominator
                    item.transform = CGAffineTransformMakeTranslation(0, stretchDelta + (-stretchDelta * scrollResistance))
                }
                
                self.transformsNeedReset = true
                
            } else if self.transformsNeedReset == true {
                self.transformsNeedReset = false
                
                for item in _items {
                    item.transform = CGAffineTransformIdentity
                }
            }
        }
        
        return items
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
//
//  ARNSpaceStretchFlowLayout.swift
//  ARNSpaceStretchFlowLayout
//
//  Created by xxxAIRINxxx on 2015/02/08.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
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
    
    public override func collectionViewContentSize() -> CGSize {
        var contentSize = super.collectionViewContentSize()
        contentSize.height += self.contentOverflowPadding.top + self.contentOverflowPadding.bottom
        
        return contentSize
    }
    
    private var contentOverflowPadding : UIEdgeInsets = UIEdgeInsetsZero
    private var bufferedContentInsets : UIEdgeInsets = UIEdgeInsetsZero
    private var transformsNeedReset : Bool = false
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let newRect = UIEdgeInsetsInsetRect(rect, self.bufferedContentInsets)
        let att = super.layoutAttributesForElementsInRect(newRect)
        
        var attributes:[UICollectionViewLayoutAttributes] = []
        att?.forEach() { attributes.append($0.copy() as! UICollectionViewLayoutAttributes) }
        
        attributes.forEach(){ [unowned self] in
            var center = $0.center
            center.y += self.contentOverflowPadding.top
            $0.center = center
        }
        
        let collectionViewHeight = super.collectionViewContentSize().height
        let topOffset = self.contentOverflowPadding.top
        let bottomOffset = collectionViewHeight - self.collectionView!.frame.size.height + self.contentOverflowPadding.top
        let yPosition = self.collectionView!.contentOffset.y
        
        if yPosition < topOffset {
            let stretchDelta = topOffset - yPosition
            
            attributes.forEach(){ [unowned self] in
                let distanceFromTop = $0.center.y - self.contentOverflowPadding.top
                let scrollResistance = distanceFromTop / self.scrollResistanceDenominator
                $0.transform = CGAffineTransformMakeTranslation(0, -stretchDelta + (stretchDelta * scrollResistance))
            }
            
            self.transformsNeedReset = true
        } else if yPosition > bottomOffset {
            let stretchDelta = yPosition - bottomOffset
            
            attributes.forEach(){ [unowned self] in
                let distanceFromBottom = collectionViewHeight + self.contentOverflowPadding.top - $0.center.y
                let scrollResistance = distanceFromBottom / self.scrollResistanceDenominator
                $0.transform = CGAffineTransformMakeTranslation(0, stretchDelta + (-stretchDelta * scrollResistance))
            }
            
            self.transformsNeedReset = true
        } else if self.transformsNeedReset == true {
            self.transformsNeedReset = false
            
            attributes.forEach(){
                $0.transform = CGAffineTransformIdentity
            }
        }
        
        return attributes
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
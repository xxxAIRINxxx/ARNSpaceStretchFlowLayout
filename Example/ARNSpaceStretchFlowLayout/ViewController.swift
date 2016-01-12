//
//  ViewController.swift
//  ARNSpaceStretchFlowLayout
//
//  Created by xxxAIRINxxx on 2015/02/08.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView : UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout:ARNSpaceStretchFlowLayout = ARNSpaceStretchFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0.0, 5.0, 0.0)
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, 60)
        flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 64)
        flowLayout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 64)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollResistanceDenominator = 1000.0
        self.collectionView.collectionViewLayout = flowLayout
    }
    
}

extension ViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) 
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView:UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) 
            
            return headerView
        } else {
            let footerView:UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) 
            
            return footerView
        }
    }
}


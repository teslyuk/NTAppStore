//
//  AppsHorizontalController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 06/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppsHorizontalController: BaseListController {
    
    fileprivate let cellId = "AppHorizontalCell"
    fileprivate let topBottomPadding: CGFloat = 12
    fileprivate let lineSpacing: CGFloat = 10
    fileprivate let widthPadding: CGFloat = 48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    fileprivate func registerCells() {
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
    }
}

//MARK: - UICollectionViewDataSource
extension AppsHorizontalController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppsHorizontalController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - widthPadding
        let height = (view.frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 3
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: topBottomPadding, left: 16, bottom: topBottomPadding, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
}

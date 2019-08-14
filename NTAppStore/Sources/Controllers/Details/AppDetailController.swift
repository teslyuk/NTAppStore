//
//  AppDetailController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 11/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {
    
    fileprivate let appDetailId = "AppDetailCell"
    fileprivate let previewId = "PreviewCell"
    fileprivate let reviewId = "ReviewCell"
    fileprivate var app: AppSearchResult?
    fileprivate var reviews: Review?
    
    var appId: String! {
        didSet {
            let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: urlString) { [weak self] (result: SearchResult?, error) in
                self?.app = result?.results.first
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            
            let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/sortby=mostrecent/json?l=en&cc=us"
            Service.shared.fetchGenericJSONData(urlString: reviewsUrl) { [weak self] (reviews: Review?, error) in
                if let error = error {
                    print("Failed to fetch reviews: ", error)
                    return
                }
                self?.reviews = reviews
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        registerCells()
    }
    
    fileprivate func setupViews() {
        collectionView.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }
    
    fileprivate func registerCells() {
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: appDetailId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewId)
        collectionView.register(ReviewsCell.self, forCellWithReuseIdentifier: reviewId)
    }
}

//MARK: - UICollectionViewDataSource
extension AppDetailController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailId, for: indexPath) as! AppDetailCell
            cell.app = app
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewId, for: indexPath) as! PreviewCell
            cell.screenshotsController.app = app
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewId, for: indexPath) as! ReviewsCell
            cell.reviewsController.reviews = reviews
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 220
        
        switch indexPath.item {
        case 0:
            let currentCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            currentCell.app = app
            currentCell.layoutIfNeeded()
            
            let estimatedSize = currentCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            
            height = estimatedSize.height
        case 1:
            height = 500
        case 2:
            height = 220
        default:
            return .zero
        }
        
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}

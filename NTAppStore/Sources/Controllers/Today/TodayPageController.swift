//
//  TodayPageController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayPageController: BaseListController {
    
    fileprivate let items = [
        TodayItem(category: "THE DAILY LIST", title: "Test-Drive These CarPlay Apps", imageName: "garden", description: "", backgroundColor: .none, cellType: .multiple),
        TodayItem(category: "LIFE HACK", title: "Utilizing Your Time", imageName: "garden", description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .gardenCellColor, cellType: .single),
        TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", imageName: "holiday", description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: .holidayCellColor, cellType: .single)
    ]
    
    var startingFrame: CGRect?
    var todayFullscreenController: TodayFullscreenController!
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    static let cellSize: CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setupViews()
    }
    
    fileprivate func registerCells() {
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    fileprivate func setupViews() {
        navigationController?.navigationBar.isHidden = true
        collectionView.backgroundColor = #colorLiteral(red: 0.9254021049, green: 0.9255538583, blue: 0.9253697395, alpha: 1)
    }
    
    @objc func handleRemoveView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.todayFullscreenController.tableView.contentOffset = .zero

            guard let startingFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.todayFullscreenController.view.removeFromSuperview()
            self.todayFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
}

//MARK: - UICollectionViewDataSource
extension TodayPageController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = items[indexPath.item].cellType
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.rawValue, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension TodayPageController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let todayFullscreenController = TodayFullscreenController()
        let todayItem = items[indexPath.item]
        todayFullscreenController.todayItem = todayItem
        self.todayFullscreenController = todayFullscreenController
        self.collectionView.isUserInteractionEnabled = false
        guard let todayFullscreenView = todayFullscreenController.view else { return }
        todayFullscreenController.dismissHandler = {
            self.handleRemoveView()
        }
        
        todayFullscreenView.layer.cornerRadius = 16
        todayFullscreenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayFullscreenView)
        addChild(todayFullscreenController)
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
        
        topConstraint = todayFullscreenController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = todayFullscreenController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = todayFullscreenController.view.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = todayFullscreenController.view.heightAnchor.constraint(equalToConstant: startingFrame.height)

        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach { $0?.isActive = true }
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.todayFullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension TodayPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayPageController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}

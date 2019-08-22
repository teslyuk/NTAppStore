//
//  TodayFullscreenController.swift
//  NTAppStore
//
//  Created by Nikita Teslyuk on 16/08/2019.
//  Copyright © 2019 Tesnik. All rights reserved.
//

import UIKit

class TodayFullscreenController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }
    
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
}

//MARK: - UITableViewDataSource
extension TodayFullscreenController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = TodayHeaderCell()
            cell.todayCell.layer.cornerRadius = 0
            cell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            if let item = todayItem {
                cell.todayCell.todayItem = item
            }
            cell.clipsToBounds = true
            cell.todayCell.backgroundView = nil
            return cell
        case 1:
            let cell = TodayFullscreenDescriptionCell()
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - UITableViewDelegate
extension TodayFullscreenController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return TodayPageController.cellSize
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
}

//MARK: - Actions
extension TodayFullscreenController {
    @objc func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}

//MARK: - UIScrollViewDelegate
extension TodayFullscreenController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
}

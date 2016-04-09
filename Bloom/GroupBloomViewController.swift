//
//  GroupBloomViewController.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/9/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

private let ContentInset: CGFloat = 200
private let MaximumAlpha: CGFloat = 0.0
private let MinimumAlpha: CGFloat = 0.0

class GroupBloomViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bloomView: BloomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsetsMake(ContentInset, 0, 0, 0)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.bloomView.startBloom()
    }
}

extension GroupBloomViewController {
    
}

extension GroupBloomViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension GroupBloomViewController: UITableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let y = scrollView.contentOffset.y + ContentInset
//        var normalizedY = y / ContentInset
//        normalizedY = min(1, max(0, normalizedY))
//        scrollView.backgroundColor = UIColor(white: 1, alpha: normalizedY * (MaximumAlpha - MinimumAlpha) + MinimumAlpha)
    }
}
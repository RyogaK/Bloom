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
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.bloomView.startBloom()
    }
}

extension GroupBloomViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 30
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ContentInset
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

extension GroupBloomViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let label = UILabel()
        label.backgroundColor = Colors.primaryColor.colorWithAlphaComponent(0.7)
        label.textAlignment = .Center
        label.text = "17th April 2016"
        label.textColor = UIColor.whiteColor()
        return label
    }
}

extension GroupBloomViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

extension GroupBloomViewController {
    @IBAction func didTapActionButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ActionModal", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            viewController.modalPresentationStyle = .Custom
            viewController.transitioningDelegate = self
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
}

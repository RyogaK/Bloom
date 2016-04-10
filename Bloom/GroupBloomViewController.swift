//
//  GroupBloomViewController.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/9/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit
import SwiftTask

private let ContentInset: CGFloat = 200
private let MaximumAlpha: CGFloat = 0.0
private let MinimumAlpha: CGFloat = 0.0

class GroupBloomViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bloomView: BloomView!
    
    private var flowersFetchController: PagingAPIController<GroupBloomViewController>!
    private var originFlowers: [BloomAPI.OrganizationFlowersResponse.Send] = []
    private var groupedFlowers: [FlowerGroup] = []
    
    struct FlowerGroup {
        let date: NSTimeInterval
        var flowers: [BloomAPI.OrganizationFlowersResponse.Send]
    }
    
    private var object : AnyObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flowersFetchController = PagingAPIController(source: self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.bloomView.startBloom()
        
        self.object = self.flowersFetchController.reload()!.success { (response) in
            self.updateGroupedFlowers()
        }.failure { (error, isCancelled) in
            
        }
    }
}

extension GroupBloomViewController {
    func updateGroupedFlowers() {
        self.groupedFlowers.removeAll()
        let dates = NSMutableOrderedSet()
        for flower in originFlowers {
            let slicedDate = sliceDate(flower.sendDate)
            dates.addObject(slicedDate)
        }
        
        for date in dates {
            if let date = date as? NSTimeInterval {
                var flowerGroup = FlowerGroup(date: date, flowers: [])
                self.groupedFlowers.append(flowerGroup)
                
                for flower in originFlowers {
                    let slicedDate = sliceDate(flower.sendDate)
                    if slicedDate == flowerGroup.date {
                        flowerGroup.flowers.append(flower)
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func sliceDate(date: NSDate) -> NSTimeInterval {
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: date, options: [])!.timeIntervalSince1970
    }
}

extension GroupBloomViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupedFlowers.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return groupedFlowers[section].flowers.count
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

extension GroupBloomViewController: PagingAPISource {
    func callPagingAPI(beginId: Int?) -> Task<Void, BloomAPI.OrganizationFlowersResponse?, NSError> {
        let organizationId = AppDelegate.sharedDelegate().store.organization!.id
        return BloomAPI.organizationFlowers(organizationId, beginId: beginId)
    }
}

extension GroupBloomViewController {
    @IBAction func bloomPostedActionForSegus(segue: UIStoryboardSegue) {
        self.bloomView.addBloom()
    }
}



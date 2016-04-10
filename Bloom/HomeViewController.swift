//
//  HomeViewController.swift
//  Bloom
//
//  Created by Ryoga Kitagawa on 4/10/16.
//  Copyright © 2016 Givery. All rights reserved.
//

import UIKit

class HomeViewController: UIPageViewController {
    private lazy var myViewControllers: [UIViewController] = {
        [self.organizationFlowersViewController, self.personalFlowersViewController]
    }()
    private var organizationFlowersViewController = UIStoryboard(name: "GroupBloom", bundle: nil).instantiateInitialViewController()!
    private var personalFlowersViewController = UIStoryboard(name: "PersonalBloom", bundle: nil).instantiateInitialViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.setViewControllers([self.organizationFlowersViewController], direction: .Forward, animated: true, completion: nil)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController == self.personalFlowersViewController {
            return self.organizationFlowersViewController
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController == self.organizationFlowersViewController {
            return self.personalFlowersViewController
        }
        return nil
    }
}

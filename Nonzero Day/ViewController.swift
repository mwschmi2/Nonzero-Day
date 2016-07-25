//
//  ViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/19/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{

	
	
	var pageViewController : UIPageViewController?
	@IBOutlet weak var pageControl: UIPageControl!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
		pageViewController?.dataSource = self
		pageViewController?.delegate = self
		let startingViewController = viewControllerAtIndex(0)
		let viewControllers:[UIViewController] = [startingViewController!]
		pageViewController!.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
		pageViewController?.view.frame = CGRectMake(0,0, self.view!.frame.size.width, self.view!.frame.size.height)
		
		addChildViewController(pageViewController!)
		view.addSubview(pageViewController!.view)
		pageViewController?.didMoveToParentViewController(self)
		refreshPageControl(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// PageViewControllerDataSource functions
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		let index = (viewController as! PageContentController).pageIndex
		if index == 0 || index == NSNotFound {
			return nil
		}
		
		return viewControllerAtIndex(index - 1)
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		let index = (viewController as! PageContentController).pageIndex
		if index == objectiveData.count || index == NSNotFound {
			return nil
		}
		
		return viewControllerAtIndex(index + 1)
	}
	
	func viewControllerAtIndex(index : Int) -> UIViewController? {
		if index < 0 || index > objectiveData.count {
			return nil
		} else if index == objectiveData.count {
			let vc = storyboard?.instantiateViewControllerWithIdentifier("AddObjectiveViewController") as! AddObjectiveViewController
			vc.rootViewController = self
			return vc
		} else {
			let vc = storyboard?.instantiateViewControllerWithIdentifier("ObjectiveViewController") as! ObjectiveViewController
			vc.pageIndex = index
			vc.objective = objectiveData[index]
			
			return vc
			
		}
	}
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return objectiveData.count + 1
	}
	
	
	
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let vc = pageViewController.viewControllers!.last as! PageContentController
		self.refreshPageControl(vc.pageIndex)
		
	}
	func refreshPageControl(index : Int) {
		pageControl.currentPage = index
		pageControl.userInteractionEnabled = false
		pageControl.numberOfPages = objectiveData.count + 1
		pageControl.backgroundColor = UIColor.clearColor()
		view.bringSubviewToFront(pageControl)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}


}


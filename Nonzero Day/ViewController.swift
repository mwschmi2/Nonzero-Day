//
//  ViewController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 6/19/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{

	
	
	var pageViewController : UIPageViewController?
	@IBOutlet weak var pageControl: UIPageControl!
	
	var managedObjectContext : NSManagedObjectContext!
	var objectives : [Objective] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//get objectives
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		managedObjectContext = appDelegate.managedObjectContext
		refreshObjectives()
		
		//set up page controller
		pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
		pageViewController?.dataSource = self
		pageViewController?.delegate = self
		
		
		pageViewController?.view.frame = CGRectMake(0,0, self.view!.frame.size.width, self.view!.frame.size.height)
		addChildViewController(pageViewController!)
		view.addSubview(pageViewController!.view)
		pageViewController?.didMoveToParentViewController(self)
		setupPageController(0, forward: true)
		
		
    }
	
	
	func refreshObjectives() {
		let fetchRequest = NSFetchRequest(entityName: "Objective")

		let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		do {
			objectives = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Objective]
		} catch {
			print("cannot get objectives")
		}
		
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
		if index == objectives.count || index == NSNotFound {
			return nil
		}
		
		return viewControllerAtIndex(index + 1)
	}
	
	func viewControllerAtIndex(index : Int) -> PageContentController? {
		if index < 0 || index > objectives.count {
			return nil
		} else if index == objectives.count {
			let vc = storyboard?.instantiateViewControllerWithIdentifier("AddObjectiveViewController") as! AddObjectiveViewController
			vc.rootViewController = self
			vc.pageIndex = index
			return vc
		} else {
			let vc = storyboard?.instantiateViewControllerWithIdentifier("ObjectiveViewController") as! ObjectiveViewController
			vc.pageIndex = index
			print("Creating objectiveViewController with objective : " + objectives[index].title)
			vc.objective = objectives[index]
			vc.rootViewController = self
			
			return vc
			
		}
	}
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return objectives.count + 1
	}
	
	
	
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let vc = pageViewController.viewControllers!.last as! PageContentController
		self.refreshPageControl(vc.pageIndex)
		view.backgroundColor = vc.backgroundColor
		
		
	}
	func refreshPageControl(index : Int) {
		pageControl.currentPage = index
		pageControl.userInteractionEnabled = false
		pageControl.numberOfPages = objectives.count + 1
		pageControl.backgroundColor = UIColor.clearColor()
		view.bringSubviewToFront(pageControl)
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	func deleteObjective(objective : Objective) {
		let index = objectives.indexOf(objective)
		objectives.removeAtIndex(index!)
		print("Deleting at index: " + String(index!) + " objectives.count : " + String(objectives.count))
		managedObjectContext.deleteObject(objective)
		setupPageController(0, forward: true)
		
		
		do {
			try managedObjectContext.save()
		} catch {
			print("Could not delete")
		}
	}
	
	func setupPageController(index : Int, forward : Bool) {
		let startingViewController = viewControllerAtIndex(index)
		let viewControllers:[UIViewController] = [startingViewController!]
		if forward {
			pageViewController!.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
		} else {
			pageViewController!.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
		}
		
		view.backgroundColor = startingViewController!.backgroundColor

		refreshPageControl(index)
	}


}


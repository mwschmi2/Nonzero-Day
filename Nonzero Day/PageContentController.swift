//
//  PageContentController.swift
//  Nonzero Day
//
//  Created by Mark Schmidt on 7/24/16.
//  Copyright © 2016 Mark Schmidt. All rights reserved.
//

import UIKit

protocol PageContentController {
	var pageIndex : Int { get }
	var rootViewController : ViewController! { get }
}
//
//  ViewController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 31/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import AMTabView

class TabBarController: AMTabsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabsControllers()
    }
    
    private func setTabsControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "UINavigationController")
        //let profileController = storyboard.instantiateViewController(withIdentifier: "ProfileController")
        
        viewControllers = [
            homeViewController
            //profileController
        ]
    }
}

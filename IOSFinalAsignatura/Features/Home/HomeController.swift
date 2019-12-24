//
//  HomeController.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 24/12/2019.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Material

class HomeController: UIViewController {
    @IBOutlet weak var toolbar: Toolbar!
    @IBOutlet weak var contentView: UIImageView!
    @IBOutlet weak var button: FlatButton!
    @IBOutlet weak var bottomBar: Bar!
    @IBOutlet weak var card: Card!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareToolbar()
        /*prepareContentView()
         prepareButton()*/
        prepareBottomBar()
        prepareCard()
    }
}

extension HomeController {
    fileprivate func prepareToolbar() {
        toolbar.title = "UNO"
        toolbar.detail = "DOS"
    }
    
    /*fileprivate func prepareContentView() {
     
     }
     
     fileprivate func prepareButton() {
     
     }*/
    
    fileprivate func prepareBottomBar() {
        bottomBar.centerViews = [button]
    }
    
    fileprivate func prepareCard() {
        
        
        card.toolbar = toolbar
        card.contentView = contentView
        card.bottomBar = bottomBar
    }
}

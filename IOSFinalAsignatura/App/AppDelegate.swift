//
//  AppDelegate.swift
//  IOSFinalAsignatura
//
//  Created by Manuel Espeso Martin on 11/12/19.
//  Copyright © 2019 Manuel Espeso Martin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
//import Material
import AMTabView
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "show_spinner")
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        AMTabView.settings.ballColor = #colorLiteral(red: 0.8637872338, green: 0.2903639972, blue: 0.4775919318, alpha: 1)
        AMTabView.settings.tabColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        AMTabView.settings.selectedTabTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        AMTabView.settings.unSelectedTabTintColor = #colorLiteral(red: 0.8637872338, green: 0.2903639972, blue: 0.4775919318, alpha: 1)
        
        // Chnage the animation duration
        AMTabView.settings.animationDuration = 1
        
        GMSServices.provideAPIKey("AIzaSyANZ93XULMTaSF-_oPHkgGdPgxGVUtKKvs")
        GMSPlacesClient.provideAPIKey("AIzaSyANZ93XULMTaSF-_oPHkgGdPgxGVUtKKvs")
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(false, forKey: "show_spinner")
    }
}


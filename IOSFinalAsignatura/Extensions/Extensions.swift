//
//  Extensions.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 05/02/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit

extension UIViewController {
    //Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertAction.Style.default, handler: nil))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func setUpTableViewCell() -> UIView {
        let view = UIView()
        
        view.layer.borderWidth = 2.5
        view.layer.cornerRadius = 5
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.9
        view.layer.borderColor = UIColor(red: 0.7, green: 0.2, blue: 0.4, alpha: 1).cgColor
        
        return view
    }
}

//
//  GradientView.swift
//  IOSFinalAsignatura
//
//  Created by alvaro on 10/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var firstColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    
    @IBInspectable var secondColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var thirdColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var  layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    
    func updateView () {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor,secondColor.cgColor]
        
    }
    
    

}

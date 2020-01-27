//
//  FloatingActionButton.swift
//  IOSFinalAsignatura
//
//  Created by Manu Espeso on 27/01/2020.
//  Copyright © 2020 Manuel Espeso Martin. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButtonX {

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        UIView.animate(withDuration: 0.2, animations: {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
            } else {
                self.transform = .identity
            }
        })
        return super.beginTracking(touch, with: event)
    }
    
    /*override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
    }*/
}

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
                self.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.2666666667, blue: 0.4392156863, alpha: 1) /* C64470 */
            } else {
                self.transform = .identity
                self.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.2901960784, blue: 0.4784313725, alpha: 1) /* DC4A7A */
            }
        })
        return super.beginTracking(touch, with: event)
    }
    
    /*override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
    }*/
}

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
                self.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.1215686275, blue: 0.6352941176, alpha: 1) /* C64470 */
            } else {
                self.transform = .identity
                self.backgroundColor = #colorLiteral(red: 0.6117647059, green: 0.1529411765, blue: 0.6901960784, alpha: 1) /* DC4A7A */
            }
        })
        return super.beginTracking(touch, with: event)
    }
}

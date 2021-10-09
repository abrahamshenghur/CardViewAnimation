//
//  UIView+Ext.swift
//  CardViewAnimation
//
//  Created by John on 8/5/21.
//  Copyright © 2021 Brian Advent. All rights reserved.
//

import UIKit

extension UIView {
    func captureScreen() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0);
        
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func screenShot() -> UIImage? {
        let scale = UIScreen.main.scale
        let bounds = self.bounds
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        
        if let _ = UIGraphicsGetCurrentContext() {
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return screenshot
        }
        
        return nil
    }
}

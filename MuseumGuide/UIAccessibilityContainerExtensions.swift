//
//  UIAccessibilityContainerExtensions.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 26/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeAccessibleUsingImageAccessibility(accessibility: ImageAccessibility) {
        isAccessibilityElement = false
        
        let imageElement = UIAccessibilityElement(accessibilityContainer: self)
        imageElement.isAccessibilityElement = true
        imageElement.accessibilityLabel = accessibility.imageAccessibilityLabel
        imageElement.accessibilityFrame = bounds
        
        accessibilityElements = [imageElement] + accessibility.faces.map { face in
            let element = UIAccessibilityElement(accessibilityContainer: self)
            element.isAccessibilityElement = true
            element.accessibilityLabel = "Face"
            element.accessibilityFrame = face.frame
            
            return element
        }
    }
    
}

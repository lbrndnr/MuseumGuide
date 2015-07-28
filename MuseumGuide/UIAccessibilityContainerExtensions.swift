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
        
        let initializeNewAccessibilityElement: ((String, CGRect) -> UIAccessibilityElement) = { label, frame in
            let element = UIAccessibilityElement(accessibilityContainer: self)
            element.isAccessibilityElement = true
            element.accessibilityLabel = label
            element.accessibilityFrame = frame
            
            return element
        }
        
        let imageElement = initializeNewAccessibilityElement(accessibility.imageAccessibilityLabel, bounds)
        accessibilityElements = [imageElement] + accessibility.faces.map { initializeNewAccessibilityElement("Face", $0.frame) }
    }
    
}

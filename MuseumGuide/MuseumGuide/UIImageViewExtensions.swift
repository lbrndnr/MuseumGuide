//
//  UIImageViewExtensions.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 18/08/15.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit

private let KVOContext = UnsafeMutablePointer<()>()

extension UIImageView {
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        let center = NSNotificationCenter.defaultCenter()
        let imageKeyPath = "image"
        
        if newSuperview != nil {
            center.addObserver(self, selector: "reloadAccessibility", name: UIAccessibilityVoiceOverStatusChanged, object: nil)
            
            let options = NSKeyValueObservingOptions(rawValue: 0)
            addObserver(self, forKeyPath: imageKeyPath, options: options, context: KVOContext)
            
            reloadAccessibility()
        }
        else {
            center.removeObserver(self, name: UIAccessibilityVoiceOverStatusChanged, object: nil)
            removeObserver(self, forKeyPath: imageKeyPath)
        }
    }
    
    // MARK: - Accessibility
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == KVOContext {
            reloadAccessibility()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    @objc private func reloadAccessibility() {
        if let image = image as? AccessibleImage {
            makeAccessibleUsingImageAccessibility(image.accessibility)
            
            var shouldLoadAdvancedAccessibility = UIAccessibilityIsVoiceOverRunning()
            #if DEBUG
                if NSProcessInfo.processInfo().environment["TEST_ACCESSIBILITY"] != nil {
                    shouldLoadAdvancedAccessibility = true
                }
            #endif
            
            if shouldLoadAdvancedAccessibility {
                image.loadAdvancedAccessibility {
                    self.makeAccessibleUsingImageAccessibility(image.accessibility)
                }
            }
        }
        else {
            isAccessibilityElement = true
            accessibilityElements = nil
        }
    }
    
}

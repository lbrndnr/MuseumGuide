//
//  UIImageViewExtensions.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 18/08/15.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit
import AVFoundation

private let KVOContext = UnsafeMutablePointer<()>()

extension UIImageView {
    
    var imageFrame: CGRect? {
        guard let image = image else {
            return nil
        }
        
        switch contentMode {
        default:
            return AVMakeRectWithAspectRatioInsideRect(image.size, bounds)
        }
    }
    
    // MARK: - View Hierarchy
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        let center = NSNotificationCenter.defaultCenter()
        let imageKeyPath = "image"
        
        if newSuperview != nil {
            center.addObserver(self, selector: "applyImageAccessibility", name: UIAccessibilityVoiceOverStatusChanged, object: nil)
            
            let options = NSKeyValueObservingOptions(rawValue: 0)
            addObserver(self, forKeyPath: imageKeyPath, options: options, context: KVOContext)
            
            reloadImageAccessibility()
        }
        else {
            center.removeObserver(self, name: UIAccessibilityVoiceOverStatusChanged, object: nil)
            removeObserver(self, forKeyPath: imageKeyPath)
        }
    }
    
    // MARK: - Accessibility
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == KVOContext {
            reloadImageAccessibility()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    @objc private func reloadImageAccessibility() {
        applyImageAccessibility()
        
        if let image = image as? AccessibleImage {
            var shouldLoadAdvancedAccessibility = UIAccessibilityIsVoiceOverRunning()
            #if DEBUG
                if NSProcessInfo.processInfo().environment["TEST_ACCESSIBILITY"] != nil {
                    shouldLoadAdvancedAccessibility = true
                }
            #endif
            
            if shouldLoadAdvancedAccessibility {
                image.loadAdvancedAccessibility {
                    self.applyImageAccessibility()
                }
            }
        }
    }
    
    private func applyImageAccessibility() {
        guard let image = image as? AccessibleImage,
          accessibility = image.accessibility,
             imageFrame = imageFrame else {
            isAccessibilityElement = true
            accessibilityElements = nil
            
            return
        }
        
        isAccessibilityElement = false
        
        let sx = imageFrame.width / image.size.width
        let sy = imageFrame.height / image.size.height
        let conversionTransform = CGAffineTransformMakeScale(sx, sy)
        
        let initializeNewAccessibilityElement: ((String, CGRect) -> UIAccessibilityElement) = { label, frame in
            let element = UIAccessibilityElement(accessibilityContainer: self)
            element.isAccessibilityElement = true
            element.accessibilityLabel = label
            element.accessibilityFrame = frame
            
            return element
        }
        
        let imageElement = initializeNewAccessibilityElement(accessibility.imageAccessibilityLabel, imageFrame)
        let faces = zip(accessibility.faces, accessibility.faceAccessibilityLabels)
        accessibilityElements = [imageElement] + faces.map { face, label in
            var frame = CGRectApplyAffineTransform(face.frame, conversionTransform)
            frame = CGRectOffset(frame, imageFrame.minX, imageFrame.minY)
            
            return initializeNewAccessibilityElement(label, frame)
        }
    }
    
}

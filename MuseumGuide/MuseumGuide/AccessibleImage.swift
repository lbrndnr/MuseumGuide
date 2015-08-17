//
//  AccessibleImage.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 24/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreImage
import ImageIO

public class AccessibleImage: UIImage {
    
    public private(set) var advancedAccessibilityLoaded = false
    
    private var _accessibility: ImageAccessibility!
    public private(set) var accessibility: ImageAccessibility! {
        get {
            var value: ImageAccessibility?
            dispatch_sync(accessorQueue) {
                value = self._accessibility
            }
            
            return value
        }
        set(value) {
            dispatch_sync(accessorQueue) {
                self._accessibility = value
            }
        }
    }
    
    let accessibilityLoadingGroup = dispatch_group_create()
    private let accessorQueue = dispatch_queue_create("AccessibleImageAccessorQueue", DISPATCH_QUEUE_SERIAL)
    
    // MARK: - Initialization
    
//    public init?(named name: String) {
//        super.init(named: name)
//        
//    }
    
//    @available(iOS 8.0, *)
//    public init?(named name: String, inBundle bundle: NSBundle?, compatibleWithTraitCollection traitCollection: UITraitCollection?) {
//        
//    }
    
    public override init?(contentsOfFile path: String) {
        super.init(contentsOfFile: path)
        
        let URL = NSURL(fileURLWithPath: path)
        accessibility = loadBasicAccessibilityWithSource(CGImageSourceCreateWithURL(URL, nil))
    }
    
    public override init?(data: NSData) {
        super.init(data: data)
        
        // TODO: Don't cache the source
        accessibility = loadBasicAccessibilityWithSource(CGImageSourceCreateWithData(data, nil))
    }
    
    @available(iOS 6.0, *)
    public override init?(data: NSData, scale: CGFloat) {
        super.init(data: data, scale: scale)
        
        // TODO: Don't cache the source
        accessibility = loadBasicAccessibilityWithSource(CGImageSourceCreateWithData(data, nil))
    }

    public required init?(imageLiteral name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Basic Accessibility
    
    private func loadBasicAccessibilityWithSource(source: CGImageSourceRef?) -> ImageAccessibility {
        let date = retrieveCreationDateFromSource(source)
        let portrait = size.width < size.height
        
        return ImageAccessibility(creationDate: date, portrait: portrait)
    }
    
    private func retrieveCreationDateFromSource(source: CGImageSourceRef?) -> String? {
        if let source = source,
            info = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as Dictionary?,
            exif = info[kCGImagePropertyExifDictionary] as? [String: AnyObject] {
            return exif[kCGImagePropertyExifDateTimeOriginal as String] as? String
        }
        
        return nil
    }
    
    // MARK: - Advanced Accessibility
    
    /// Loads more extensive accessibility of the image
    public func loadAdvancedAccessibility(completion: (() -> ())? = nil) {
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        
        if advancedAccessibilityLoaded {
            dispatch_group_notify(accessibilityLoadingGroup, dispatch_get_main_queue()) {
                completion?()
            }
        }
        else {
            dispatch_group_async(accessibilityLoadingGroup, backgroundQueue) {
                self.accessibility = self.loadAdvancedAccessibility(self.accessibility)
                completion?()
            }
        }
        
        self.advancedAccessibilityLoaded = true
    }
    
    private func loadAdvancedAccessibility(var basicAccessibility: ImageAccessibility) -> ImageAccessibility {
        basicAccessibility.faces = detectFaces()
        return basicAccessibility
    }

}

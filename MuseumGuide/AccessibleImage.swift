//
//  AccessibleImage.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 24/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit
import CoreImage
import ImageIO

public class AccessibleImage: UIImage {
    
    public private(set) var advancedAccessibilityLoaded = false
    public private(set) var accessibility: ImageAccessibility!
    
    // MARK: - Initialization
    
    public override init?(data: NSData) {
        super.init(data: data)
        
        // TODO: Don't cache the source
        accessibility = loadBasicAccessibilityWithSource(CGImageSourceCreateWithData(data, nil))
    }
    
    public override init?(contentsOfFile path: String) {
        super.init(contentsOfFile: path)
        
        let URL = NSURL(fileURLWithPath: path)
        accessibility = loadBasicAccessibilityWithSource(CGImageSourceCreateWithURL(URL, nil))
    }

    public required convenience init?(imageLiteral name: String) {
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
    public func loadAdvancedAccessibility(completion: dispatch_block_t? = nil) {
        if advancedAccessibilityLoaded {
            completion?()
        }
        else {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                let accessibility = self.loadAdvancedAccessibility(self.accessibility)
                dispatch_async(dispatch_get_main_queue()) {
                    self.advancedAccessibilityLoaded = true
                    self.accessibility = accessibility
                    completion?()
                }
            }
        }
    }
    
    private func loadAdvancedAccessibility(var basicAccessibility: ImageAccessibility) -> ImageAccessibility {
        basicAccessibility.faces = detectFaces()
        return basicAccessibility
    }

}

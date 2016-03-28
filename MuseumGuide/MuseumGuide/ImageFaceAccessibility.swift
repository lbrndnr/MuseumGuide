//
//  ImageFaceAccessibility.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 25/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import Foundation
import CoreImage

public struct ImageFaceAccessibility {
    
    public var frame: CGRect
    public var smiling: Bool
    public var blinking: Bool
    
    init(faceFeature: CIFaceFeature, transform: CGAffineTransform) {
        frame = CGRectApplyAffineTransform(faceFeature.bounds, transform)
        smiling = faceFeature.hasSmile
        blinking = faceFeature.leftEyeClosed || faceFeature.rightEyeClosed
    }
    
}

extension ImageFaceAccessibility: Hashable {
    
    public var hashValue: Int {
        return smiling.hashValue ^ blinking.hashValue;
    }
    
}

public func ==(lhs: ImageFaceAccessibility, rhs: ImageFaceAccessibility) -> Bool {
    return lhs.frame == rhs.frame &&
           lhs.smiling == rhs.smiling &&
           lhs.blinking == rhs.blinking
}

//
//  Face.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 25/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import Foundation
import CoreImage

public struct Face {
    
    public var frame: CGRect
    public var smiling: Bool
    public var blinking: Bool
    
    init(faceFeature: CIFaceFeature) {
        frame = faceFeature.bounds
        smiling = faceFeature.hasSmile
        blinking = faceFeature.leftEyeClosed || faceFeature.rightEyeClosed
    }
    
}

extension Face: Hashable {
    
    public var hashValue: Int {
        return Int(smiling) ^ Int(blinking)
    }
    
}

public func ==(lhs: Face, rhs: Face) -> Bool {
    return lhs.frame == rhs.frame &&
           lhs.smiling == rhs.smiling &&
           lhs.blinking == rhs.blinking
}

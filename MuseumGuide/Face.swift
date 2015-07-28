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
    
    var frame: CGRect
    var smiling: Bool
    var blinking: Bool
    
    init(faceFeature: CIFaceFeature) {
        frame = faceFeature.bounds
        smiling = faceFeature.hasSmile
        blinking = faceFeature.leftEyeClosed || faceFeature.rightEyeClosed
    }
    
}

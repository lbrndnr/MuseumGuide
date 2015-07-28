//
//  UIImageExtensions.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 26/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit

extension UIImage {
    
    func detectFaces() -> [Face] {
        guard let image = CoreImage.CIImage(image: self) else {
            return []
        }
        
        let options: [String : AnyObject] = [CIDetectorAccuracy: CIDetectorAccuracyLow,
                                             CIDetectorSmile: true,
                                             CIDetectorEyeBlink: true]
        
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)
        return detector.featuresInImage(image).flatMap { feature in
            return (feature as? CIFaceFeature).map { Face(faceFeature: $0) }
        }
    }
    
}

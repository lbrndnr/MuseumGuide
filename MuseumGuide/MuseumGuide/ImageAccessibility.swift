//
//  ImageAccessibility.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 26/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import Foundation

private let dateFormatter = NSDateFormatter()

public struct ImageAccessibility: Equatable {
    
    public var faces: [ImageFaceAccessibility]
    
    public var creationDate: NSDate?
    public var portrait: Bool
    
    // MARK: - Accessibility
    
    public var imageAccessibilityLabel: String {
        let imageLabel = NSLocalizedString("Photo", comment: "The photo label")
        let portraitLabel = (portrait) ? NSLocalizedString("Portrait", comment: "The orientation of the image") : NSLocalizedString("Landscape", comment: "The orientation of the image")
        
        let creationDateLabel = creationDate.map { accessibilityLabelDateFormatter.stringFromDate($0) }
        
        var facesLabel: String?
        if faces.count > 0 {
            facesLabel = String(format: NSLocalizedString("%d Faces", comment: "The number of faces label"), faces.count)
        }
        
        let labels = [imageLabel, portraitLabel, creationDateLabel, facesLabel].filter { $0 != nil }.map { $0! }.filter { $0.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 }
        return labels.joinWithSeparator(", ")
    }
    
    public var faceAccessibilityLabels: [String] {
        return faces.map { face in
            let faceLabel: String
            
            let index = faces.indexOf(face)
            if let index = index {
                faceLabel = String(format: NSLocalizedString("Face %d", comment: "The face label, indexed"), index+1)
            }
            else {
                faceLabel = NSLocalizedString("Face", comment: "The face label")
            }
            
            let blinkingLabel: String? = (face.blinking) ? NSLocalizedString("Blinking", comment: "Blinking") : nil
            let smilingLabel: String? = (face.smiling) ? NSLocalizedString("Smiling", comment: "Smiling") : nil
            
            let labels = [faceLabel, blinkingLabel, smilingLabel].filter { $0 != nil }.map { $0! }.filter { $0.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 }
            return labels.joinWithSeparator(", ")
        }
    }
    
    private var exifParsingDateFormatter: NSDateFormatter {
        dateFormatter.dateFormat = "yyyy:MM:dd' 'hh:mm:ss"
        return dateFormatter
    }
    
    private var accessibilityLabelDateFormatter: NSDateFormatter = {
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter
    }()
    
    // MARK: - Initialization
    
    init(creationDate creationDateString: String?, portrait: Bool) {
        self.faces = []
        self.portrait = portrait
        self.creationDate = creationDateString.flatMap { exifParsingDateFormatter.dateFromString($0) }
    }
    
}

public func ==(lhs: ImageAccessibility, rhs: ImageAccessibility) -> Bool {
    return lhs.faces == rhs.faces &&
           lhs.creationDate == rhs.creationDate &&
           lhs.portrait == rhs.portrait
}


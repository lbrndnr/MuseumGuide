//
//  MuseumGuideTests.swift
//  MuseumGuideTests
//
//  Created by Laurin Brandner on 23/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import XCTest
import Nimble
@testable import MuseumGuide

class MuseumGuideTests: XCTestCase {
    
    var imageView = AccessibleImageView(frame: UIScreen.mainScreen().bounds)

    let bundle = NSBundle(forClass: MuseumGuideTests.self)
    
    // Describes the input image, something along the following lines
    // Photo, portrait, July 15th, 18:32, one face, crisp, well light image
    // tapping on image -> face one: smiling/ blinking
    func testFaces() {
        let path = bundle.pathForResource("metronomy", ofType: "png")!
        let image = AccessibleImage(contentsOfFile: path)
        imageView.image = image
        
        for element in imageView.accessibilityElements! {
            if let element = element as? UIAccessibilityElement {
                print(element.accessibilityFrame)
            }
        }
    }
    
    // Photo, Landscape, October asdf, 12: 02, one face, crisp, very bright
    func testExplicitLoading() {
        let path = bundle.pathForResource("mø", ofType: "png")!
        let image = AccessibleImage(contentsOfFile: path)
        
        var accessibilityLabel: String?
        image?.loadAdvancedAccessibility {
            print(accessibilityLabel)
            accessibilityLabel = image?.accessibility.imageAccessibilityLabel
        }
        
        
        expect(accessibilityLabel).toEventually(equal(""))
    }
    
}

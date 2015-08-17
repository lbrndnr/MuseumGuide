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
    
    // MARK: - Utilities
    
    private func waitForAccessibleImageToLoad(image: AccessibleImage) {
        let timeout = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
        dispatch_group_wait(image.accessibilityLoadingGroup, timeout)
    }
    
    private func loadImageWithPath(path: String) -> AccessibleImage {
        let image = AccessibleImage(contentsOfFile: path)!
        
        image.loadAdvancedAccessibility()
        waitForAccessibleImageToLoad(image)
        imageView.image = image
        
        return image
    }
    
    // MARK: - Expectations
    
    private func expectBasicAccessibilityToBe(accessibility: ImageAccessibility, portrait: Bool, timestamp: NSTimeInterval) {
        expect(accessibility.portrait).to(equal(portrait))
        expect(accessibility.creationDate!.timeIntervalSince1970).to(equal(timestamp))
    }
    
    private func expectBlinkingAccessibilityToBe(accessibility: ImageAccessibility, blinking: [Bool]) {
        let imageBlinking = accessibility.faces
                                         .map { $0.blinking }
                                         .reduce([]) { memo, blinking in
                                             return memo + [blinking]
                                         }
        expect(blinking).to(equal(imageBlinking))
    }
    
    private func expectSmilingAccessibilityToBe(accessibility: ImageAccessibility, smiling: [Bool]) {
        let imageSmiling = accessibility.faces
                                        .map { $0.smiling }
                                        .reduce([]) { memo, blinking in
                                            return memo + [blinking]
                                        }
        expect(smiling).to(equal(imageSmiling))
    }
    
    // MARK: - Tests
    
    func testMetronomyPicture() {
        let image = loadImageWithPath(bundle.pathForResource("metronomy", ofType: "png")!)
        let accessibility = image.accessibility
        
        expectBasicAccessibilityToBe(accessibility, portrait: false, timestamp: 1385286452)
        
        expect(accessibility.faces.count).to(equal(4))
        expect(self.imageView.accessibilityElements!.count).to(equal(5))
        
        expectBlinkingAccessibilityToBe(accessibility, blinking: [false, false, false, false])
        expectSmilingAccessibilityToBe(accessibility, smiling: [false, false, false, false])
    }

    func testMøPicture() {
        let image = loadImageWithPath(bundle.pathForResource("mø", ofType: "png")!)
        let accessibility = image.accessibility
        
        expectBasicAccessibilityToBe(accessibility, portrait: false, timestamp: 1382565723)
        
        expect(accessibility.faces.count).to(equal(1))
        expect(self.imageView.accessibilityElements!.count).to(equal(2))
        
        expectBlinkingAccessibilityToBe(accessibility, blinking: [false])
        expectSmilingAccessibilityToBe(accessibility, smiling: [false])
    }
    
    func testAccessibilityLoadingCompletionHandling() {
        let path = bundle.pathForResource("mø", ofType: "png")!
        let image = AccessibleImage(contentsOfFile: path)!

        var loading = [Int]()
        let loadingOrder = [Int](0 ..< 10)
        for i in loadingOrder {
            image.loadAdvancedAccessibility {
                loading.append(i)
            }
        }
        
        waitForAccessibleImageToLoad(image)
        expect(loading).toEventually(equal(loadingOrder))
    }
    
}

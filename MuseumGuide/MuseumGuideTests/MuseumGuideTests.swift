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
        expectBlinkingAccessibilityToBe(accessibility, blinking: [false, false, false, false])
        expectSmilingAccessibilityToBe(accessibility, smiling: [false, true, false, false])
    }

    func testMøPicture() {
        let image = loadImageWithPath(bundle.pathForResource("mø", ofType: "png")!)
        let accessibility = image.accessibility
        
        expectBasicAccessibilityToBe(accessibility, portrait: false, timestamp: 1382565723)
        
        expect(accessibility.faces.count).to(equal(1))
        expectBlinkingAccessibilityToBe(accessibility, blinking: [true])
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
    
    func testAccessibleImageInitialization() {
        let path = bundle.pathForResource("mø", ofType: "png")!
        let data = NSData(contentsOfFile: path)!
        
        let contentsOfFileImage = AccessibleImage(contentsOfFile: path)!
        contentsOfFileImage.loadAdvancedAccessibility()
        
        let dataImage = AccessibleImage(data: data)!
        dataImage.loadAdvancedAccessibility()
        
        let dataWithScaleImage = AccessibleImage(data: data, scale: 1)!
        dataWithScaleImage.loadAdvancedAccessibility()
        
        waitForAccessibleImageToLoad(contentsOfFileImage)
        waitForAccessibleImageToLoad(dataImage)
        waitForAccessibleImageToLoad(dataWithScaleImage)
        
        expect(contentsOfFileImage.accessibility).to(equal(dataImage.accessibility))
        expect(contentsOfFileImage.accessibility).to(equal(dataWithScaleImage.accessibility))
        expect(dataWithScaleImage.accessibility).to(equal(dataImage.accessibility))
    }
    
    func testImageViewAccesibility() {
        let path = bundle.pathForResource("metronomy", ofType: "png")!
        let image = AccessibleImage(contentsOfFile: path)!
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let imageView = UIImageView(frame: window.bounds)
        imageView.image = image
        
        window.addSubview(imageView)
        
        waitForAccessibleImageToLoad(image)
        
        expect(imageView.accessibilityElements?.count).to(equal(5))
    }
    
}

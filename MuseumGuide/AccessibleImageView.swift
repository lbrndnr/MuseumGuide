//
//  AccessibleImageView.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 25/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit

public class AccessibleImageView: UIImageView {
    
    /// The image displayed in the image view.
    /// If the image is of type AccessibleImage the view sets
    /// its accessibility information accordingly.
    override public var image: UIImage? {
        didSet {
            reloadAccessibility()
        }
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "voiceOverStatusChanged", name: UIAccessibilityVoiceOverStatusChanged, object: nil)
    }
    
    // MARK: - Accessibility
    
    @objc private func voiceOverStatusChanged() {
        reloadAccessibility()
    }
    
    private func reloadAccessibility() {
        if let image = image as? AccessibleImage {
            makeAccessibleUsingImageAccessibility(image.accessibility)
            
            if UIAccessibilityIsVoiceOverRunning() || image.advancedAccessibilityLoaded || true {
                image.loadAdvancedAccessibility {
                    self.makeAccessibleUsingImageAccessibility(image.accessibility)
                }
            }
        }
        else {
            isAccessibilityElement = true
            accessibilityElements = nil
        }
    }

}

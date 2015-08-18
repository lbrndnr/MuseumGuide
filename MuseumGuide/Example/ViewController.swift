//
//  ViewController.swift
//  Example
//
//  Created by Laurin Brandner on 26/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit
import MuseumGuide

class ViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .ScaleAspectFit
        
        let path = NSBundle.mainBundle().pathForResource("metronomy", ofType: "png")
        imageView.image = path.flatMap { AccessibleImage(contentsOfFile: $0) }
        
        view.addSubview(imageView)
    }

}


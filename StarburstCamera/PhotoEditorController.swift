//
//  ViewController.swift
//  StarburstCamera
//
//  Created by leo on 2017/11/14.
//  Copyright © 2017年 ltebean. All rights reserved.
//

import UIKit

class PhotoEditorController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var thresholdSlider: Slider!
    @IBOutlet weak var strenghSlider: Slider!
    @IBOutlet weak var beamSlider: Slider!
    
    let processor = VideoProcessor()
    let filter = StarBurstFilter()
    let ciContext = CIContext()
    
    var image: UIImage = UIImage(named: "test")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshImage()
    }
    
    @IBAction func sliderValueChanged(_ sender: Slider) {
        if sender == thresholdSlider {
            filter.inputThreshold = sender.value
        }
        else if sender == strenghSlider {
            filter.inputRadius = sender.value
        }
        else if sender == beamSlider {
            filter.inputBeamCount = Float(Int(sender.value))
        }
        refreshImage()
    }
    
    func refreshImage() {
        let proccessed = filter.process(image: CIImage(image: image)!)
        imageView.image = UIImage(cgImage: ciContext.createCGImage(proccessed, from: proccessed.extent)!, scale: image.scale, orientation: image.imageOrientation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


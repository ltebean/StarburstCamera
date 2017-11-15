//
//  VideoFilterManager.swift
//  GhostFace
//
//  Created by leo on 16/12/10.
//  Copyright © 2016年 CaowuTechnology. All rights reserved.
//

import AVFoundation
import CoreImage
import UIKit

public class VideoProcessor {
    
    let ciContext = CIContext()
//    lazy var ciContext: CIContext = {
//        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
//        let options = [kCIContextWorkingColorSpace : NSNull()]
//        return CIContext(eaglContext: eaglContext!, options: options)
//    }()
//    
    private var filters: [Filter] = []
    private let overlayFilter = CIFilter(name: "CISourceOverCompositing")!

    
    init() {
        filters = [
            StarBurstFilter(),
//            PlainFilter(),
//            PixellateFilter(scale: 30),
//            BlurFilter(radius: 50),
//            BeautyFilter(),
//            SketchFilter(),
//            VignetteFilter(),
//            PhotoEffectTransferFilter(),
//            PhotoEffectNoirFilter(),
//            ComicEffectFilter(),
//            StarBurstFilter(),
//            GlassesFilter(ciContext: self.ciContext),
//            BulgingEyesFilter(ciContext: self.ciContext)
        ]
    }
    
    private var currentFilterIndex = 0
    
    func useFilter(ofIndex index: Int) {
        currentFilterIndex = index
    }
    
    func useNextFilter() {
        if (currentFilterIndex < filters.count - 1) {
            currentFilterIndex = currentFilterIndex + 1
        } else {
            currentFilterIndex = 0
        }
    }
    
    func usePreviousFilter() {
        if (currentFilterIndex > 0) {
            currentFilterIndex = currentFilterIndex - 1
        } else {
            currentFilterIndex = filters.count - 1
        }
    }
    
    func processWithFilter(image: CIImage) -> CIImage {
        return filters[currentFilterIndex].process(image: image)
    }
    
    
}

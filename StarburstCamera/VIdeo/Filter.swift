//
//  VideoFilter.swift
//  GhostFace
//
//  Created by leo on 16/12/10.
//  Copyright © 2016年 CaowuTechnology. All rights reserved.
//

import AVFoundation
import CoreImage

protocol Filter {
    func process(image: CIImage) -> CIImage
}

class StarBurstFilter: Filter {
    
    var thresholdFilter = ThresholdFilter()
    
    var inputThreshold: Float = 0.9
    var inputRadius: Float = 30
    var inputBeamCount: Float = 2
    
    func process(image: CIImage) -> CIImage {
        
        thresholdFilter.inputThreshold = inputThreshold
        thresholdFilter.inputImage = image
        
        let output = thresholdFilter.outputImage!
        
        
        
        let angle = Double.pi / Double(inputBeamCount)
        
        var overlay: CIImage!
        for i in 0 ..< Int(inputBeamCount) {
            var inputAngle = angle * Double(i)
            if inputBeamCount == 2 {
                inputAngle += Double.pi / 4
            }
            let blurred = output
                .applyingFilter("CIMotionBlur",
                                parameters: [
                                    kCIInputRadiusKey: inputRadius,
                                    kCIInputAngleKey: inputAngle])
                .cropped(to: image.extent)
            
            if overlay == nil {
                overlay = blurred
            } else {
                overlay = overlay
                    .applyingFilter("CIAdditionCompositing",
                                    parameters: [
                                        kCIInputBackgroundImageKey: blurred])
            }
           
        }
        
//        let blurImageOne = output
//            .applyingFilter("CIMotionBlur",
//                            parameters: [
//                                kCIInputRadiusKey: inputRadius,
//                                kCIInputAngleKey: Double.pi / 4])
//            .cropped(to: output.extent)
//
//
//        let blurImageTwo = output
//            .applyingFilter("CIMotionBlur",
//                            parameters: [
//                                kCIInputRadiusKey: inputRadius,
//                                kCIInputAngleKey: Double.pi / 4 + Double.pi / 2])
//            .cropped(to: image.extent)
        
        
//        let starBurstImage = blurImageOne
//            .applyingFilter("CIAdditionCompositing",
//                            parameters: [
//                                kCIInputBackgroundImageKey: blurImageTwo])
        return image
            .applyingFilter("CIAdditionCompositing",
                            parameters: [
                                kCIInputBackgroundImageKey: overlay])

    }
}

class ThresholdFilter: CIFilter {
    var inputImage : CIImage?
    var inputThreshold: Float = 0.75
    
    var kernel = CIColorKernel(source: try! String(contentsOf: Bundle.main.url(forResource: "threshold", withExtension: "txt")!, encoding: String.Encoding.utf8))
    override var outputImage : CIImage! {
        guard let inputImage = inputImage, let kernel = kernel else {
                return nil
        }
        let extent = inputImage.extent
        let arguments = [inputImage, inputThreshold] as [Any]
        return kernel.apply(extent: extent, roiCallback: { index, rect -> CGRect in
            return rect
        }, arguments: arguments)
    }
}


//struct BulgingEyesFilter: Filter {
//
//    let detector: CIDetector
//    init(ciContext: CIContext) {
//        let options: [String: Any] = [
//            CIDetectorAccuracy: CIDetectorAccuracyHigh,
//            CIDetectorTracking: true
//        ]
//        detector = CIDetector(ofType:CIDetectorTypeFace, context: ciContext,
//                              options: options)!
//    }
//
//    func process(image: CIImage) -> CIImage {
//        if let features = detector.features(in: image).first as? CIFaceFeature, features.hasLeftEyePosition && features.hasRightEyePosition {
//            let eyeDistance = features.leftEyePosition.distanceTo(point: features.rightEyePosition)
//            return image
//                .applyingFilter("CIBumpDistortion",
//                                       withInputParameters: [
//                                        kCIInputRadiusKey: eyeDistance / 1.25,
//                                        kCIInputScaleKey: 0.5,
//                                        kCIInputCenterKey: features.leftEyePosition.toCIVector()])
//                .cropping(to: image.extent)
//                .applyingFilter("CIBumpDistortion",
//                                       withInputParameters: [
//                                        kCIInputRadiusKey: eyeDistance / 1.25,
//                                        kCIInputScaleKey: 0.5,
//                                        kCIInputCenterKey: features.rightEyePosition.toCIVector()])
//                .cropping(to: image.extent)
//
//        } else {
//            return image
//        }
//
//    }
//}
//
//struct GlassesFilter: Filter {
//
//    let detector: CIDetector
//    init(ciContext: CIContext) {
//        let options: [String: Any] = [
//            CIDetectorAccuracy: CIDetectorAccuracyHigh,
//            CIDetectorTracking: true
//        ]
//        detector = CIDetector(ofType:CIDetectorTypeFace, context: ciContext,
//                              options: options)!
//    }
//
//    let glasses = R.image.picGlasses()!
//    let hat = R.image.picHat()!
//
//    let overlayFilter = CIFilter(name: "CISourceOverCompositing")!
//
//    func process(image: CIImage) -> CIImage {
//        if let features = detector.features(in: image).first as? CIFaceFeature, features.hasLeftEyePosition && features.hasRightEyePosition {
//            let bounds = features.bounds
//
//            let leftEyePosition = features.leftEyePosition
//            let rightEyePosition = features.rightEyePosition
//
//            let angle = atan((rightEyePosition.y - leftEyePosition.y) / (rightEyePosition.x - leftEyePosition.x))
////            let y = (leftEyePosition.y + rightEyePosition.y) / 2
//
//            let resizedGlasses = glasses.resize(toSize: bounds.width)
//            var glassesOverlay = CIImage(cgImage: resizedGlasses.cgImage!)
//            var glassesTransform = CGAffineTransform(translationX: bounds.origin.x, y: leftEyePosition.y - resizedGlasses.size.height / 2)
//            glassesTransform = glassesTransform.rotated(by: angle)
//            glassesOverlay = glassesOverlay.applying(glassesTransform)
//
//            let resizedHat = hat.resize(toSize: bounds.width * 2)
//            var hatOverlay = CIImage(cgImage: resizedHat.cgImage!)
//            var hatTransform = CGAffineTransform(translationX: bounds.origin.x - resizedGlasses.size.width / 2 , y: leftEyePosition.y + bounds.height / 8)
//            hatTransform = hatTransform.rotated(by: angle)
//            hatOverlay = hatOverlay.applying(hatTransform)
//
//            let output = image.applyingFilter("CISourceOverCompositing", withInputParameters: [
//                "inputBackgroundImage": image,
//                "inputImage": glassesOverlay
//            ])
//
//            return output.applyingFilter("CISourceOverCompositing", withInputParameters: [
//                "inputBackgroundImage": output,
//                "inputImage": hatOverlay
//            ]).cropping(to: image.extent)
//
//
//        } else {
//            return image
//        }
//
//    }
//}

extension CGPoint {
    
    func distanceTo(point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
    
    func toCIVector() -> CIVector {
        return CIVector(x: self.x, y: self.y)
    }
}


//
//  VideoPicker.swift
//  Slowmo
//
//  Created by ltebean on 16/4/14.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

class ImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var viewController: UIViewController!
    
    var didSelectImage: ((_ image: UIImage) -> Void)?
    
    var imagePickerTitle: String?
    
    func present(inViewController viewController: UIViewController, allowsEditing: Bool=true) {
        self.viewController = viewController
        let alertController = UIAlertController(title: imagePickerTitle, message: nil, preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "拍摄", style: .default) { (action) in
            self.openPhotoPicker(sourceType: .camera, allowsEditing: allowsEditing)
        }
        let chooseAction = UIAlertAction(title: "从相册中选取", style: .default) { (action) in
            self.openPhotoPicker(sourceType: .photoLibrary, allowsEditing: allowsEditing)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func openPhotoPicker(sourceType: UIImagePickerControllerSourceType, allowsEditing: Bool=false) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = allowsEditing
        if sourceType == .camera {
            imagePicker.cameraDevice = .front
        }
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        selectImage(image: image)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        viewController.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectImage(image: pickedImage)
        }
        else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectImage(image: pickedImage)
        }
    }
    
    private func selectImage(image: UIImage) {
        didSelectImage?(image)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

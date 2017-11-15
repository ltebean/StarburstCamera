//
//  HomeViewController.swift
//  StarburstCamera
//
//  Created by leo on 2017/11/15.
//  Copyright © 2017年 ltebean. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let imagePicker = ImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.viewController = self
        imagePicker.didSelectImage = { [weak self] image in
            self?.goToPhotoEdtor(image: image)
        }

        // Do any additional setup after loading the view.
    }
    
    func goToPhotoEdtor(image: UIImage) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoEditor") as! PhotoEditorController
        vc.image = image
        present(vc, animated: true, completion: nil)
    }

    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        imagePicker.openPhotoPicker(sourceType: .photoLibrary, allowsEditing: false)
    }
    

}

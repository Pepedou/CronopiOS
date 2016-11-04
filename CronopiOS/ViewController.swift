//
//  ViewController.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 01/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var cameraFrame = CGRect()
    var myRect = CGRect()
    var imageHeight = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            debugPrint("Device has a camera.")
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = false
            imagePicker.cameraDevice = .rear
            
            let screenSize = UIScreen.main.bounds.size
            
            let cameraAspectRatio = CGFloat(4.0 / 3.0)
            
            let imageHeight = CGFloat(screenSize.width * cameraAspectRatio)
            var verticalAdjustment = CGFloat()
            
            if (screenSize.height - imageHeight > 54.0) {
                verticalAdjustment = CGFloat((screenSize.height - imageHeight) / 2.0)
                verticalAdjustment /= CGFloat(2.0);
                verticalAdjustment += CGFloat(2.0)
            }
            
            let cameraFrame = imagePicker.view.frame
            let cameraOrigin = imagePicker.view.frame.origin
            

            self.cameraFrame = cameraFrame
            self.myRect = CGRect(x: cameraOrigin.x, y: cameraOrigin.y + verticalAdjustment, width: cameraFrame.width / 2.0, height: imageHeight)
            
            let overlayView = OverlayView(frame: self.myRect)
            imagePicker.cameraOverlayView = overlayView
        }
        else {
            debugPrint("Device does not have a camera.")
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        var chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let overlayImage = UIImage(named: "Test")
        
        let targetSize = (chosenImage?.size)!
        let targetRect = CGRect(x: 0.0, y: 0.0, width: targetSize.width, height: targetSize.height)
        let overlayRect = CGRect(x: 0.0, y: 0.0, width: targetSize.width / 2.0, height: targetSize.height)
        
        let croppedImage = self.cropImage(imageToCrop: overlayImage!, rect: overlayRect, fullRect: targetRect)
        
        UIGraphicsBeginImageContext(targetSize)
        
        let context = UIGraphicsGetCurrentContext()
        
        UIGraphicsPushContext(context!)
        
        if picker.cameraDevice == .front
        {
            chosenImage = UIImage(cgImage: (chosenImage?.cgImage)!, scale: 1.0, orientation: .leftMirrored)
        }
        
        chosenImage?.draw(in: targetRect)
        croppedImage?.draw(in: overlayRect)
        
        UIGraphicsPopContext()
        
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = renderedImage
        dismiss(animated: true, completion: nil)
    }
    
    func cropImage(imageToCrop: UIImage, rect: CGRect, fullRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        
        let currentContext = UIGraphicsGetCurrentContext()
        
        UIGraphicsPushContext(currentContext!)
        
        imageToCrop.draw(in: fullRect)
        
        UIGraphicsPopContext()
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil )
    }
}


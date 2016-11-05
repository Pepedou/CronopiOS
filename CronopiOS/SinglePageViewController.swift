//
//  SinglePageViewController.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 01/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit


class SinglePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var bookPage: BookPage!
    
    private var imageView: UIImageView!
    private var saveButton: UIButton!
    private var overlayImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = ((Bundle.main.loadNibNamed("PageView", owner: self, options: nil)?[0] as? UIView)!)
        
        for subview in self.view.subviews {
            if subview.isKind(of: UILabel.self) {
                (subview as! UILabel).text = self.bookPage.pageTitle
            }
            else if subview.isKind(of: UIImageView.self) {
                imageView = (subview as! UIImageView)
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(SinglePageViewController.onImageTap))
                singleTap.numberOfTapsRequired = 1
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(singleTap)
                
                overlayImage = imageView.image
            }
            else if subview.isKind(of: UIButton.self) {
                saveButton = (subview as! UIButton)
                saveButton.addTarget(self, action: #selector(SinglePageViewController.saveImage), for: UIControlEvents.touchUpInside)
            }
            else if subview.isKind(of: UITextView.self) {
                let contentLabel = (subview as! UITextView)
                contentLabel.text = self.bookPage.pageContent
            }
        }
    }

    func onImageTap() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
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
            
            let overlayView = OverlayView(frame: CGRect(x: cameraOrigin.x, y: cameraOrigin.y + verticalAdjustment, width: cameraFrame.width / 2.0, height: imageHeight))

            if (self.overlayImage != nil) {
                overlayView.setImage(image: self.overlayImage!)
            }
            
            imagePicker.cameraOverlayView = overlayView
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "¡Ups!", message: "El dispositivo no cuenta con cámara.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ni hablar", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if picker.sourceType == .camera
        {
            var chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            let overlayImage = self.imageView.image
            
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
            
            self.imageView.image = renderedImage
            self.saveButton.isEnabled = true
        }
        else
        {
            self.overlayImage = info[UIImagePickerControllerEditedImage] as? UIImage
            self.imageView.image = self.overlayImage
            self.saveButton.isEnabled = false
        }
        
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
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            let alert = UIAlertController(title: "¡Ups!", message: "No se pudo guardar la imagen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ni modo", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            self.saveButton.isEnabled = true
            
            return
        }
        
        let alert = UIAlertController(title: "¡Éxito!", message: "Imagen guardada exitosamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "¡Genial!", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        self.saveButton.isEnabled = false
        
        return
    }
}


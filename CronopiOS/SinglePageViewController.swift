//
//  SinglePageViewController.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 01/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit


class SinglePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imageView: UIImageView!
    var saveButton: UIButton!
    var overlayImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = ((Bundle.main.loadNibNamed("PageView", owner: self, options: nil)?[0] as? UIView)!)
        
        for subview in self.view.subviews {
            if subview.isKind(of: UILabel.self) {
                (subview as! UILabel).text = "Capítulo 1"
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
                contentLabel.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc, quis gravida magna mi a libero. Fusce vulputate eleifend sapien. Vestibulum purus quam, scelerisque ut, mollis sed, nonummy id, metus. Nullam accumsan lorem in dui. Cras ultricies mi eu turpis hendrerit fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In ac dui quis mi consectetuer lacinia. Nam pretium turpis et arcu. Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris. Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing. Phasellus ullamcorper ipsum rutrum nunc. Nunc nonummy metus. Vestibulum volutpat pretium libero. Cras id dui. Aenean ut eros et nisl sagittis vestibulum. Nullam nulla eros, ultricies sit amet, nonummy id, imperdiet feugiat, pede. Sed lectus. Donec mollis hendrerit risus. Phasellus nec sem in justo pellentesque facilisis. Etiam imperdiet imperdiet orci. Nunc nec neque. Phasellus leo dolor, tempus non, auctor et, hendrerit quis, nisi. Curabitur ligula sapien, tincidunt non, euismod vitae, posuere imperdiet, leo. Maecenas malesuada. Praesent congue erat at massa. Sed cursus turpis vitae tortor. Donec posuere vulputate arcu. Phasellus accumsan cursus velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed aliquam, nisi quis porttitor congue, elit erat euismod orci, ac placerat dolor lectus quis orci. Phasellus consectetuer vestibulum elit. Aenean tellus metus, bibendum sed, posuere ac, mattis non, nunc. Vestibulum fringilla pede sit amet augue. In turpis. Pellentesque posuere. Praesent turpis. Aenean posuere, tortor sed cursus feugiat, nunc augue blandit nunc, eu sollicitudin urna dolor sagittis lacus. Donec elit libero, sodales nec, volutpat a, suscipit non, turpis. Nullam sagittis. Suspendisse pulvinar, augue ac venenatis condimentum, sem libero volutpat nibh, nec pellentesque velit pede quis nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Fusce id purus. Ut varius tincidunt libero. Phasellus dolor. Maecenas vestibulum mollis"
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


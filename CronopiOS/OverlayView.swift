//
//  OverlayView.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 03/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit

public class OverlayView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OverlayView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        self.imageView.layer.contentsRect = CGRect(x: 0.0, y: 0.0, width: 0.5, height: 1.0)
    }
    
    func getImageView() -> UIImageView{
        return self.imageView
    }
}

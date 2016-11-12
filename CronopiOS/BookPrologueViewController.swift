//
//  BookPrologueViewController.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 11/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit

class BookPrologueViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
}

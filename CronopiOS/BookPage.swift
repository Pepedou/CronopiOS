//
//  BookPage.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 04/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit

class BookPage {
    var pageId: Int
    var pageNumber: Int
    var pageTitle: String
    var pageContent: String
    var pageImage: UIImage?
    
    init(pageId: Int, pageNumber number: Int, pageTitle title: String, pageContent content: String, pageImage image: UIImage?) {
        self.pageId = pageId
        self.pageNumber = number
        self.pageTitle = title
        self.pageContent = content
        self.pageImage = image
    }
}

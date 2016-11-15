//
//  BookPageUpdater.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 07/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit

class BookPageUpdater {
    private let BOOK_PAGES_API_URL = "https://famas.herokuapp.com/book_pages/"
    private let AUTH_VALUE = "Token df66fe76ff339fc4c4d69baab4454d34d2a5ac05"

    func updateBookPage(bookPage page: BookPage, completion: @escaping (_ success: Bool) -> Void) {
        let requestURL = URL(string: BOOK_PAGES_API_URL.appending(String(page.pageId)).appending("/"))!
        var urlRequest = URLRequest(url: requestURL)
        
        urlRequest.httpMethod = "PUT"
        
        let params = [
            "title"  : "\(page.pageTitle)",
            "content": "\(page.pageContent)",
        ]
        
        let boundary = generateBoundaryString()
        
        
        let headers = [
            "Authorization": AUTH_VALUE,
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        urlRequest.allHTTPHeaderFields = headers
        
        let imageData = UIImageJPEGRepresentation(page.pageImage!, 1)!
        
        urlRequest.httpBody = createBodyWithParameters(parameters: params, filePathKey: "image", fileName: page.pageTitle, imageDataKey: imageData as NSData, boundary: boundary) as Data
        
        print(String(describing: urlRequest.httpBody!.description))
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            
            if (statusCode == 200) {
                completion(true)
            }
            else {
                print("Unable to update book page \(page.pageNumber) with status code \(statusCode).")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, fileName: String, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "\(fileName).jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

//
//  BookDownloader.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 06/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit

class BookDownloader
{
    private let BOOK_PAGES_API_URL = "https://famas.herokuapp.com/book_pages/"
    private let AUTH_VALUE = "Token 65df8fa95b9001381d8c8ea46db8c793c9bff231"
    private var pagesCount = 0
    private var completion: ((_ bookPages: [BookPage]) -> Void)!
    
    var bookPages: [BookPage] = []
    
    func downloadBook(completion: @escaping (_ bookPages: [BookPage]) -> Void) {
        let requestURL = URL(string: BOOK_PAGES_API_URL)!
        var urlRequest = URLRequest(url: requestURL)
        
        self.completion = completion
        
        urlRequest.addValue(AUTH_VALUE, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                self.parseJSONResult(data: data)
            }
        }
        
        task.resume()
    }
    
    private func parseJSONResult(data: Data?) {
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]
            
            self.pagesCount = json["count"] as! Int
            
            if let results = json["results"] as? [[String:Any]] {
                for result in results {
                    let pageId = result["id"] as? Int
                    let pageNumber = result["page_number"] as? Int
                    let title = result["title"] as? String
                    let image = result["image"] as? String
                    let content = result["content"] as? String
                    
                    let bookPage = BookPage(pageId: pageId!, pageNumber: pageNumber!, pageTitle: title!, pageContent: content!, pageImage: nil)
                    self.bookPages.append(bookPage)
                    downloadImage(url: URL(string: image!)!, forPageIndex: bookPage.pageNumber)
                }
            }
        }
        catch {
            print("Error with Json: \(error)")
        }
    }

    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }

    private func downloadImage(url: URL, forPageIndex: Int) {
        print("Book page \(forPageIndex) download started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Book page \(forPageIndex) download finished")
            
            self.bookPages[forPageIndex].pageImage = UIImage(data: data)!
            
            let numDownloadedImages = self.bookPages.filter({($0.pageImage != nil)}).count
            
            let isBookDownloadFinished = (numDownloadedImages == self.pagesCount)
            
            if isBookDownloadFinished {
                self.completion(self.bookPages)
            }
        }
    }
}

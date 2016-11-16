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
    private let AUTH_VALUE = "Token eeb76d214b73e78cb56fb5ebd38ee1436a342766"
    private var pagesCount = 0
    private var completion: ((_ bookPages: [BookPage]) -> Void)!
    private var onBookDownloadFailure: ((_ message: String) -> Void)!
    private var onPageDownload: ((_ pageNumber: Int, _ numberOfPages: Int) -> Void)!
    private var onPageDownloadFailure: ((_ pageNumber: Int, _ numberOfPages: Int) -> Void)!
    
    var bookPages: [BookPage] = []
    
    func downloadBook(onPageDownload: @escaping (_ pageNumber: Int, _ numberOfPages: Int) -> Void,
                      onPageDownloadFailure: @escaping(_ pageNumber: Int, _ numberOfPages: Int) -> Void,
                      completion: @escaping (_ bookPages: [BookPage]) -> Void,
                      onBookDownloadFailure: @escaping(_ message: String) -> Void) {
        let requestURL = URL(string: BOOK_PAGES_API_URL)!
        var urlRequest = URLRequest(url: requestURL)
        
        self.completion = completion
        self.onPageDownload = onPageDownload
        self.onPageDownloadFailure = onPageDownloadFailure
        self.onBookDownloadFailure = onBookDownloadFailure
        
        urlRequest.addValue(AUTH_VALUE, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) -> Void in
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            
            if (statusCode == 200) {
                self.parseJSONResult(data: data)
            }
            else {
                print("Failed downloading book. Status code: \(statusCode)")
                onBookDownloadFailure("No se pudo obtener el libro de la otra dimensión. Intenta cerrando completamente " +
                    "la aplicación y asegúrate de tener una buena conexión a la magia antigua. Vamos a reintentar... (\(statusCode))")
            }
        }
        
        task.resume()
    }
    
    private func parseJSONResult(data: Data?) {
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]
            self.pagesCount = json["count"] as! Int
            
            if self.pagesCount == 0 {
                self.onBookDownloadFailure("Al parecer, el libro no contiene páginas. Qué tristeza...")
                return
            }
            
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
            self.onBookDownloadFailure("No se pudieron descargar las páginas de la otra dimensión. Intentaremos de nuevo... (\(error))")
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
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse?.statusCode == 200 {
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Book page \(forPageIndex) download finished")
                
                self.bookPages[forPageIndex].pageImage = UIImage(data: data)!
                
                let numDownloadedImages = self.bookPages.filter({($0.pageImage != nil)}).count
                
                let isBookDownloadFinished = (numDownloadedImages == self.pagesCount)
                
                self.onPageDownload(numDownloadedImages, self.pagesCount)
                
                if isBookDownloadFinished {
                    self.completion(self.bookPages)
                }
            }
            else {
                print("Failed to download image \(forPageIndex) with status code \(httpResponse?.statusCode)")
                self.onPageDownloadFailure(forPageIndex, self.pagesCount)
            }
        }
    }
}

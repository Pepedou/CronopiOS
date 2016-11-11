//
//  PagesViewController.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 04/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit

class PagesViewController: UIPageViewController {
    var bookPages: [BookPage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        self.refreshBook()
    }
    
    func refreshBook() {
        let bookDownloader = BookDownloader()
        let bookCoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookCoverViewController") as! BookCoverViewController
        
        bookDownloader.downloadBook(onPageDownload: {(pageNumber: Int, numberOfPages: Int) -> Void in
            DispatchQueue.main.async {
                bookCoverVC.progressView.progress = Float(pageNumber) / Float(numberOfPages)
            }
        }, completion: {(bookPages: [BookPage]) -> Void in
            self.bookPages = bookPages
            
            DispatchQueue.main.async() { () -> Void in
                let singlePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as? SinglePageViewController
                singlePageVC?.bookPage = bookPages.first
                
                self.setViewControllers([singlePageVC!], direction: .forward, animated: true, completion: nil)
            }
        })
        
        self.setViewControllers([bookCoverVC], direction: .forward, animated: true, completion: nil)
    }
}

extension PagesViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let singlePageVC = viewController as! SinglePageViewController
        let currentPageNumber = singlePageVC.bookPage.pageNumber
        
        guard currentPageNumber > 0 else {
            return nil
        }
        
        let previousPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as? SinglePageViewController
        previousPageViewController?.bookPage = self.bookPages[currentPageNumber - 1]
        
        return previousPageViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let singlePageVC = viewController as! SinglePageViewController
        let currentPageNumber = singlePageVC.bookPage.pageNumber
        
        guard currentPageNumber + 1 < self.bookPages.count else {
            return nil
        }
        
        let nextPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as? SinglePageViewController
        nextPageViewController?.bookPage = self.bookPages[currentPageNumber + 1]
        
        return nextPageViewController
    }
}

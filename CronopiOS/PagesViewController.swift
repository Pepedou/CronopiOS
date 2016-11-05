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
        
        for i in 0...9 {
            bookPages.append(BookPage(pageNumber: i, pageTitle: "Capítulo \(i + 1)", pageContent: "Hola amigo", pageImage: UIImage()))
        }
        
        let singlePageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as? SinglePageViewController
        singlePageVC?.bookPage = bookPages.first
        
        setViewControllers([singlePageVC!], direction: .forward, animated: true, completion: nil)
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
        
        guard currentPageNumber < 9 else {
            return nil
        }
        
        let nextPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as? SinglePageViewController
        nextPageViewController?.bookPage = self.bookPages[currentPageNumber + 1]
        
        return nextPageViewController
    }
}

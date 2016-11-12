//
//  PagesViewController.swift
//  CronopiOS
//
//  Created by José Luis Valencia Herrera on 04/11/16.
//  Copyright © 2016 José Luis Valencia Herrera. All rights reserved.
//

import UIKit
import AVFoundation

class PagesViewController: UIPageViewController {
    var bookPages: [BookPage] = []
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        self.playBackgroundMusic()
        self.refreshBook()
    }
    
    func playBackgroundMusic() {
        let audioFileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "BackgroundMusic", ofType: "mp3")!)
        
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOf: audioFileURL)
            self.audioPlayer?.numberOfLoops = -1
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        }
        catch {
            print("Unable to play background music.")
        }
    }
    
    func refreshBook() {
        let bookDownloader = BookDownloader()
        let bookCoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookCoverViewController") as! BookCoverViewController
        self.audioPlayer?.setVolume(1.0, fadeDuration: 3)
        
        bookDownloader.downloadBook(onPageDownload: {(pageNumber: Int, numberOfPages: Int) -> Void in
            DispatchQueue.main.async {
                bookCoverVC.progressView.progress = Float(pageNumber) / Float(numberOfPages)
            }
        }, completion: {(bookPages: [BookPage]) -> Void in
            self.bookPages = bookPages
            self.audioPlayer?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   .setVolume(0.1, fadeDuration: 3)
            
            DispatchQueue.main.async() { () -> Void in
                let prologueVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrologueViewController")
                self.setViewControllers([prologueVC], direction: .forward, animated: true, completion: nil)
            }
        })
        
        self.setViewControllers([bookCoverVC], direction: .forward, animated: true, completion: nil)
    }
    
    func toggleAudio() {
        if (self.audioPlayer?.isPlaying)! {
            self.audioPlayer?.pause()
        }
        else {
            self.audioPlayer?.play()
        }
    }
}

extension PagesViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewController.isKind(of: SinglePageViewController.self) else {
            return nil
        }
        
        let singlePageVC = viewController as! SinglePageViewController
        let currentPageNumber = singlePageVC.bookPage.pageNumber
        
        guard currentPageNumber >= 0 else {
            return nil
        }
        
        if currentPageNumber == 0 {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrologueViewController")
        }
        
        let previousPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as? SinglePageViewController
        previousPageViewController?.bookPage = self.bookPages[currentPageNumber - 1]
        
        return previousPageViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let isPrologue = viewController.restorationIdentifier == "PrologueViewController"
        let isSinglePage = viewController.isKind(of: SinglePageViewController.self)
        var currentPageNumber = 0
        
        guard isPrologue || isSinglePage else {
            return nil
        }
        
        if isPrologue {
            currentPageNumber = -1
        }
        else {
            let singlePageVC = viewController as! SinglePageViewController
            currentPageNumber = singlePageVC.bookPage.pageNumber
        }
        
        guard currentPageNumber + 1 < self.bookPages.count else {
            return nil
        }
        
        let nextPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SinglePageViewController") as? SinglePageViewController
        nextPageViewController?.bookPage = self.bookPages[currentPageNumber + 1]
        
        return nextPageViewController
    }
}

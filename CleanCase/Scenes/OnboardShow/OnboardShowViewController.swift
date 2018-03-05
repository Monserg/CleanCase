//
//  OnboardShowViewController.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import DynamicColor
import SwiftSpinner
import ImageSlideshow

class OnboardShowViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle("Next".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.numberOfPages                     =   5
            pageControl.currentPage                       =   0
            pageControl.tintColor                         =   UIColor.red
            pageControl.pageIndicatorTintColor            =   DynamicColor(hexString: "#88A7E4")
            pageControl.currentPageIndicatorTintColor     =   DynamicColor(hexString: "#3D5B96")
        }
    }
    
    @IBOutlet weak var pageTitleLabel: UILabel! {
        didSet {
            pageTitleLabel.numberOfLines = 0
            pageTitleLabel.textAlignment = .center
        }
    }
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    

    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SwiftSpinner.hide()
    }

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideBackBarButton()
        self.addNavigationBarShadow()
        self.loadTitle(forPage: self.pageControl.currentPage)
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
        self.prepareInfoForPresentation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    fileprivate func loadTitle(forPage page: Int) {
        let pageTitles = [ "TitleForPage0".localized(), "TitleForPage1".localized(), "TitleForPage2".localized(), "TitleForPage3".localized(), "TitleForPage4".localized() ]
        self.pageTitleLabel.fadeTransition(0.5)
        self.pageTitleLabel.text = pageTitles[page]
    }
    
    fileprivate func prepareInfoForPresentation() {
        imageSlideShow.backgroundColor                              =   UIColor.clear
        imageSlideShow.draggingEnabled                              =   false
        imageSlideShow.pageControlPosition                          =   .hidden    // .insideScrollView
        imageSlideShow.pageControl.currentPageIndicatorTintColor    =   DynamicColor(hexString: "#3D5B96")
        imageSlideShow.pageControl.pageIndicatorTintColor           =   DynamicColor(hexString: "#88A7E4")
        imageSlideShow.contentScaleMode                             =   UIViewContentMode.scaleAspectFill
        
        imageSlideShow.currentPageChanged = { [unowned self] page in
            self.loadTitle(forPage: page)
        }
        
        // Load images
        imageSlideShow.setImageInputs([
            ImageSource(image: UIImage(named: "image-for-page-0")!),
            ImageSource(image: UIImage(named: "image-for-page-1")!),
            ImageSource(image: UIImage(named: "image-for-page-2")!),
            ImageSource(image: UIImage(named: "image-for-page-3")!),
            ImageSource(image: UIImage(named: "image-for-page-4")!)
        ])
    }

    fileprivate func showNextPage() {
        self.imageSlideShow.setCurrentPage(self.pageControl.currentPage, animated: true)
        self.nextButton.setTitle((self.pageControl.currentPage == 4) ? "Start".localized() : "Next".localized(), for: .normal)
    }
    
    
    // MARK: - UIPageControl
    @IBAction func handlerSelectNewPage(_ sender: UIPageControl) {
        self.showNextPage()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerNextButtonTapped(_ sender: UIButton) {
        if sender.title(for: .normal) == "Start".localized() {
            SwiftSpinner.show("Loading App data...".localized(), animated: true)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 17) {
                self.performSegue(withIdentifier: "MainShowSegue", sender: nil)
            }
        }
        
        else {
            self.pageControl.currentPage += 1
            self.showNextPage()
        }
    }
}

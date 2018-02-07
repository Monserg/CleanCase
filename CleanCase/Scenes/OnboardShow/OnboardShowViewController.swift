//
//  OnboardShowViewController.swift
//  CleanCase
//
//  Created by msm72 on 06.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import SwiftSpinner
import ImageSlideshow

class OnboardShowViewController: UIViewController {
    // MARK: - Properties
    var currentPage: Int = 0

    
    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setTitle("Next".localized(), for: .normal)
        }
    }
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    @IBOutlet weak var pageTitleLabel: UILabel! {
        didSet {
            pageTitleLabel.numberOfLines = 0
            pageTitleLabel.textAlignment = .center
        }
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
        self.loadTitle(forPage: currentPage)
        self.displayLaundryInfo(withName: Laundry.name, andPhoneNumber: "\(Laundry.phoneNumber ?? "")")
        self.prepareInfoForPresentation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Functions
    fileprivate func loadTitle(forPage page: Int) {
        let pageTitles = [ "TitleForPage0", "TitleForPage1", "TitleForPage2", "TitleForPage3", "TitleForPage4" ]
        self.pageTitleLabel.fadeTransition(0.5)
        self.pageTitleLabel.text = pageTitles[page]
    }
    
    fileprivate func prepareInfoForPresentation() {
        imageSlideShow.backgroundColor = UIColor.clear
        imageSlideShow.draggingEnabled = false
        imageSlideShow.pageControlPosition = .insideScrollView
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.red
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.blue
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
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

    
    // MARK: - Actions
    @IBAction func handlerControlPageButtonTapped(_ sender: UIButton) {
        if self.currentPage != 4 {
            self.handlerNextButtonTapped(self.nextButton)
        }
    }
    
    @IBAction func handlerNextButtonTapped(_ sender: UIButton) {
        if sender.title(for: .normal) == "Start".localized() {
            SwiftSpinner.show("Loading App data...".localized(), animated: true)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 10) {
                self.performSegue(withIdentifier: "MainShowSegue", sender: nil)
            }
        }
        
        else {
            self.currentPage += 1
            self.imageSlideShow.setCurrentPage(currentPage, animated: true)
            
            if self.currentPage == 4 {
                self.nextButton.setTitle("Start".localized(), for: .normal)
            }
        }
    }
}

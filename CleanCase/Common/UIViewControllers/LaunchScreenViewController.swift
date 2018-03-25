//
//  LaunchScreenViewController.swift
//  CleanCase
//
//  Created by msm72 on 25.03.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            versionLabel.text = String(format: "(%@)%@ %@", Bundle.main.buildNumber ?? "0", String(Bundle.main.versionNumber), "Version".localized())
        }
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRootVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Functions
    private func setRootVC() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dispatchTimeDelay * 5) {
            let window                  =   UIWindow(frame: UIScreen.main.bounds)
            let storyboard              =   UIStoryboard(name: "FlowControlShow", bundle: nil)
            let flowControlShowNC       =   storyboard.instantiateViewController(withIdentifier: "FlowControlShowNC")
            
            window.rootViewController   =   flowControlShowNC
            window.makeKeyAndVisible()
        }
    }
}

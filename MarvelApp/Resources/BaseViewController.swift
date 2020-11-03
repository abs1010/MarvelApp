//
//  BaseViewController.swift
//  MarvelApp
//
//  Created by Alan Silva on 20/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func startActivityIndicator(){
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        }
        activityIndicator.color = .red
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
    }

    func showAlert(title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(btnOk)
        
        self.present(alert, animated: true)
        
    }
    
}

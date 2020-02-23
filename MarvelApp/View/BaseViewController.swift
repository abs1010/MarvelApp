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
        //activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
    }

    func showAlert(title: String, msg: String, style: UIAlertController.Style) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: style)
        let btnOk = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        
        alert.addAction(btnOk)
        
        self.present(alert, animated: true)
        
    }
    
}

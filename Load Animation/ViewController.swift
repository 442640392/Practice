//
//  ViewController.swift
//  Load Animation
//
//  Created by Nao on 16/10/24.
//  Copyright © 2016年 倪夏辉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    weak var loadingView:LoadingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
        let loadingView = LoadingView.showLoadingWith(view: view)
        self.loadingView = loadingView
        
    }
    
    @IBAction func hideLoadingView(_ sender: AnyObject) {
        
        loadingView.hideLoadingView()
        
    }
    
    
    
}


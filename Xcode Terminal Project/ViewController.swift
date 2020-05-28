//
//  ViewController.swift
//  Xcode Terminal Project
//
//  Created by Eric Huang on 5/27/20.
//  Copyright © 2020 Eric Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var fibonacciStyle: UIButton!
    @IBOutlet weak var dydxStyle: UIButton!
    var identifier = "goTofibonacci"
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "DIN Condensed", size: 30)!]
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func chooseCALCtype(_ sender: UIButton) {
        fibonacciStyle.isSelected = false
        dydxStyle.isSelected = false
        sender.isSelected = true
        if let title = sender.titleLabel?.text{
            if title == "Fibonacci"{
                identifier = "goTofibonacci"
            }else{
                identifier = "goTodydx"
            }
        }
        
    }
    
    @IBAction func moveToCalc(_ sender: UIButton) {
        performSegue(withIdentifier: identifier, sender: self)
    }
}

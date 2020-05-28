//
//  FibonacciViewController.swift
//  Xcode Terminal Project
//
//  Created by Eric Huang on 5/27/20.
//  Copyright © 2020 Eric Huang. All rights reserved.
//

import UIKit

class FibonacciViewController: UIViewController {

    @IBOutlet weak var nthTermTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        nthTermTextField.text = ""
        resultLabel.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.2
        resultLabel.numberOfLines = 2
        nthTermTextField.delegate = self
    }
    
    @IBAction func CalculateButton(_ sender: UIButton) {
        if let nth = nthTermTextField.text{
            if let integerNth = Int(nth){
                let result = String(fibonacci(n: integerNth))
                if result == "404"{
                    resultLabel.text = "Error - The number is too big or too small."
                }else{
                    resultLabel.text = String(fibonacci(n: integerNth))
                }
            }else if nth == ""{
                resultLabel.text = "Blank - Enter the correct value."
            }else{
                resultLabel.text = "Unable to convert words into letters."
            }
        }else{
            resultLabel.text = "Error - Enter the correct value."
        }
    }
    

    func fibonacci(n: Int)->Int{
        var firstIndex = 0
        var secondIndex = 1
        var array = [0, 1]
        if n<90{
            while secondIndex < n{
                array.append(array[firstIndex] + array[secondIndex])
                firstIndex += 1
                secondIndex += 1
            }
            return array[n]
        }else{
            return 404
        }
    }
}
extension FibonacciViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nthTermTextField.endEditing(true)
        return true
    }
}

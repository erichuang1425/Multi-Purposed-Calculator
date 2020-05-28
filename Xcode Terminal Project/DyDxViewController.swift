//
//  DyDxViewController.swift
//  Xcode Terminal Project
//
//  Created by Eric Huang on 5/27/20.
//  Copyright © 2020 Eric Huang. All rights reserved.
//

import UIKit
class DyDxViewController: UIViewController {

    @IBOutlet weak var coeficientTextField: UITextField!
    @IBOutlet weak var powerTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewWillDisappear(_ animated: Bool) {
        coeficientTextField.text = ""
        powerTextField.text = ""
        resultLabel.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.2
        resultLabel.numberOfLines = 2
        coeficientTextField.delegate = self
        powerTextField.delegate = self
        coeficientTextField.text = "1"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        if let powerString = powerTextField.text, let coeficientString = coeficientTextField.text{
            if coeficientString.contains("/") == true{
                calculation(Double(powerString), fraction(coeficientString))
            }else{
                calculation(Double(powerString), Double(coeficientString))
            }
            
        }else{
            resultLabel.text = "Error - Enter the correct value."
        }
        

    }
    func calculation(_ power:Double?, _ coeficient:Double?){
        if let power = power, let coeficient = coeficient{
            resultLabel.text = dydxCalculation(power, coeficient)
        }
    }
    func fraction(_ fractionString:String)->Double{
        var double = 0.0
        for each in fractionString{
            if each == "/"{
                let beforeAndAfter = fractionString.components(separatedBy:"/")
                if let first = Double(beforeAndAfter[0]), let second = Double(beforeAndAfter[1]){
                    if let doubleCalculation = Double(String(format:"%.2f",first/second)){
                        double = doubleCalculation
                        print(first/second)
                    }
                }
              
            }
        }
        return double
    }
    
    
    func dydxCalculation(_ power:Double, _ coeficient:Double)->String{
        let coeficientDone = String(format:"%.2f",coeficient*Double(power))
        let powerDone = String(Int(floor(power-1))).compactMap{ $0.wholeNumberValue }
        print(powerDone)
        var powerFinishDone = ""
        var finishedString = ""
        for each in powerDone{
            powerFinishDone += Superscript.value(each)
        }
        finishedString = "\(coeficientDone)x\(powerFinishDone)"
        return finishedString
        
    }
   

}

extension DyDxViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        coeficientTextField.endEditing(true)
        powerTextField.endEditing(true)
        return true
    }
}

extension Int {
    func superscriptString() -> String {
        let minusPrefixOrEmpty: String = self < 0 ? Superscript.minus : ""
        let (quotient, remainder) = abs(self).quotientAndRemainder(dividingBy: 10)
        let quotientString = quotient > 0 ? quotient.superscriptString() : ""
        return minusPrefixOrEmpty + quotientString + Superscript.value(remainder)
    }
}

enum Superscript {
    static let minus = "⁻"
    private static let values: [String] = [
        "⁰",
        "¹",
        "²",
        "³",
        "⁴",
        "⁵",
        "⁶",
        "⁷",
        "⁸",
        "⁹"
    ]

    static func value(_ int: Int) -> String {
        assert(int >= 0 && int <= 9)
        return values[int]
    }
}
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

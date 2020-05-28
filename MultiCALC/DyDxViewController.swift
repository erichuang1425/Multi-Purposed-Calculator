//
//  DyDxViewController.swift
//  MultiCALC
//
//  Created by Eric Huang on 5/27/20.
//  Copyright © 2020 Eric Huang. All rights reserved.
//

import UIKit
class DyDxViewController: UIViewController {

    @IBOutlet weak var coeficientTextField: UITextField!
    @IBOutlet weak var powerTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    var powerGlobal = 0.0
    var coeficientGlobal = 0.0
    var negative = 1
    override func viewWillDisappear(_ animated: Bool) {
        coeficientTextField.text = ""
        powerTextField.text = ""
        resultLabel.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        negative = 1
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.2
        resultLabel.numberOfLines = 2
        coeficientTextField.delegate = self
        powerTextField.delegate = self
        coeficientTextField.text = "1"
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        if let powerString = powerTextField.text, let coeficientString = coeficientTextField.text{
            if powerString != "", coeficientString != ""{
                if powerString.contains("/"){
                           powerGlobal = fraction(powerString)
                       }else{
                           if let _ = Double(powerString){
                               doubleCouldConvert(powerString, choice: "power")
                           }else{
                               resultLabel.text = "Error - cannot convert to numbers."
                               return
                           }
                       }
                       if coeficientString.contains("/"){
                           coeficientGlobal = fraction(coeficientString)
                
                       }else{
                           if let _ = Double(coeficientString){
                               doubleCouldConvert(coeficientString, choice: "coeficient")
                           }else{
                               resultLabel.text = "Error - cannot convert to numbers."
                               return
                           }
                           
                       }
                       calculation(powerGlobal, coeficientGlobal)
                   
            }else{
                resultLabel.text = "Blank - Enter a value."
            }
            
        }else{
            resultLabel.text = "Blank - Enter a value."
        }
        

    }
    func doubleCouldConvert(_ insertedDouble:String, choice:String){
        if let doubleConverted = Double(insertedDouble){
            if choice == "power"{
                powerGlobal = doubleConverted
            }else{
                coeficientGlobal = doubleConverted
            }
        }else{
            resultLabel.text = "Error - cannot convert to numbers."
        }
    }
    func calculation(_ power:Double, _ coeficient:Double){
        
            resultLabel.text = dydxCalculation(power, coeficient)
        
    }
    func fraction(_ fractionString:String)->Double{
        var double = 0.0
        for each in fractionString{
            if each == "/"{
                let beforeAndAfter = fractionString.components(separatedBy:"/")
                if let first = Double(beforeAndAfter[0]), let second = Double(beforeAndAfter[1]){
                    let calculated = first/second
                    let count = String(Int(calculated)).compactMap{ $0.wholeNumberValue }.count
                    let doubleCalculation = round(calculated, to: count)

                    double = doubleCalculation
                    
                }
              
            }
        }
        return double
    }
    
    
    func dydxCalculation(_ power:Double, _ coeficient:Double)->String{
        let minusPower = power-1
        var calculation:Double{
            if minusPower == 0.0{
                return 0.0
            }else{
                return coeficient*minusPower
            }
        }
        let countCalculation = String(Int(calculation)).compactMap{ $0.wholeNumberValue }.count
        var coeficientDone:Double{
            if calculation == 0.0{
                return 0.0
            }else{
                print(countCalculation)
                return round(calculation, to: countCalculation+1)
            }
        }
        var powerFinishDone = ""
        var finishedString = ""
        if minusPower<0{
            negative = -1
        }
        let count = String(Int(power)).compactMap{ $0.wholeNumberValue }.count
        if minusPower == 0{
            powerFinishDone = "⁰"
        }else{
            let powerDone = String(Int(round(minusPower, to: count))).compactMap{ $0.wholeNumberValue }
            for each in powerDone{
                powerFinishDone += Superscript.value(each, negative: negative)
                negative = 1
            }
        }
        finishedString = "\(coeficientDone)x\(powerFinishDone)"
        return finishedString
        
    }
   func round(_ num: Double, to places: Int) -> Double {
    if num<0{
        let p = log10(abs(num))
        let f = pow(10, p.rounded() - Double(places) + 1)
        let rnum = (num / f).rounded() * f

        return rnum * -1
    }else{
       let p = log10(abs(num))
       let f = pow(10, p.rounded() - Double(places) + 1)
       let rnum = (num / f).rounded() * f

       return rnum
    }
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
    func superscriptString(negative:Int) -> String {
        let minusPrefixOrEmpty: String = self < 0 ? Superscript.minus : ""
        let (quotient, remainder) = abs(self).quotientAndRemainder(dividingBy: 10)
        let quotientString = quotient > 0 ? quotient.superscriptString(negative: negative) : ""
        return minusPrefixOrEmpty + quotientString + Superscript.value(remainder, negative: negative)
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

    static func value(_ int: Int, negative:Int) -> String {
        if negative<0{
            assert(abs(int) >= 0 && abs(int) <= 9)
            return "⁻"+values[int]
        }else{
            assert(int >= 0 && int <= 9)
            return values[int]
        }
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

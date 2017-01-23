//
//  BlurVC.swift
//  test_5
//
//  Created by Experteer on 29/12/16.
//  Copyright © 2016 Experteer. All rights reserved.
//

import UIKit


import UIKit

class BlurVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fromYearPicker: UIPickerView!
    @IBOutlet weak var searchTerm: UITextField!
    
    var delegate:UpdateSearchCriteriaDelegate?

    var startYearVal: Int = 1950
    
   // @IBOutlet weak var startYear: UIPickerView!
    var years: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1996...2017 {
            years.append(i)
        }
        fromYearPicker.selectRow(0, inComponent: 0, animated: true)
        searchTerm.text = SearchCriteria.searchTerm
        
        NotificationCenter.default.addObserver(self, selector: #selector(BlurVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BlurVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func startEdit(_ sender: AnyObject) {
        print("startEdit")
    }
    
    @IBAction func primaryActionTriggered(_ sender: AnyObject) {
        print("primaryActionTriggered")
        searchTerm.resignFirstResponder()
    }
    
    @IBAction func editingDidEnd(_ sender: AnyObject) {
        print("editing did end")
        
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }     //ci consente di determinare quale riga è stata selezionata
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {        print("Hai selezionato: \(years[row])")
    }
    
    @IBAction func performSearch(_ sender: AnyObject) {
        SearchCriteria.searchTerm = searchTerm.text!
        delegate?.updateCriteria()
        self.dismiss(animated: true, completion: nil)
    }
    

}

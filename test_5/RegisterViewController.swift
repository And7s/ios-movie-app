//
//  RegisterViewController.swift
//  test_5
//
//  Created by Experteer on 06/01/17.
//  Copyright © 2017 Experteer. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var inputName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: AnyObject) {
         self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var nameInput: UITextField!
    
    @IBAction func nameDone(_ sender: AnyObject) {
        nameInput.resignFirstResponder()
        Profile.name = inputName.text!
     }
    
    @IBOutlet weak var passwordInput: UITextField!
    @IBAction func passwordDone(_ sender: AnyObject) {
        
        passwordInput.resignFirstResponder()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

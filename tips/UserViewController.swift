//
//  UserViewController.swift
//  tips
//
//  Created by Chen, Anthony on 12/24/14.
//  Copyright (c) 2014 Chen, Anthony. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var validationMessage: UILabel!
  
  // Custom tip fields. Hacks. Theres probably a better way of doing this.
  @IBOutlet weak var firstTipField: UITextField!
  @IBOutlet weak var secondTipField: UITextField!
  @IBOutlet weak var thirdTipField: UITextField!
  
  
  // Default values
  var tipPercentageArray: [Float] = [0.18, 0.2, 0.22]
  var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Check if user stored default values exist
    if let storedArray = userDefaults.arrayForKey(tipPercentageArrayKey) {
      var tipFields = [firstTipField, secondTipField, thirdTipField]
      tipPercentageArray = storedArray as [Float]
      // Set selector with user stored default values in view
      for (i,e) in enumerate(tipPercentageArray) {
        tipControl.setTitle(String(format: "%.0f%%", e * 100),
                   forSegmentAtIndex: i)
        tipFields[i].text = String(format: "%.0f", e * 100)
      }
    }
    
    var defaultSelection = userDefaults.integerForKey(tipSelectorDefaultKey)
    if defaultSelection != 0 {
      tipControl.selectedSegmentIndex = defaultSelection - 1
    }
  }
  
  @IBAction func onDefaultPercentageChanged(sender: AnyObject) {
    userDefaults.setInteger(tipControl.selectedSegmentIndex + 1,
                 forKey: tipSelectorDefaultKey)
  }

  @IBAction func onEditingChanged(sender: UITextField) {
    // Set tipControl to UITextField value
    var percentage = ((sender.text as NSString).floatValue)/100.0
    if percentage <= 1 {
      tipPercentageArray[sender.tag] = percentage
      // set default cache
      tipControl.setTitle(sender.text + "%",
                 forSegmentAtIndex: sender.tag)
    } else {
      // Optionally initialize the property to a desired starting value
      UIView.animateWithDuration(0.4, animations: {
        self.validationMessage.alpha = 1
      })
    }
  }
  
  @IBAction func onTap(sender: AnyObject) {
    view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onCancel(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
    // Save default values
    userDefaults.setObject(tipPercentageArray, forKey: tipPercentageArrayKey)
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}

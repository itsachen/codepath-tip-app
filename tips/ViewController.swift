//
//  ViewController.swift
//  tips
//
//  Created by Chen, Anthony on 12/22/14.
//  Copyright (c) 2014 Chen, Anthony. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var billField: UITextField!
  @IBOutlet weak var tipLabel: UILabel!
  @IBOutlet weak var tipControl: UISegmentedControl!
  @IBOutlet weak var perPersonTotalLabel: UILabel!
  @IBOutlet weak var partySizeStepper: UIStepper!
  @IBOutlet weak var partySizeLabel: UILabel!
  
  let locationManager = CLLocationManager()
  
  // Default values
  var tipPercentageArray: [Float] = [0.18, 0.2, 0.22]
  var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    tipLabel.text = getCurrencySymbol() + "0.00"
    perPersonTotalLabel.text = getCurrencySymbol() + "0.00"
    
    // Check if user stored default values exist
    updatePercentageValuesFromSettings()
    updateDefaultTipSelectionFromSettings()
    
    // Set up location management
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onEditingChanged(sender: AnyObject) {
    recalculateValues()
  }

  @IBAction func onTap(sender: AnyObject) {
    view.endEditing(true)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    updatePercentageValuesFromSettings()
    recalculateValues()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  // Update view with new values
  func recalculateValues() {
    var tipPercentage = tipPercentageArray[tipControl.selectedSegmentIndex]
    
    var billAmount = (billField.text as NSString).floatValue
    var tip = billAmount * tipPercentage
    var total_per_person = (billAmount + tip) / Float(partySizeStepper.value)
    
    tipLabel.text = String(format: getCurrencySymbol() + "%.2f", tip)
    perPersonTotalLabel.text = String(format: getCurrencySymbol() + "%.2f", total_per_person)
    partySizeLabel.text = String(count:Int(partySizeStepper.value), repeatedValue: "👤" as Character)
  }
  
  // CLLocationManager functions
  func locationManager(manager: CLLocationManager!,
       didUpdateLocations locations: [AnyObject]!) {
    CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
      
      if (error != nil) {
        println("Reverse geocoder failed with error" + error.localizedDescription)
        return
      }
      
      if placemarks.count > 0 {
        let pm = placemarks[0] as CLPlacemark
        self.updateDefaultCurrencySymbol(getCurrencyForCountry(pm.country))
      } else {
        println("Problem with the data received from geocoder")
      }
    })
  }
  
  func locationManager(manager: CLLocationManager!,
       didFailWithError error: NSError!) {
    println("Error while updating location " + error.localizedDescription)
  }
  
  ////////////////////////////////
  // NSUserDefaults cache methods
  ////////////////////////////////
  
  // Note:
  // I feel like I'm abusing/overloading the NSUserDefaults cache?
  // Not sure how it's usually used.
  
  // Check NSUserDefaults cache for previously set default percentages
  func updatePercentageValuesFromSettings() {
    if let storedArray = userDefaults.arrayForKey(tipPercentageArrayKey) {
      tipPercentageArray = storedArray as [Float]
      // Set selector with user stored default values in view
      for (i,e) in enumerate(tipPercentageArray) {
        tipControl.setTitle(String(format: "%.0f%%", e * 100),
          forSegmentAtIndex: i)
      }
    }
  }
  
  func updateDefaultTipSelectionFromSettings() {
    var defaultSelection = userDefaults.integerForKey(tipSelectorDefaultKey)
    if defaultSelection != 0 {
      tipControl.selectedSegmentIndex = defaultSelection - 1
    }
  }
  
  func updateDefaultCurrencySymbol(symbol: String) {
    if let defaultSymbol = userDefaults.stringForKey(currencySymbol) {
      if defaultSymbol != symbol {
        userDefaults.setValue(symbol, forKey: currencySymbol)
      }
    } else {
      // First save
      userDefaults.setValue(symbol, forKey: currencySymbol)
    }
  }
  
  func getCurrencySymbol() -> String {
    if let defaultSymbol = userDefaults.stringForKey(currencySymbol) {
      return defaultSymbol
    } else {
      return "$"
    }
  }
}


//
//  ViewController.swift
//  Tipper
//
//  Created by Kris Aldenderfer on 4/10/15.
//  Copyright (c) 2015 Shopular. All rights reserved.
//

import UIKit

class TipperViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var equalsLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    let tipPercentages = [0.15, 0.2, 0.22]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if var savedDate = defaults.objectForKey("saved_date") {
            savedDate = savedDate as NSDate
            if (-savedDate.timeIntervalSinceNow < 600) {
                billField.text = defaults.objectForKey("saved_bill") as String
            }
        }
        
        updateValues()
    }
    
    func applicationWillResignActive(notification: NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billField.text, forKey: "saved_bill")
        defaults.setObject(NSDate(), forKey: "saved_date")
        defaults.synchronize()
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        tipControl.selectedSegmentIndex = defaults.integerForKey("default_tip")
        
        billField.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationDidBecomeActive:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationWillResignActive:",
            name: UIApplicationWillResignActiveNotification,
            object: nil)
        
        updateValues()
    }
    
    override func viewDidDisappear(animated:Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        updateValues()
    }
    
    func updateValues() {
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let billAmount = (billField.text as NSString).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        let formatter = NSNumberFormatter()
        
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        tipLabel.text = formatter.stringFromNumber(tip as NSNumber)
        totalLabel.text = formatter.stringFromNumber(total as NSNumber)
        
        if (billAmount != 0) {
            fadeLabelsIn()
        } else {
            fadeLabelsOut()
        }
    }
    
    func fadeLabelsIn() {
        UIView.animateWithDuration(0.2, animations: {
            self.tipLabel.alpha = 1.0
            self.plusLabel.alpha = 1.0
            self.totalLabel.alpha = 1.0
            self.equalsLabel.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeLabelsOut() {
        UIView.animateWithDuration(0.2, animations: {
            self.tipLabel.alpha = 0.0
            self.plusLabel.alpha = 0.0
            self.totalLabel.alpha = 0.0
            self.equalsLabel.alpha = 0.0
        }, completion: nil)
    }
}


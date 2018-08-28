//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit



class WelcomeViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        var date = Date()
       // sleep(3)
         var date2 = Date()
        var x:Bool = (date2.compare(date)) == ComparisonResult.orderedAscending
        var f:[Date] = [date2,date]
        f.sort { (date1, date2) -> Bool in
           return (date1.compare(date2)) == ComparisonResult.orderedAscending
        }


    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//
//  ViewController.swift
//  Simple Drawing App
//
//  Created by Natasha Martinez on 2/3/17.
//  Copyright © 2017 Natasha Marr Publishing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedPlay(_ sender: Any) {
        performSegue(withIdentifier: "goToDraw", sender: nil)
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
        
    }
}


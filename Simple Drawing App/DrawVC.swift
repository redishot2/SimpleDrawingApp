//
//  DrawVC.swift
//  Simple Drawing App
//
//  Created by Natasha Martinez on 2/6/17.
//  Copyright © 2017 Natasha Marr Publishing. All rights reserved.
//

import UIKit

class DrawVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var lastPoint: CGPoint!
    var isSwiping: Bool!
    var isUnsavedData: Bool = false
    
    var red:   CGFloat!
    var green: CGFloat!
    var blue:  CGFloat!
    var colors = ["black", "white", "red", "blue", "green"]
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the color picker
        self.colorPicker.delegate   = self
        self.colorPicker.dataSource = self
        
        // Create the base colors (for first in color picker)
        self.createDrawColor(colorName: self.colors[0])
        
        // Make sure the back button starts on back
        self.backButton.title = "Back"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDrawColor(colorName: String) {
        switch colorName {
            case "black":
                self.createDrawColor(redValue: 0, greenValue: 0, blueValue: 0)
                break
                
            case "white":
                self.createDrawColor(redValue: 255, greenValue: 255, blueValue: 255)
                break
                
            case "red":
                self.createDrawColor(redValue: 255, greenValue: 0, blueValue: 0)
                break
                
            case "green":
                self.createDrawColor(redValue: 0, greenValue: 255, blueValue: 0)
                break
                
            case "blue":
                self.createDrawColor(redValue: 0, greenValue: 0, blueValue: 255)
                break
                
            default:
                print("ERROR: Cannot support color \(colorName).")
                self.createDrawColor(redValue: 0, greenValue: 0, blueValue: 0)
        }
    }
    
    func createDrawColor(redValue: Int, greenValue: Int, blueValue: Int) {
        self.red   = (CGFloat(redValue)   / 255.0)
        self.green = (CGFloat(greenValue) / 255.0)
        self.blue  = (CGFloat(blueValue)  / 255.0)
    }
    
    ///////////////////////////////////  NAV BAR METHODS  ///////////////////////////////////
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        if (self.isUnsavedData) {
            self.imageView.image = UIImage()
            
            self.backButton.title = "Back"
            self.isUnsavedData = false
        }
        else {
            performSegue(withIdentifier: "backToMainMenu", sender: nil)
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard self.isUnsavedData else {
            return
        }
        
        if let myImage = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(myImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            self.backButton.title = "Back"
            self.isUnsavedData = false
        }
    }
    
    ///////////////////////////////////  DRAWING METHODS  ///////////////////////////////////
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSwiping = false
        
        if let touch = touches.first {
            self.lastPoint = touch.location(in: self.imageView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSwiping = true
        
        self.isUnsavedData = true
        self.backButton.title = "Restart"
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: imageView)
            UIGraphicsBeginImageContext(self.imageView.frame.size)
            self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
            
            if let context = UIGraphicsGetCurrentContext() {
                
                context.move(to: lastPoint)
                context.addLine(to: currentPoint)
                context.setLineCap(CGLineCap.round)
                context.setLineWidth(9.0)
                context.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                context.strokePath()
                
                self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            }
            
            UIGraphicsEndImageContext()
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!self.isSwiping) {
            UIGraphicsBeginImageContext(self.imageView.frame.size)
            
            self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.size.width, height: self.imageView.frame.size.height))
            
            if let context = UIGraphicsGetCurrentContext() {
                
                context.setLineCap(CGLineCap.round)
                context.setLineWidth(9.0)
                context.setStrokeColor(red: self.red, green: self.green, blue: self.blue, alpha: 1)
                context.move(to: self.lastPoint)
                context.addLine(to: self.lastPoint)
                context.strokePath()
                
                self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
        }
    }
    
    ///////////////////////////////////  COLOR PICKER METHODS  ///////////////////////////////////
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.createDrawColor(colorName: self.colors[row])
    }
}






























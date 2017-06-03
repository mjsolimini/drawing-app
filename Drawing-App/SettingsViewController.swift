//
//  SettingsViewController.swift
//  Drawing-App
//
//  Created by Michael Solimini on 3/4/17.
//  Copyright © 2017 Alpha Dev. All rights reserved.
//

import UIKit

protocol SettingsVCDelegate:class {
    func settingsViewControllerDidFinish(_ settingsVC:SettingsViewController)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var BrushSizeLBL: UILabel!
    @IBOutlet weak var OpacityLBL: UILabel!
    @IBOutlet weak var RedLBL: UILabel!
    @IBOutlet weak var GreenLBL: UILabel!
    @IBOutlet weak var BlueLBL: UILabel!
    @IBOutlet weak var RedSlider: UISlider!
    @IBOutlet weak var GreenSlider: UISlider!
    @IBOutlet weak var BlueSlider: UISlider!
    
    var red:CGFloat! = 0.0
    var green:CGFloat! = 0.0
    var blue:CGFloat! = 0.0
    var brushSize: CGFloat = 5.0
    var opacityValue: CGFloat = 1.0
    
    var delegate:SettingsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawPreview(red: red, green: green, blue: blue)
        RedSlider.value = Float(red)
        RedLBL.text = String(Int(RedSlider.value*255))
        
        GreenSlider.value = Float(green)
        GreenLBL.text = String(Int(GreenSlider.value*255))
        
        BlueSlider.value = Float(blue)
        BlueLBL.text = String(Int(BlueSlider.value*255))
    }

    
    @IBAction func BackBtnPressed(_ sender: Any) {
        if delegate != nil {
            delegate?.settingsViewControllerDidFinish(self)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func BrushSizeChanged(_ sender: Any) {
        let slider = sender as! UISlider
        brushSize = CGFloat(slider.value)
        drawPreview(red: red, green: green, blue: blue)
    }
    @IBAction func OpacityChanged(_ sender: Any) {
        let slider = sender as! UISlider
        opacityValue = CGFloat(slider.value)
        drawPreview(red: red, green: green, blue: blue)
    }
    @IBAction func GreenChanged(_ sender: Any) {
        let slider = sender as! UISlider
        green = CGFloat(slider.value)
        drawPreview(red: red, green: green, blue: blue)
        GreenLBL.text = "\(Int(slider.value*255))"
    }
    @IBAction func BlueChanged(_ sender: Any) {
        let slider = sender as! UISlider
        blue = CGFloat(slider.value)
        drawPreview(red: red, green: green, blue: blue)
        BlueLBL.text = "\(Int(slider.value*255))"
    }
    @IBAction func RedChanged(_ sender: Any) {
        let slider = sender as! UISlider
        red = CGFloat(slider.value)
        drawPreview(red: red, green: green, blue: blue)
        RedLBL.text = "\(Int(slider.value*255))"
    }
    
    func drawPreview (red:CGFloat,green:CGFloat,blue:CGFloat) {
        UIGraphicsBeginImageContext(Image.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        context?.setLineWidth(brushSize)
        context?.setLineCap(CGLineCap.round)
        context?.move(to: CGPoint(x: 70, y: 70))
        context?.addLine(to: CGPoint(x: 70, y:70))
        context?.strokePath()
        Image.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    

    
}

//
//  ViewController.swift
//  Drawing-App
//
//  Created by Michael Solimini on 3/4/17.
//  Copyright © 2017 Alpha Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var RedColorBtn: UIButton!
    @IBOutlet weak var GreenColorBtn: UIButton!
    @IBOutlet weak var BlueColorBtn: UIButton!
    @IBOutlet weak var PinkColorBtn: UIButton!
    @IBOutlet weak var YellowColorBtn: UIButton!
    @IBOutlet weak var TealColorBtn: UIButton!
    @IBOutlet weak var WhiteColorBtn: UIButton!
    @IBOutlet weak var BlackColorBtn: UIButton!
    
    
    @IBOutlet weak var ToolIcon: UIButton!
    var LastPoint = CGPoint.zero
    var Swiped = false
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var brushSize: CGFloat = 5.0
    var opacityValue: CGFloat = 1.0
    
    var tool:UIImageView!
    var isDrawing = true
    var selectedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tool = UIImageView()
        tool.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 38, height: 38)
        tool.image = #imageLiteral(resourceName: "paintBrush")
        self.view.addSubview(tool)
        
        RedColorBtn.layer.cornerRadius = 10.0
        GreenColorBtn.layer.cornerRadius = 10.0
        BlueColorBtn.layer.cornerRadius = 10.0
        PinkColorBtn.layer.cornerRadius = 10.0
        YellowColorBtn.layer.cornerRadius = 10.0
        TealColorBtn.layer.cornerRadius = 10.0
        WhiteColorBtn.layer.cornerRadius = 10.0
        BlackColorBtn.layer.cornerRadius = 10.0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            Swiped = false
            LastPoint = touch.location(in: self.view)
        }
    }
    
    func DrawLines(fromPoint:CGPoint, toPoint:CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        ImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        var context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        tool.center = toPoint
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        context?.strokePath()
        ImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            Swiped = true
            var currentPoint = touch.location(in: self.view)
            DrawLines(fromPoint: LastPoint, toPoint: currentPoint)
            LastPoint = currentPoint
        }
        
}
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !Swiped {
            DrawLines(fromPoint: LastPoint, toPoint: LastPoint)
        }
    }
    @IBAction func ColorsPicked(_ sender: Any) {
        if (sender as AnyObject).tag == 0 {
            (red,green,blue) = (1,0,0)
        } else if (sender as AnyObject).tag == 1 {
            (red,green,blue) = (0,1,0)
        } else if (sender as AnyObject).tag == 2 {
            (red,green,blue) = (0,0,1)
        } else if (sender as AnyObject).tag == 3 {
            (red,green,blue) = (1,0,1)
        } else if (sender as AnyObject).tag == 4 {
            (red,green,blue) = (1,1,0)
        } else if (sender as AnyObject).tag == 5 {
            (red,green,blue) = (0,1,1)
        } else if (sender as AnyObject).tag == 6 {
            (red,green,blue) = (1,1,1)
        } else if (sender as AnyObject).tag == 7 {
            (red,green,blue) = (0,0,0)
        }
    }
    
    @IBAction func ResetBtn(_ sender: Any) {
        self.ImageView.image = nil
    }
    @IBAction func SaveBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Pick your option", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Pick an image", style: .default, handler: { (_) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Save your drawing", style: .default, handler: { (_) in
            if let image = self.ImageView.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func EraseBtn(_ sender: Any) {
        if (isDrawing) {
            (red,green,blue) = (1,1,1)
            tool.image = #imageLiteral(resourceName: "EraserIcon")
            ToolIcon.setImage(#imageLiteral(resourceName: "paintBrush"), for: .normal)
        } else {
            (red,green,blue) = (0,0,0)
            tool.image = #imageLiteral(resourceName: "paintBrush")
            ToolIcon.setImage(#imageLiteral(resourceName: "EraserIcon"), for: .normal)
        }
        
        isDrawing = !isDrawing
    }
    @IBAction func SettingsBtn(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let settingsVC = segue.destination as! SettingsViewController
        settingsVC.delegate = self
        settingsVC.red = red
        settingsVC.green = green
        settingsVC.blue = blue
        settingsVC.brushSize = brushSize
        settingsVC.opacityValue = opacityValue
    }
    


}

extension ViewController:UINavigationControllerDelegate, UIImagePickerControllerDelegate, SettingsVCDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.selectedImage = imagePicked
            self.ImageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func settingsViewControllerDidFinish(_ settingsVC: SettingsViewController) {
        self.red = settingsVC.red
        self.green = settingsVC.green
        self.blue = settingsVC.blue
        self.brushSize = settingsVC.brushSize
        self.opacityValue = settingsVC.opacityValue
    }
}


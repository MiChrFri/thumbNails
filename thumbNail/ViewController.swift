//
//  ViewController.swift
//  thumbNail
//
//  Created by Michael Frick on 24/07/15.
//  Copyright (c) 2015 Connected-Health. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var result:UIImage?
        
        let width:CGFloat = 10.0
        let height:CGFloat = 20.0
        
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "png")
        if let imageSource = CGImageSourceCreateWithURL(NSURL(fileURLWithPath: path!), nil) {
            result = createThumbnail(imageSource, thumbWidth: width, thumbHeight: height)
        }
        
        if result != nil {
            println("width: \(result!.size.width/UIScreen.mainScreen().scale)")
            println("height: \(result!.size.height/UIScreen.mainScreen().scale)")
            
            let iv = UIImageView(frame: CGRect(x: 10, y: 10, width: width, height: height))
            iv.image = result
            self.view.addSubview(iv)
        }
    }
    
    func createThumbnail(imageSource:CGImageSource, thumbWidth: CGFloat, thumbHeight: CGFloat) ->UIImage? {
        let thumbImage:CGImage!
        let thumbUI:UIImage!
        
        let scale = UIScreen.mainScreen().scale
        var maxSize:CGFloat = 0.0
        var crop = false
        
        // gets the size from the imageSource
        let origSize:CGSize = getIMGSourceSize(imageSource)
        
        if origSize.width >= thumbWidth * scale && origSize.height >= thumbHeight * scale {
            
            let cropRect:CGRect!
            
            if origSize.width > origSize.height{
                maxSize = origSize.width/origSize.height * thumbHeight
                //crop = true
                cropRect = CGRect(x: (maxSize - thumbWidth)/2, y: 0, width: thumbWidth * scale, height: thumbHeight * scale)
            }
            else {
                maxSize = origSize.height/origSize.width * thumbHeight
                
                cropRect = CGRect(x: 0.0, y: (maxSize - thumbHeight)/2, width: thumbWidth * scale, height: thumbHeight * scale)
            }
            
            let options = [
                kCGImageSourceShouldAllowFloat as String: true,
                kCGImageSourceCreateThumbnailFromImageAlways as String: true,
                kCGImageSourceThumbnailMaxPixelSize as String : maxSize * scale,
                kCGImageSourceCreateThumbnailFromImageIfAbsent as String : true
            ]
            thumbImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
            
            return UIImage(CGImage: CGImageCreateWithImageInRect(thumbImage!, cropRect)!)!
        }
        else {
            NSLog("You can't create a thumbnail which is bigger than the original image")
            return nil
        }
    }
    
    func getIMGSourceSize(imageSource: CGImageSource) ->CGSize {
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary
        let width = imageProperties[kCGImagePropertyPixelWidth] as! NSNumber
        let height = imageProperties[kCGImagePropertyPixelHeight] as! NSNumber
        
        let size = CGSize(width: CGFloat(width), height: CGFloat(height))
        return size
    }
}


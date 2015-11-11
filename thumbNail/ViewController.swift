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
        self.view.backgroundColor = UIColor.whiteColor()
        
        var result:UIImage?
        
        var width:CGFloat = 50.0
        var height:CGFloat = 200.0
        
        
        let resourse = NSBundle.mainBundle().pathForResource("test", ofType: "png")
        let fileURL = NSURL(fileURLWithPath: resourse!)

        result = thumbnailFromUrl(fileURL, thumbWidth: width, thumbHeight: height)
            
        if result != nil {
            let iv = UIImageView(frame: CGRect(x: 10, y: 10, width: width, height: height))
            iv.image = result
            self.view.addSubview(iv)
        }

        
        width = 50.0
        height = 200.0

        if let imageSource = CGImageSourceCreateWithURL(NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("test", ofType: "png")!), nil) {
            
            result = createThumbnail(imageSource, thumbWidth: width, thumbHeight: height)
            
            if result != nil {
                
                
                
                let iv2 = UIImageView(frame: CGRect(x: 10, y: 300, width: width, height: height))
                iv2.image = result
                self.view.addSubview(iv2)
            }
        }
        else {
            print("WHAAAAAAT")
        }
    }
    
    func thumbnailFromUrl(filePath: NSURL, thumbWidth: CGFloat, thumbHeight: CGFloat) ->UIImage? {
        if let imageSource = CGImageSourceCreateWithURL(filePath, nil) {
            if let thumb = createThumbnail(imageSource, thumbWidth: thumbWidth, thumbHeight: thumbHeight) {
                return thumb
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
        
    }
    
    func createThumbnail(imageSource:CGImageSource, thumbWidth: CGFloat, thumbHeight: CGFloat) ->UIImage? {
        let thumbUI:UIImage!
        let scale = UIScreen.mainScreen().scale
        
        var maxSize:CGFloat = 0.0
        var orientationPortrait:Bool {return thumbHeight >= thumbWidth}
        var newWidth = thumbWidth * scale
        var newHeight = thumbHeight * scale
        
        // gets the size from the imageSource
        let origSize:CGSize = getImgSourceSize(imageSource)!
        let aspectRatio = origSize.width/origSize.height
        
        if orientationPortrait {
            if thumbHeight * scale > origSize.height {
                newHeight = origSize.height
                newWidth = newHeight * thumbWidth/thumbHeight
            }
        }
        else {
            if thumbWidth * scale > origSize.width {
                newWidth = origSize.width
                newHeight = newWidth/(thumbWidth/thumbHeight)
            }
        }
        
        if origSize.width > origSize.height {
            maxSize = orientationPortrait ? newHeight * aspectRatio : newWidth
        }
        else {
            maxSize = orientationPortrait ? newHeight : newHeight * aspectRatio
        }

        let options = [
            kCGImageSourceShouldAllowFloat as String: true,
            kCGImageSourceCreateThumbnailFromImageAlways as String: true,
            kCGImageSourceThumbnailMaxPixelSize as String : maxSize,
            kCGImageSourceCreateThumbnailFromImageIfAbsent as String : true,
            kCGImageSourceCreateThumbnailWithTransform as String :true
        ]
        
        if let thumbImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) {
            let newSize = UIImage(CGImage: thumbImage).size
            
            if orientationPortrait {
                let cropRect = CGRect(x: (newSize.width-newWidth)/2, y: 0.0, width: newWidth, height: newHeight)
                print(cropRect)
                return UIImage(CGImage: CGImageCreateWithImageInRect(thumbImage, cropRect)!)
            }
            else {
                let cropRect = CGRect(x: 0.0, y: (newSize.height-newHeight)/2, width: newWidth, height: newHeight)
                print(cropRect)
                return UIImage(CGImage: CGImageCreateWithImageInRect(thumbImage, cropRect)!)            }
        }
        return nil
    }
    
    private func getImgSourceSize(imageSource: CGImageSource) ->CGSize? {
        if let imgProps = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
            let height = imgProps[kCGImagePropertyPixelHeight as String!] as! Int!
            let width = imgProps[kCGImagePropertyPixelWidth as String!] as! Int!
            
            if height == nil || width == nil {
                return CGSize(width: UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height)
            }
            else {
                return CGSize(width: width, height: height)
            }
        }
        else {
            return CGSize(width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        }
    }

}


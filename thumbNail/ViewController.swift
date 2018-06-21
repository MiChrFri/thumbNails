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
        self.view.backgroundColor = UIColor.red

        var result:UIImage?

        let outputSize = CGSize(width: 100, height: 200)

        let resourse = Bundle.main.path(forResource: "test", ofType: "png")
        let fileURL = NSURL(fileURLWithPath: resourse!)
        
        result = thumbnailFrom(path: fileURL, outputSize: outputSize)

        if result != nil {
            let iv = UIImageView(frame: CGRect(x: 10, y: 100, width: outputSize.width, height: outputSize.height))
            iv.image = result
            self.view.addSubview(iv)
        }
    }
    
    func thumbnailFrom(path filePath: NSURL, outputSize size: CGSize) -> UIImage? {
        if let imageSource = CGImageSourceCreateWithURL(filePath, nil) {
            return createThumbnail(imageSource: imageSource, withSize: size)
        }
        return nil
    }
    
    func createThumbnail(imageSource:CGImageSource, withSize size: CGSize) -> UIImage? {
        var maxSize:CGFloat = 0
        
        var newWidth = size.width * DeviceInfo.ScaleFactor
        var newHeight = size.height * DeviceInfo.ScaleFactor
        let origSize:CGSize = getImgSourceSize(imageSource: imageSource)!
        let aspectRatio = origSize.width/origSize.height
        
        if size.height * DeviceInfo.ScaleFactor > origSize.height {
            newHeight = origSize.height
            newWidth = newHeight * size.width/size.height
        }
        
        if origSize.width > origSize.height {
            maxSize = newHeight * aspectRatio
        } else {
            maxSize = newHeight
        }
        
        return createThumbImage(imageSource: imageSource, maxSize: maxSize, newWidth: newWidth, newHeight: newHeight)
    }
    
    private func createThumbImage(imageSource:CGImageSource, maxSize:CGFloat, newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        let options = [
            kCGImageSourceShouldAllowFloat as String: true,
            kCGImageSourceCreateThumbnailFromImageAlways as String: true,
            kCGImageSourceThumbnailMaxPixelSize as String : maxSize,
            kCGImageSourceCreateThumbnailFromImageIfAbsent as String : true,
            kCGImageSourceCreateThumbnailWithTransform as String :true
        ] as [String : Any]
    
        if let thumbImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
            let newSize = CGSize(width: thumbImage.width, height: thumbImage.height)

            let cropRect = CGRect(x: (newSize.width - newWidth)/2, y: 0.0, width: newWidth, height: newHeight)
    
            if let cgImage = thumbImage.cropping(to: cropRect) {
                let image = UIImage(cgImage: cgImage)
                return image
            } else {
                let cropRect = CGRect(x: 0.0, y: (newSize.height-newHeight)/2, width: newWidth, height: newHeight)
    
                if let cgImage = thumbImage.cropping(to: cropRect) {
                    let image = UIImage(cgImage: cgImage)
                    return image
                }
            }
        }
        return nil
    }
    

    func getImgSourceSize(imageSource: CGImageSource) -> CGSize? {
        
        if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? NSDictionary {
            if let width = imageProperties[kCGImagePropertyPixelWidth] as? Int,
                let height = imageProperties[kCGImagePropertyPixelHeight] as? Int {
                return CGSize(width: width, height: height)
            }
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    
}


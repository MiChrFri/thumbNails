# thumbNails
generates a thumbnailImage from a path in the desired resolution 

Just pass an pathURL and your desired height and width and you'll get an UIImage:

```swift
let path = NSBundle.mainBundle().pathForResource("test", ofType: "png")

if let imageSource = CGImageSourceCreateWithURL(NSURL(fileURLWithPath: path!), nil) {
result = createThumbnail(imageSource, thumbWidth: width, thumbHeight: height)
}
```
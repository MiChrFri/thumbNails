//
//  thumbNailTests.swift
//  thumbNailTests
//
//  Created by Michael Frick on 24/07/15.
//  Copyright (c) 2015 Connected-Health. All rights reserved.
//

import UIKit
import XCTest
import ImageIO

class thumbNailTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            let vc = ViewController()
            let path = NSBundle.mainBundle().pathForResource("test", ofType: "png")
            if let imageSource = CGImageSourceCreateWithURL(NSURL(fileURLWithPath: path!), nil) {
                vc.createThumbnail(imageSource, thumbWidth: 400, thumbHeight: 200)
            }
        }
    }
    
}

//
//  ViewController.swift
//  taskBattleship
//
//  Created by MacBook on 6/1/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import UIKit
import ImageIO
import CoreImage
import ImageCaptureCore

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array = [1,1,1,1,1,1,1,1,0,1,
                     0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,
                     0,1,1,0,0,0,1,1,0,1,
                     1,0,0,1,0,0,0,0,0,0,
                     1,0,0,1,0,0,0,1,1,0,
                     1,0,0,0,0,0,0,0,0,0,
                     0,0,1,1,0,0,0,0,0,1,
                     1,0,0,0,0,1,1,1,1,0] //100 Elements
        
        self.view.backgroundColor = .lightGray
        
        self.checkArray(array: array)
        
        createImage(width: 10, height: 10, from: array) { image, errorMessage in
            guard let image = image, errorMessage == nil else {
                print(errorMessage!)
                return
            }

            DispatchQueue.main.async {
                self.imageView.layer.magnificationFilter = .nearest
                self.imageView.image = image
            }
        }
    }
    
    fileprivate func checkArray(array: [Int]) {
        var arrayOfShips = [[Int]]()
        var index = 0
        var prevY = Int()
        var arrayOfX = [0,0,0,0,0,0,0,0,0,0]
        var counter = 0
        var lastElement = 0
        print(array)
        for element in array {
            print("Current element is \(element)")
            let y = Int(index/10)
            let x = index-(y*10)
            if element == 1 {
                if (prevY<y) {
                    print(arrayOfX)
                    print("\(prevY) is less then \(y+2)")
                    print("Current set of X is \(arrayOfX)")
                    lastElement = 0
                }
                arrayOfShips.append([x,y])
                if (arrayOfX[x] != 1 && lastElement != 1){
                    counter+=1
                }
                prevY = y
            }
            arrayOfX[x] = element
            lastElement = element
            
            print("Counted with index:\(index) \(counter) ships")
            index += 1
        }
        print("Counted \(counter) ships")
        print(arrayOfShips)
    }

    //https://stackoverflow.com/questions/40205830/how-to-create-an-image-pixel-by-pixel
    //USED & Modified this solution
    
    fileprivate func createImage(width: Int, height: Int, from array: [Int], completionHandler: @escaping (UIImage?, String?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let colorSpace       = CGColorSpaceCreateDeviceRGB()
            let bytesPerPixel    = 4
            let bitsPerComponent = 8
            let bytesPerRow      = bytesPerPixel * width
            let bitmapInfo       = RGBA32.bitmapInfo

            guard array.count == width * height else {
                completionHandler(nil, "Array size \(array.count) is incorrect given dimensions \(width) x \(height)")
                return
            }

            guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
                completionHandler(nil, "unable to create context")
                return
            }

            guard let buffer = context.data else {
                completionHandler(nil, "unable to get context data")
                return
            }

            let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

            for (index, string) in array.enumerated() {
                switch string {
                case 0: pixelBuffer[index] = .blue
                case 1: pixelBuffer[index] = .red
                default: completionHandler(nil, "Unexpected value: \(string)"); return
                }
            }

            let cgImage = context.makeImage()!

            let image = UIImage(cgImage: cgImage)

            completionHandler(image, nil)
        }

    }
}


//
//  ImageExtension.swift
//  Recipes
//
//  Created by Luan Damato on 16/10/25.
//

import UIKit

extension UIImage {
    
    /*
     Rotaciona a imagem
     */
    func image(withRotation radians: CGFloat) -> UIImage {
        let cgImage = self.cgImage!
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        
        return resultImage
    }
    
    func resize(maxWidthHeight : Double)-> UIImage? {
            
            let actualHeight = Double(size.height)
            let actualWidth = Double(size.width)
            var maxWidth = 0.0
            var maxHeight = 0.0
            
            if actualWidth > actualHeight {
                maxWidth = maxWidthHeight
                let per = (100.0 * maxWidthHeight / actualWidth)
                maxHeight = (actualHeight * per) / 100.0
            }else{
                maxHeight = maxWidthHeight
                let per = (100.0 * maxWidthHeight / actualHeight)
                maxWidth = (actualWidth * per) / 100.0
            }
            
            let hasAlpha = true
            let scale: CGFloat = 0.0
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
            self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            return scaledImage
        }
    
}

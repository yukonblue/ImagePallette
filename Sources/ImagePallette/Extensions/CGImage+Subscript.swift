//
//  CGImage+Subscript.swift
//  ImagePallette
//
//  Created by yukonblue on 08/12/2022.
//

import CoreGraphics

extension CGImage {
    subscript (x: Int, y: Int) -> CGColor? {
        guard x >= 0 && x < Int(self.width) && y >= 0 && y < Int(self.height),
            let provider = self.dataProvider,
            let providerData = provider.data,
            let data = CFDataGetBytePtr(providerData) else {
            return nil
        }

        let bitsPerComponent = self.bitsPerComponent
        let bitsPerPixel = self.bitsPerPixel
        let numberOfComponents = bitsPerPixel / bitsPerComponent

        guard numberOfComponents == 4 else {
            // We only support 4 channel images for now
            return nil
        }

        let pixelData = ((Int(self.width) * y) + x) * numberOfComponents

        let r = CGFloat(data[pixelData]) / 255.0
        let g = CGFloat(data[pixelData + 1]) / 255.0
        let b = CGFloat(data[pixelData + 2]) / 255.0
        let a = CGFloat(data[pixelData + 3]) / 255.0

        return CGColor(srgbRed: r, green: g, blue: b, alpha: a)
    }
}

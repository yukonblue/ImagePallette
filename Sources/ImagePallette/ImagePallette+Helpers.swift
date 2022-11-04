//
//  ImagePallette+Helpers.swift
//  ImagePallette
//
//  Created by yukonblue on 08/12/2022.
//

import CoreImage
import CoreGraphics
import UIKit
import SwiftUI

extension ImagePallette {

    public func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        self.context.createCGImage(inputImage, from: inputImage.extent)
    }

    public static func computePrimaryCGColor(forImagedNamed imageName: String) -> CGColor? {
        if let cgImage = UIImage(named: imageName)?.cgImage {
            if let outputCIImage = ImagePallette.shared.getCIImageOutput(cgImage: cgImage), let outputCGImage = ImagePallette.shared.convertCIImageToCGImage(inputImage: outputCIImage) {
                return outputCGImage[0, 0]
            }
        }
        return nil
    }

    public static func computePrimaryColor(forImagedNamed imageName: String, saturateColor: Bool = false) -> Color {
        if let primaryCGColor = Self.computePrimaryCGColor(forImagedNamed: imageName) {
            if saturateColor {
                let uiColor = UIColor(cgColor: primaryCGColor)
                let saturatedUIColor = uiColor.modified(withAdditionalHue: 0.0, additionalSaturation: 0.20, additionalBrightness: 0.1)
                return Color(saturatedUIColor.cgColor)
            }
            return Color(cgColor: primaryCGColor)
        }
        return .white
    }
}

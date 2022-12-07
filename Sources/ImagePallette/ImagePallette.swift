//
//  ImagePallette.swift
//  ImagePallette
//
//  Created by yukonblue on 08/12/2022.
//

import CoreImage
import CoreGraphics

public class ImagePallette {

    public static let shared = ImagePallette()

    let context: CIContext

    public init() {
        self.context = CIContext(options: [.useSoftwareRenderer: false])
    }

    deinit {
        self.context.clearCaches()
    }

    public func getCIImageOutput(cgImage: CGImage) -> CIImage? {
        let ciImage = CIImage(cgImage: cgImage)

        // https://cifilter.io/CIKMeans/
        guard let kMeansFilter = CIFilter(name: "CIKMeans") else {
            return nil
        }

        kMeansFilter.setValue(ciImage, forKey: kCIInputImageKey)
        kMeansFilter.setValue(CIVector(cgRect: ciImage.extent), forKey: "inputExtent")
        kMeansFilter.setValue(1, forKey: "inputCount")
        kMeansFilter.setValue(1, forKey: "inputPasses")
        kMeansFilter.setValue(NSNumber(value: true), forKey: "inputPerceptual")
        kMeansFilter.setValue([CIColor(red: 1, green: 1, blue: 1)], forKey: "inputMeans")

        return kMeansFilter.outputImage
    }
}

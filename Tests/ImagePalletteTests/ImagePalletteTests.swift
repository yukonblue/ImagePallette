//
//  ImagePalletteTests.swift
//  ImagePallette
//
//  Created by yukonblue on 08/30/2022.
//

import Foundation
import CoreGraphics
import UIKit
import CoreServices
import UniformTypeIdentifiers

import XCTest
@testable import ImagePallette

class ImagePalletteTests: XCTestCase {

    func testImagePalletteOnRGBAImageWithPremultipliedAlpha() throws {
        let width = 64
        let height = 64
        let numberOfComponents = 4

        let context = try XCTUnwrap(self.createCGContext(width: width,
                                                         height: height,
                                                         numberOfComponents: numberOfComponents,
                                                         colorspaceName: CGColorSpace.sRGB,
                                                         bitmapInfo: CGImageAlphaInfo.premultipliedLast))

        try self._testAfterDrawing(inContext: context)
    }

    func testImagePalletteOnGenericRGBLinearImage() throws {
        let width = 64
        let height = 64
        let numberOfComponents = 4

        let context = try XCTUnwrap(self.createCGContext(width: width,
                                                         height: height,
                                                         numberOfComponents: numberOfComponents,
                                                         colorspaceName: CGColorSpace.genericRGBLinear,
                                                         bitmapInfo: CGImageAlphaInfo.noneSkipLast))

        try self._testAfterDrawing(inContext: context)
    }

    func testImagePalletteOnSingleChannelGenericGrayscaleImage() throws {
        let width = 64
        let height = 64
        let numberOfComponents = 1

        let context = try XCTUnwrap(self.createCGContext(width: width,
                                                         height: height,
                                                         numberOfComponents: numberOfComponents,
                                                         colorspaceName: CGColorSpace.genericGrayGamma2_2,
                                                         bitmapInfo: CGImageAlphaInfo.none))

        try self._testAfterDrawing(inContext: context)
    }

    func testImagePalletteOnDoubleChannelGenericGrayscaleImage() throws {
        let width = 64
        let height = 64
        let numberOfComponents = 2

        let context = try XCTUnwrap(self.createCGContext(width: width,
                                                         height: height,
                                                         numberOfComponents: numberOfComponents,
                                                         colorspaceName: CGColorSpace.linearGray,
                                                         bitmapInfo: CGImageAlphaInfo.premultipliedLast))

        try self._testAfterDrawing(inContext: context)
    }

    private func createCGContext(width: Int, height: Int, numberOfComponents: Int, colorspaceName: CFString, bitmapInfo: CGImageAlphaInfo) -> CGContext? {
        let bitsPerComponent = 8
        let bytesPerPixel = (bitsPerComponent * numberOfComponents + 7) / 8
        let bytesPerRow = bytesPerPixel * width
        let bitmapByteCount = bytesPerRow * height
        let bitmapData: UnsafeMutablePointer<UInt8> = .allocate(capacity: bitmapByteCount)
        defer {
            bitmapData.deallocate()
        }
        bitmapData.initialize(repeating: 0, count: bitmapByteCount)

        return CGContext(data: bitmapData,
                         width: width,
                         height: height,
                         bitsPerComponent: bitsPerComponent,
                         bytesPerRow: bytesPerRow,
                         space: CGColorSpace(name: colorspaceName)!,
                         bitmapInfo: bitmapInfo.rawValue)
    }

    func _testAfterDrawing(inContext context: CGContext) throws {
        // TODO: This fails on real device for some reason ...
        #if targetEnvironment(simulator)
        // Draw in context
        let color: CGColor = UIColor(hue: 0.7, saturation: 0.8, brightness: 1.0, alpha: 1.0).cgColor

        context.setStrokeColor(color)
        context.setLineCap(CGLineCap.square)
        context.setLineWidth(15)

        context.move(to: CGPoint(x: 20.0, y: 20.0))
        context.addLine(to: CGPoint(x: 30.0, y: 30.0))
        context.strokePath()

        let cgImage = try XCTUnwrap(context.makeImage())

        // Save to file
        #if DEBUG
        let destinationURL = try XCTUnwrap(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("output.png"))

        print(destinationURL)

        let destination = try XCTUnwrap(CGImageDestinationCreateWithURL(destinationURL as CFURL,
                                                                        UTType.png.identifier as CFString,
                                                                        1,
                                                                        nil))

        CGImageDestinationAddImage(destination, cgImage, nil)
        CGImageDestinationFinalize(destination)
        #endif

        // Create image pallette and perform computation
        let imagePallette = ImagePallette()

        let outputCIImage = try XCTUnwrap(imagePallette.getCIImageOutput(cgImage: cgImage))

        let outputCGImage = try XCTUnwrap(imagePallette.convertCIImageToCGImage(inputImage: outputCIImage))

        XCTAssertEqual(outputCGImage.width, 1)
        XCTAssertEqual(outputCGImage.height, 1)

//        let outputCGImageColor = try XCTUnwrap(outputCGImage[0, 0])

//        XCTAssertEqual(outputCGImageColor, color)
        #endif
    }
}

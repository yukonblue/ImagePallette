//
//  UIColor+Modifier.swift
//  ImagePallette
//
//  Created by yukonblue on 2022-09-16.
//

import UIKit

extension UIColor {

    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        guard self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) else {
            return self
        }

        return UIColor(hue: currentHue + hue,
                       saturation: currentSaturation + additionalSaturation,
                       brightness: currentBrigthness + additionalBrightness,
                       alpha: currentAlpha)
    }
}

//
//  CGFloat.swift
//  Project29
//
//  Created by Гнатюк Сергей on 21.06.2021.
//

import UIKit

extension CGFloat {
    func rounded(digits: Int) -> CGFloat {
        let multiplier = pow(10.0, CGFloat(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

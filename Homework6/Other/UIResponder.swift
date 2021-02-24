//
//  UIResponder.swift
//  Homework6
//
//  Created by spezza on 23.02.2021.
//

import UIKit

extension UIResponder {

    class var reuseIdOrClassName: String {
        String(describing: self)
    }
}

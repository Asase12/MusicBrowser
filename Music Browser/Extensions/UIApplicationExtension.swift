//
//  UIApplicationExtension.swift
//  Music Browser
//
//  Created by Angelina on 02.05.22.
//

import UIKit

extension UIApplication {

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

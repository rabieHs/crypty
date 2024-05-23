//
//  UIApplication.swift
//  test
//
//  Created by rabie houssaini on 26/5/2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

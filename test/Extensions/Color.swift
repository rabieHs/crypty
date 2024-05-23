//
//  Color.swift
//  Cypty
//
//  Created by rabie houssaini on 23/5/2024.
//

import Foundation
import SwiftUI

extension Color{
    static let theme = ColorTheme()
    static let luanch = LuanchTheme()
}

struct ColorTheme{
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct LuanchTheme {
    let accent = Color("LuanchAccentColor")
    let background = Color("LuanchBackgroundColor")
}

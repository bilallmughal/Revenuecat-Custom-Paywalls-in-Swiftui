//
//  View+Extensions.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


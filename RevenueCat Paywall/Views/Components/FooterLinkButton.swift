//
//  FooterLinkButton.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import SwiftUI

struct FooterLinkButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .underline()
                .foregroundStyle(Color.gray)
        }
    }
}

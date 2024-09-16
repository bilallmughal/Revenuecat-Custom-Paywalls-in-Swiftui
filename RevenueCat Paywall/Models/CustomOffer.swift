//
//  CustomOffer.swift
//  RevenueCat Paywall
//
//  Created by Macbook on 07/09/2024.
//

import Foundation
import RevenueCat

struct CustomOffer: Hashable, Identifiable {
    let id = UUID().uuidString
    let identifier: String
//    let title: String
//    let description: String
    let price: String
    let hasFreeTrial: Bool
    let pkg: Package
    var isSelected: Bool
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CustomOffer, rhs: CustomOffer) -> Bool {
        return lhs.id == rhs.id
    }
}

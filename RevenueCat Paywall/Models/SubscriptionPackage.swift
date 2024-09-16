//
//  SubscriptionPackage.swift
//  RevenueCat Paywall
//
//  Created by Macbook on 17/09/2024.
//

import Foundation

struct SubscriptionPackage: Codable {
    let content: String
    let identifier: String
}

struct SubscriptionModel: Codable {
    let headerImage: String
    let headerTitle: String
    let subtitle: String?
    let packages: [SubscriptionPackage]
}

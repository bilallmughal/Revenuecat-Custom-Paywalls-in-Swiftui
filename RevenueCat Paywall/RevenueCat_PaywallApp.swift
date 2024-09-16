//
//  RevenueCat_PaywallApp.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//
 
import SwiftUI

@main
struct RevenueCat_PaywallApp: App {

    @StateObject var subscriptionViewModel = SubscriptionViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(subscriptionViewModel)
        }
    }
}

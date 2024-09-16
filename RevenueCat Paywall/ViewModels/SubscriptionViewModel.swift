//
//  SubscriptionViewModel.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import Foundation
import SwiftUI
import RevenueCat

class SubscriptionViewModel: ObservableObject {
    
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    @Published var isSubscriptionActive = false
    @Published var showAlert: Bool = false
    @Published var showLoader: Bool = false

    @Published var showSecondaryPaywall: Bool = false
    @Published var showDefaultPaywall: Bool = false

    @Published var selectedOffer: CustomOffer?
    @Published var offers: [CustomOffer] = []
    @Published var onboardedOffers: [CustomOffer] = []
    
    @Published var isUserOnTrial: Bool = false
    @Published var remainingTrialDays: Int = 0

    var paywallData: SubscriptionModel?
    var secondaryPaywallData: SubscriptionModel?
    var discouttPaywallData: SubscriptionModel?
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Constants.apiKey)
        
        checkSubscriptionStatus()
        fetchOfferings()
    }
    
    // Check subscription status
    func checkSubscriptionStatus() {
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let customerInfo = customerInfo {
                let entitlements = customerInfo.entitlements.all[Constants.entitlementID]
                self.isSubscriptionActive = entitlements?.isActive == true
                self.checkTrialStatusAndTimeRemaining(entitlements: entitlements)
            } else if let error = error {
                self.showAlert = true
                self.alertMessage = error.localizedDescription
                self.alertTitle = "No Subscriptions Found"
                print("Error fetching customer info: \(error.localizedDescription)")
            }
        }
    }
    
    func checkTrialStatusAndTimeRemaining(entitlements: EntitlementInfo?) {
        guard let entitlement = entitlements else { return }
        if entitlement.periodType.rawValue == 2 {
            if let expirationDate = entitlement.expirationDate {
                let remainingTime = expirationDate.timeIntervalSince(Date())
                if remainingTime > 0 {
                    let daysRemaining = Int(remainingTime / (60 * 60 * 24))
                    self.remainingTrialDays = daysRemaining
                } else {
                    self.remainingTrialDays = 0
                }
            } else {
                self.remainingTrialDays = 0
            }
        }
        else {
            self.isUserOnTrial = false
            self.remainingTrialDays = 0
        }
    }

    
    // Restore purchases method
    func restorePurchases() {
        showLoader = true
        Purchases.shared.restorePurchases { (customerInfo, error) in
            self.showLoader = false
            if let customerInfo = customerInfo {
                self.isSubscriptionActive = customerInfo.entitlements.all[Constants.entitlementID]?.isActive == true
            } else if let error = error {
                self.alertTitle = "No Subscriptions Found"
                self.showAlert = true
                self.alertMessage = error.localizedDescription
            }
        }
    }
    
    //Get current offerings
    func fetchOfferings() {
        Purchases.shared.getOfferings { offerings, error in
            if let defaultOffers = offerings?.offering(identifier: "Default") {
                self.appendCustomOffers(from: defaultOffers, to: &self.offers)
                Task { await self.fetchPaywallMetaData(from: defaultOffers) }
            } else if let error = error {
                print("Error fetching offerings: \(error.localizedDescription)")
                self.alertTitle = "No Offers Available"
                self.showAlert = true
                self.alertMessage = error.localizedDescription
            }
            
            // Alternate Offerings
            if let alternateOffer = offerings?.offering(identifier: "AlternateOffering") {
                self.appendCustomOffers(from: alternateOffer, to: &self.onboardedOffers)
                Task { await self.fetchPaywallMetaData(from: alternateOffer) }
            }
        }
    }

    // Generic function to append offers to a specific array
    private func appendCustomOffers(from offering: Offering, to offers: inout [CustomOffer]) {
        var newOffers: [CustomOffer] = []
        for package in offering.availablePackages {
            let hasFreeTrial = package.storeProduct.introductoryDiscount?.price == 0
            let customOffer = CustomOffer(
                identifier: package.identifier,
                price: package.localizedPriceString,
                hasFreeTrial: hasFreeTrial,
                pkg: package,
                isSelected: hasFreeTrial
            )
            newOffers.append(customOffer)
        }
        
        newOffers.sort { $0.hasFreeTrial && !$1.hasFreeTrial }
        
        offers = newOffers
    }
    
    // Purchase package
    func purchasePackage(_ pkg: Package, completion: @escaping (Bool) -> Void) {
        showLoader = true
        Purchases.shared.purchase(package: pkg) { (transaction, customerInfo, error, userCancelled) in
            self.showLoader = false
            if let customerInfo = customerInfo, customerInfo.entitlements.all[Constants.entitlementID]?.isActive == true {
                self.isSubscriptionActive = true
                completion(true)
            } else {
                completion(false)
                if let error = error {
                    print("Error purchasing package: \(error.localizedDescription)")
                    self.alertTitle = "Error Purchasing Package"
                    self.showAlert = true
                    self.alertMessage = error.localizedDescription
                }
            }
            
            if userCancelled {
                self.showSecondaryPaywall = false
                self.showDefaultPaywall = false
            }
        }
    }
    
    
    //Get meta data based on offerings
    private func fetchPaywallMetaData(from offering: Offering) async {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: offering.metadata, options: .prettyPrinted)
            let model = try JSONDecoder().decode(SubscriptionModel.self, from: jsonData)
            
            DispatchQueue.main.async {
                switch offering.identifier {
                case "Default":
                    self.paywallData = model
                case "AlternateOffering":
                    self.secondaryPaywallData = model
                default:
                    break
                }
            }
        } catch {
            print("Error fetching paywall metadata for \(offering.identifier): \(error.localizedDescription)")
        }
    }
    
}

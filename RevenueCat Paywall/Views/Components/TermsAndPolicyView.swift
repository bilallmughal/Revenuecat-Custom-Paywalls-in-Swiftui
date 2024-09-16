//
//  TermsAndPolicyView.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import SwiftUI

struct TermsAndPolicyView: View {
    
    @EnvironmentObject var vm: SubscriptionViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            FooterLinkButton(title: "Terms of Use") {
                UIApplication.shared.open(Constants.termsURL)
            }
            
            FooterLinkButton(title: "Privacy Policy") {
                UIApplication.shared.open(Constants.privacyURL)
             }
            
            FooterLinkButton(title: "Restore") {
                vm.restorePurchases()
            }
        }
    }
}

#Preview {
    TermsAndPolicyView()
}

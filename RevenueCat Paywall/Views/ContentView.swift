//
//  ContentView.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct ContentView: View {
    
    @State var showDefaultPaywall = false

    @EnvironmentObject var vm: SubscriptionViewModel

    var body: some View {
        VStack {
            Button {
                vm.showDefaultPaywall = !vm.isSubscriptionActive
            } label: {
                let status = vm.isSubscriptionActive ?
                "Pro User" :
                "Default Custom Offerings"
                Text(status)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color.blue)
            .cornerRadius(10)
            .foregroundColor(Color.white)
            
            Button {
                vm.showSecondaryPaywall = !vm.isSubscriptionActive
            } label: {
                let status = vm.isSubscriptionActive ?
                "Pro User" :
                "Secondady Custom Offerings"
                Text(status)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color.green)
            .cornerRadius(10)
            .foregroundColor(Color.white)  
            
            Text("Please make sure to add Offerings in ReveneuCat Console and Use MetaData for the default tiles and cusotmizations")
                .font(.subheadline)
                .monospaced()
                .multilineTextAlignment(.center)
            
        }
        .padding()
        .fullScreenCover(isPresented: $vm.showDefaultPaywall) {
            CustomPaywall(isPaywallPresented: $vm.showDefaultPaywall)
        }
        
        .fullScreenCover(isPresented: $vm.showSecondaryPaywall) {
            SecondaryPaywall(isPaywallPresented: $vm.showSecondaryPaywall)
        }
    }
}

#Preview {
    ContentView()
}

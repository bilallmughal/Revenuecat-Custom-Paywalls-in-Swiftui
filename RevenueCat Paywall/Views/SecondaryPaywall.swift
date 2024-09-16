//
//  SecondaryPaywall.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import SwiftUI
import RevenueCat
import SDWebImageSwiftUI

struct SecondaryPaywall: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Binding var isPaywallPresented: Bool
    @EnvironmentObject var vm: SubscriptionViewModel
    @State private var remainingHeight: CGFloat = 0
    @State var toggleSwicth: Bool = true
    @State var isChecked: Bool = false
    
    let sizeY = UIScreen.main.bounds.height
    
    var body: some View {

        ZStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        HeaderView(headerImage: vm.secondaryPaywallData?.headerImage)
                            .frame(height: remainingHeight)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            
                            let title = vm.secondaryPaywallData?.headerTitle ?? "Get unlimited access to all features at Discounted Price"
                            
                            Text(title.uppercased())
                                .font(.title.bold())
                                .foregroundStyle(Color.white)
                            
                            Spacer().frame(height: 20)
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading) {
                            Button(action: {
                                isPaywallPresented = false
                            }, label: {
                                Text("Skip")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 40)
                                    .padding()
                            })
                            
                            Spacer()
                        }
                    }
                }
                .coordinateSpace(name: "SCROLL")
                
                VStack(alignment: .leading, spacing: 15) {
                        
                    if let offer = vm.onboardedOffers.first {
                        FreeTrialView(title: "Enable Free Trial", toggleSwitch: $toggleSwicth)
                            .onChange(of: toggleSwicth) { oldValue, newValue in
                                if newValue {
                                    selectOffer(offer)
                                } else {
                                    let secondOffer = vm.onboardedOffers[1]
                                    selectOffer(secondOffer)
                                }
                            }
                        
                        Divider().background(Color.red.opacity(1))

                    }
                    
                    ForEach(vm.onboardedOffers) { offer in
                        Button {
                            selectOffer(offer)
                        } label: {
                            let price = offer.price
                            
                            let title = vm.secondaryPaywallData?.packages.filter( {
                                $0.identifier == offer.identifier
                            }).first?.content
                            
                            CustomPackageButton(title: title ?? "",
                                                subTitle: "",
                                                price: price,
                                                isBestOffer: false,
                                                isChecked: .constant(offer.isSelected))
                        }
                        
                    }
                    
                    Button(action: {
                        if let offer = vm.selectedOffer?.pkg {
                            vm.purchasePackage(offer) { success in
                                if success {
                                    isPaywallPresented = false
                                }
                            }
                        }

                    }, label: {
                        
                        let title = vm.selectedOffer?.pkg.packageType == .lifetime ?
                        "Continue" :
                        "Subscribe & Continue"
                        
                        Text(title.uppercased())
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .foregroundStyle(.white)
                    })
                    
                    TermsAndPolicyView()
                }
                .background(GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            remainingHeight = sizeY - proxy.size.height - safeAreaInsets.top
                        }
                        .onChange(of: vm.onboardedOffers) { _, _ in
                            remainingHeight = sizeY - proxy.size.height - safeAreaInsets.top
                        }
                })
                
                .padding(.horizontal)
            }
            
            LoadingView(isLoading: $vm.showLoader, loadingText: .constant("Loading..."))
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.black)
        .alert(isPresented: $vm.showAlert) {
            Alert(title: Text(vm.alertTitle),
                  message: Text(vm.alertMessage),
                  dismissButton: .default(Text("Ok")))
        }
        .onChange(of: vm.onboardedOffers) { _, _ in
            vm.selectedOffer = vm.onboardedOffers.first
        }
    }
    
    private func selectOffer(_ selectedOffer: CustomOffer) {
        for index in vm.onboardedOffers.indices {
            vm.onboardedOffers[index].isSelected = false
        }
        if let index = vm.onboardedOffers.firstIndex(where: { $0.id == selectedOffer.id }) {
            vm.onboardedOffers[index].isSelected = true
            toggleSwicth = vm.onboardedOffers[index].hasFreeTrial
            vm.selectedOffer = vm.onboardedOffers[index]
        }
    }
}

struct SecondaryPaywall_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryPaywall(isPaywallPresented: .constant(false))
            .environmentObject(SubscriptionViewModel())
    }
}

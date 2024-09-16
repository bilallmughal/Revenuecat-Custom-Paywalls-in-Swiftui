//
//  CustomPackageButton.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import SwiftUI

struct CustomPackageButton: View {
    let title: String
    let subTitle: String
    let price: String
    let isBestOffer: Bool
        
    @Binding var isChecked: Bool
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.callout.bold())
                    .lineLimit(2)
                
                if !subTitle.isEmpty {
                    Text(subTitle)
                        .font(.footnote)
                }
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(width: 30)
            
            Text(price)
                .font(.callout.bold())
            
            Spacer()
            
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isChecked ? .blue : .gray)
                .font(.system(size: 20))
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isChecked ? Color.blue : Color.red, lineWidth: 1)
        )
        .if(isBestOffer, transform: { v in
            v
                .overlay(
                    HStack {
                        Spacer()
                        
                        Text("Best Value")
                            .padding(2)
                            .padding(.horizontal, 4)
                            .background(.red)
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .cornerRadius(4)
                            .offset(x: -10, y: -9)
                    },
                    alignment: .top
                )
        })
    }
}


#Preview {
    CustomPackageButton(title: "Enable Free Trial", subTitle: "Subtitle string", price: "$5.99", isBestOffer: true, isChecked: .constant(true))
        .padding()
}


struct Checkbox: View {
    @Binding var isChecked: Bool    
    var body: some View {
        HStack {
            Button(action: {
                self.isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .blue : .gray)
                    .font(.system(size: 20))
            }
        }
    }
}


struct FreeTrialView: View {
    let title: String
    @Binding var toggleSwitch: Bool
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.callout.bold())
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Toggle(isOn: $toggleSwitch, label: {
                Text("")
                    .frame(width: 1)
            })
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(toggleSwitch ? Color.green : Color.red, lineWidth: 1)
        )
    }
}

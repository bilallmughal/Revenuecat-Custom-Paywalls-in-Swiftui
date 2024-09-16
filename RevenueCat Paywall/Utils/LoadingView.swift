//
//  LoadingView.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import SwiftUI

public struct LoadingView: View {
    
    @Binding var isLoading: Bool
    @Binding var loadingText: String
    
    public init(isLoading: Binding<Bool>, loadingText: Binding<String>) {
        self._isLoading = isLoading
        self._loadingText = loadingText
    }

    // MARK: - Main rendering function
    public var body: some View {
        ZStack {
            if isLoading {
                Color.black.edgesIgnoringSafeArea(.all).opacity(0.8)
                ProgressView(loadingText)
                    .scaleEffect(1.1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white).padding()
                    .background(RoundedRectangle(cornerRadius: 10).opacity(0.7))
            }
        }.colorScheme(.light)
    }
}

//
//  HeaderView.swift
//  RevenueCat Paywall
//
//  Created by Muhammad Bilal on 12/09/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct HeaderView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    let headerImage: String?

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = size.height + minY
            
            Group {
                
                //MARK: - If metadata has headerImage then uncomment this code
//                if headerImage != nil {
//                    WebImage(url: URL(string: headerImage ?? ""))
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: size.width, height: height, alignment: .top)
//                        .overlay(gradientOverlay)
//                        .offset(y: -minY)
//                } else {
//                    Image("discounted-background")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: size.width, height: height, alignment: .top)
//                        .overlay(gradientOverlay)
//                        .offset(y: -minY)
//                }
                
                Image("discounted-background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: height, alignment: .top)
                    .overlay(gradientOverlay)
                    .offset(y: -minY)
            }
        }
    }
    
    private var gradientOverlay: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.clear, .black.opacity(1)], startPoint: .top, endPoint: .bottom)
        }
    }
}

//
//  InternetConnectionView.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import SwiftUI

struct InternetConnectionView: View {
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.0375) {
            Image(asset: Asset.Images.InternetConnection.wifi)
                .resizable()
                .scaledToFit()
                .frame(height: UIScreen.main.bounds.width * 0.55)
            
            Text("There is no internet connection")
                .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 20))
                .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
            
            Button { } label: {
                VStack {
                    Text("Try again")
                        .font(FontFamily.NunitoSans.semiBold.swiftUIFont(size: 18))
                        .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                }
                .frame(width: UIScreen.main.bounds.width * 0.388, height: UIScreen.main.bounds.height * 0.056)
                .background(Asset.Colors.yellow.swiftUIColor)
                .cornerRadius(UIScreen.main.bounds.height * 0.0375)
            }
        }
        .frame(maxHeight: .infinity)
        .offset(y: -UIScreen.main.bounds.height * 0.01)
    }
}

#Preview {
    InternetConnectionView()
}

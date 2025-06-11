//
//  MainView.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "Working with GET request")
            
            Spacer()
        }
    }
}

#Preview {
    MainView()
}

struct NavigationTitleView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 20))
                .foregroundStyle(Asset.Colors.darkBlack.swiftUIColor)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.0875)
        .background(Asset.Colors.yellow.swiftUIColor)
        .padding(.top, 0.5)
    }
}

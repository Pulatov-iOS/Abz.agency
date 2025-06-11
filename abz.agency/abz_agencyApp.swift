//
//  abz_agencyApp.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import SwiftUI

@main
struct abz_agencyApp: App {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                if viewModel.isConnected {
                    switch viewModel.selectedTab {
                    case .users:
                        MainView()
                    case .signUp:
                        EmptyView()
                    }
                    
                    TabBarView(selectedTab: $viewModel.selectedTab)
                } else {
                    InternetConnectionView()
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

enum TabBarType: CaseIterable {
    case users
    case signUp
    
    var imageActive: ImageAsset {
        switch self {
        case .users:
            Asset.Images.Main.TabBar.usersActive
        case .signUp:
            Asset.Images.Main.TabBar.signUpActive
        }
    }
    
    var imageNotActive: ImageAsset {
        switch self {
        case .users:
            Asset.Images.Main.TabBar.usersNotActive
        case .signUp:
            Asset.Images.Main.TabBar.signUpNotActive
        }
    }
    
    var title: String {
        switch self {
        case .users:
            "Users"
        case .signUp:
            "Sign up"
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: TabBarType
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabBarType.allCases, id: \.self) { item in
                TabBarButtonView(item: item, isActive: selectedTab == item)
                    .onTapGesture {
                        selectedTab = item
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.0875)
        .padding(.bottom, UIScreen.main.bounds.height * 0.013)
        .background(Asset.Colors.gray.swiftUIColor)
    }
}

struct TabBarButtonView: View {
    let item: TabBarType
    var isActive: Bool
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: UIScreen.main.bounds.width * 0.022) {
                Image(asset: isActive ? item.imageActive : item.imageNotActive)
                    .resizable()
                    .scaledToFit()
                    .frame(height: UIScreen.main.bounds.height * 0.02)
                
                Text(item.title)
                    .font(FontFamily.NunitoSans.semiBold.swiftUIFont(size: 16))
                    .foregroundStyle(isActive ? Asset.Colors.blue.swiftUIColor : Asset.Colors.black.swiftUIColor.opacity(0.6))
            }
            .offset(x: UIScreen.main.bounds.width * (item == .users ? 0.03 : -0.03))
        }
        .frame(width: UIScreen.main.bounds.width / 2)
    }
}

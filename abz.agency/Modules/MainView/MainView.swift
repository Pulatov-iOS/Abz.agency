//
//  MainView.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "Working with GET request")
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.users) { user in
                        MainUserItemView(user: user)
                            .onAppear {
                                if user == viewModel.users.last {
                                    viewModel.loadUsers()
                                }
                            }
                            .drawingGroup()
                    }

                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.top, UIScreen.main.bounds.height * 0.0375)
                    }
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.125)
            }
            .onAppear {
                if viewModel.users.isEmpty {
                    viewModel.loadUsers()
                }
            }
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

struct MainUserItemView: View {
    let user: User
    var body: some View {
        HStack(alignment: .top, spacing: UIScreen.main.bounds.width * 0.044) {
            AsyncImage(url: URL(string: user.photo)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Asset.Colors.yellow.swiftUIColor.opacity(0.2)
            }
            .frame(width: UIScreen.main.bounds.height * 0.078, height: UIScreen.main.bounds.height * 0.078)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(user.name)
                        .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 18))
                        .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                    
                    Spacer()
                }
                .padding(.bottom, UIScreen.main.bounds.height * 0.00625)
                
                Text(user.position)
                    .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 14))
                    .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.6))
                    .lineLimit(1)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.0125)
                
                Text(user.email)
                    .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 14))
                    .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                    .lineLimit(1)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.00625)
                
                Text(user.phone.formattedPhoneNumber())
                    .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 14))
                    .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                    .lineLimit(1)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.0375)
                
                Rectangle()
                    .fill(Asset.Colors.black.swiftUIColor.opacity(0.12))
                    .frame(height: 1)
            }
        }
        .padding(.top, UIScreen.main.bounds.height * 0.0375)
        .padding(.horizontal, UIScreen.main.bounds.width * 0.044)
    }
}

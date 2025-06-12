//
//  ResultView.swift
//  abz.agency
//
//  Created by Alexander on 12.06.25.
//

import SwiftUI

struct ResultView: View {
    @Binding var isSuccess: Bool
    @Binding var dismiss: Bool
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                VStack(spacing: UIScreen.main.bounds.height * 0.0375) {
                    Image(asset: isSuccess ? Asset.Images.Result.success : Asset.Images.Result.error)
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.width * 0.55)
                    
                    Text(isSuccess ? "User successfully registered" : "That email is already registered")
                        .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 20))
                        .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                    
                    Button {
                        dismiss.toggle()
                    } label: {
                        VStack {
                            Text(isSuccess ? "Got it" : "Try again")
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
            
            HStack {
                Spacer()
                
                Button {
                    dismiss.toggle()
                } label: {
                    Image(asset: Asset.Images.Result.close)
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height * 0.028)
                }
                .padding(.top, UIScreen.main.bounds.height * 0.02)
                .padding(.trailing, UIScreen.main.bounds.height * 0.025)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ResultView(isSuccess: .constant(true), dismiss: .constant(false))
}

//
//  SignUpView.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "Working with POST request")
            
            ScrollView {
                VStack(spacing: UIScreen.main.bounds.height * 0.01875) {
                    TextFieldView(text: $viewModel.name, isClear: $viewModel.isClear, placeholder: "Your name", errorText: viewModel.fieldErrors["name"] ?? "", showRedError: viewModel.fieldErrors["name"] != nil)
                    
                    TextFieldView(text: $viewModel.email, isClear: $viewModel.isClear, placeholder: "Email", errorText: viewModel.fieldErrors["email"] ?? "", showRedError: viewModel.fieldErrors["email"] != nil)
                    
                    TextFieldView(text: $viewModel.phone, isClear: $viewModel.isClear, isPhone: true, placeholder: "Phone", errorText: viewModel.fieldErrors["phone"] ?? "", showRedError: viewModel.fieldErrors["phone"] != nil)
                    
                    PositionButtonsView(selectedPosition: $viewModel.selectedPosition)
                        .padding(.bottom, UIScreen.main.bounds.height * 0.018)
                    
                    UploadImageButtonView(showRedError: viewModel.fieldErrors["photo"] != nil, errorText: viewModel.fieldErrors["photo"] ?? "") {
                        viewModel.showActionSheet.toggle()
                    }
                    
                    Button {
                        viewModel.signUp()
                    } label: {
                        VStack {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Text("Sign Up")
                                    .font(FontFamily.NunitoSans.semiBold.swiftUIFont(size: 18))
                                    .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(viewModel.activeButton() ? 0.87 : 0.48))
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.388, height: UIScreen.main.bounds.height * 0.075)
                        .background(viewModel.activeButton() ? Asset.Colors.yellow.swiftUIColor : Asset.Colors.mediumGray.swiftUIColor)
                        .cornerRadius(UIScreen.main.bounds.height * 0.075 / 2)
                    }
                    .disabled(viewModel.isLoading || !viewModel.activeButton())
                    .padding(.top, UIScreen.main.bounds.height * 0.00625)
                }
                .padding(.top, UIScreen.main.bounds.height * 0.05)
                .padding(.horizontal, UIScreen.main.bounds.width * 0.044)
                .padding(.bottom, UIScreen.main.bounds.height * 0.15)
            }
            .actionSheet(isPresented: $viewModel.showActionSheet) {
                ActionSheet(title: Text("Choose how you want to add a photo"), buttons: [
                    .default(Text("Camera")) {
                        viewModel.isCamera = true
                        viewModel.showImagePicker.toggle()
                    },
                    .default(Text("Gallery")) {
                        viewModel.isCamera = false
                        viewModel.showImagePicker.toggle()
                    },
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $viewModel.showImagePicker) {
                ImagePicker(sourceType: viewModel.isCamera ? .camera : .photoLibrary, selectedImage: $viewModel.photo)
                    .ignoresSafeArea()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .navigationDestination(isPresented: $viewModel.showSuccess) {
            ResultView(isSuccess: $viewModel.isSuccessResult, dismiss: $viewModel.showSuccess)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SignUpView()
}

struct TextFieldView: View {
    @Binding var text: String
    @Binding var isClear: Bool
    var isPhone: Bool = false
    let placeholder: String
    let errorText: String
    var showRedError: Bool
    @State private var showError: Bool = false
    @State private var tempText: String = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.00625) {
            ZStack(alignment: .leading) {
                if isPhone {
                    TextField("", text: Binding(
                        get: {
                            tempText.formatPhoneNumber()
                        },
                        set: { newValue in
                            tempText = newValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        }
                    ))
                    .padding(.vertical, UIScreen.main.bounds.height * 0.01875)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.044)
                    .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 16))
                    .foregroundStyle(showError ? .clear : Asset.Colors.black.swiftUIColor.opacity(0.87))
                    .background(Asset.Colors.white.swiftUIColor)
                    .cornerRadius(UIScreen.main.bounds.height * 0.00625)
                    .focused($focus)
                    .overlay(
                        RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.00625)
                            .stroke(showError ? Asset.Colors.red.swiftUIColor : Asset.Colors.darkGray.swiftUIColor, lineWidth: 1)
                    )
                    .keyboardType(.phonePad)
                } else {
                    TextField("", text: $tempText)
                        .padding(.vertical, UIScreen.main.bounds.height * 0.01875)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.044)
                        .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 16))
                        .foregroundStyle(showError ? .clear : Asset.Colors.black.swiftUIColor.opacity(0.87))
                        .background(Asset.Colors.white.swiftUIColor)
                        .cornerRadius(UIScreen.main.bounds.height * 0.00625)
                        .focused($focus)
                        .overlay(
                            RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.00625)
                                .stroke(showError ? Asset.Colors.red.swiftUIColor : Asset.Colors.darkGray.swiftUIColor, lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(placeholder)
                        .font(FontFamily.NunitoSans.regular.swiftUIFont(size: text.count > 0 ? (isPhone && text.filter { $0.isWholeNumber }.count == 0 ? 16 : 12) : 16))
                        .foregroundStyle(showError ? Asset.Colors.red.swiftUIColor : Asset.Colors.black.swiftUIColor.opacity(0.48))
                        .opacity(text.count > 0 ? (showError ? 1 : (isPhone && text.filter { $0.isWholeNumber }.count == 0 ? 1 : 0)) : 1)
                    
                    if showError && text.count > 0 {
                        Text(isPhone ? text.formatPhoneNumber() : text)
                            .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 16))
                            .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.044)
            }
            
            HStack {
                Text(isPhone ? (showError ? errorText : "+38 (XXX) XXX - XX - XX") : errorText)
                    .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 12))
                    .foregroundStyle(isPhone ? (showError ? Asset.Colors.red.swiftUIColor: Asset.Colors.black.swiftUIColor.opacity(0.6)) : Asset.Colors.red.swiftUIColor)
                
                Spacer()
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.044)
            .opacity(showError ? 1 : (isPhone ? 1 : 0))
        }
        .onChange(of: tempText) {
            guard isPhone else {
                text = tempText
                return
            }
            let digits = tempText.filter { $0.isWholeNumber }
            let limitedDigits = String(digits.prefix(12))

            let formatted = limitedDigits.formattedPhoneNumber()
            if tempText != formatted {
                tempText = formatted
            }
            text = "+\(digits)"
        }
        .onChange(of: focus) {
            showError = false
        }
        .onChange(of: isClear) {
            tempText = ""
            showError = false
        }
        .onChange(of: showRedError) {
            showError = showRedError
        }
        .onTapGesture {
            focus.toggle()
        }
    }
}

enum PositionType: Int, CaseIterable {
    case frontend
    case backend
    case designer
    case qa
    
    var title: String {
        switch self {
        case .frontend:
            "Frontend developer"
        case .backend:
            "Backend developer"
        case .designer:
            "Designer"
        case .qa:
            "QA"
        }
    }
}

struct PositionButtonsView: View {
    @Binding var selectedPosition: PositionType
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Select your position")
                .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 18))
                .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                .padding(.bottom, UIScreen.main.bounds.height * 0.014)
            
            ForEach(PositionType.allCases, id: \.self) { item in
                PositionItemView(item: item, isActive: selectedPosition == item) {
                    selectedPosition = item
                }
            }
        }
    }
}

struct PositionItemView: View {
    let item: PositionType
    var isActive: Bool
    let onTap: (() -> Void)
    var body: some View {
        HStack(spacing: 0) {
            Button {
                onTap()
            } label: {
                HStack(spacing: UIScreen.main.bounds.width * 0.022) {
                    Image(asset: isActive ? Asset.Images.SignUp.circleActive : Asset.Images.SignUp.circleNotActive)
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height * 0.06)
                    
                    Text(item.title)
                        .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 16))
                        .foregroundStyle(Asset.Colors.black.swiftUIColor.opacity(0.87))
                }
            }

            Spacer()
        }
    }
}
    
    
struct UploadImageButtonView: View {
    var showRedError: Bool
    var errorText: String
    @State private var showError: Bool = false
    let onTap: (() -> Void)
    
    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.00625) {
            HStack {
                Text("Upload your photo")
                    .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 16))
                    .foregroundStyle(showError ? Asset.Colors.red.swiftUIColor : Asset.Colors.black.swiftUIColor.opacity(0.48))
                    .padding(.leading, UIScreen.main.bounds.width * 0.044)
                
                Spacer()
                
                Button {
                    showError = false
                    onTap()
                } label: {
                    VStack {
                        Text("Upload")
                            .font(FontFamily.NunitoSans.semiBold.swiftUIFont(size: 16))
                            .foregroundStyle(Asset.Colors.darkBlue.swiftUIColor)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.24, height: UIScreen.main.bounds.height * 0.0635)
                    .background(Asset.Colors.black.swiftUIColor.opacity(0.001))
                }
                .padding(.trailing, UIScreen.main.bounds.width * 0.008)
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.0635)
            .overlay(
                RoundedRectangle(cornerRadius: UIScreen.main.bounds.height * 0.00625)
                    .stroke(showError ? Asset.Colors.red.swiftUIColor : Asset.Colors.darkGray.swiftUIColor, lineWidth: 1)
            )
            
            HStack {
                Text(errorText)
                    .font(FontFamily.NunitoSans.regular.swiftUIFont(size: 12))
                    .foregroundStyle(Asset.Colors.red.swiftUIColor)
                
                Spacer()
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.044)
            .opacity(showError ? 1 : 0)
        }
        .onChange(of: showRedError) {
            showError = showRedError
        }
    }
}

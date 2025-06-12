//
//  SignUpViewModel.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation
import Combine
import UIKit

final class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var selectedPosition: Position?
    @Published var photo: UIImage?
    
    @Published var showImagePicker: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var isCamera: Bool = false
    @Published var fieldErrors: [String: String] = [:] 

    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var serverMessage: String?
    @Published var positions: [Position] = []
    
    @Published var showSuccess: Bool = false
    @Published var isSuccessResult: Bool = false
    @Published var isClear: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchPositions()
    }

    func fetchPositions() {
        APIManager.shared.fetchPositions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let positions):
                    self?.positions = positions
                    self?.selectedPosition = positions.first
                case .failure(let error):
                    self?.serverMessage = "Failed to load positions: \(error.localizedDescription)"
                }
            }
        }
    }

    func signUp() {
        fieldErrors = [:]
        serverMessage = nil
        isSuccess = false

        guard let photo = photo else {
            fieldErrors["photo"] = "Photo is required."
            return
        }

        isLoading = true

        APIManager.shared.submitUser(
            name: name,
            email: email,
            phone: phone,
            positionId: selectedPosition?.id ?? 0,
            photo: photo
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    if response.success {
                        self?.isSuccess = true
                        self?.serverMessage = response.message
                        self?.resetForm()
                        self?.isSuccessResult = true
                        self?.showSuccess.toggle()
                    } else {
                        self?.serverMessage = response.message
                        self?.fieldErrors = response.fails?.mapValues { $0.first ?? "" } ?? [:]
                        if response.message == "User with this phone or email already exist" {
                            self?.isSuccessResult = false
                            self?.showSuccess.toggle()
                        }
                    }
                case .failure(let error):
                    self?.serverMessage = "Registration failed: \(error.localizedDescription)"
                }
            }
        }
    }

    private func resetForm() {
        name = ""
        email = ""
        phone = ""
        selectedPosition = nil
        photo = nil
        fieldErrors = [:]
        isClear.toggle()
    }

    func activeButton() -> Bool {
        return name.count != 0 && email.count != 0 && phone.count != 0 && photo != nil
    }
}

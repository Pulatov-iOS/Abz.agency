//
//  MainViewModel.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation
import Combine

final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isAllLoaded = false

    private var currentPage = 1
    private let itemsPerPage = 6
    private var totalPages = 1

    init() {
        loadUsers()
    }

    func loadUsers() {
        guard !isLoading && !isAllLoaded else { return }
        
        isLoading = true
        APIManager.shared.fetchUsers(page: currentPage, count: itemsPerPage) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.users.append(contentsOf: response.users)
                    self.totalPages = response.total_pages
                    self.currentPage += 1
                    if self.currentPage > self.totalPages {
                        self.isAllLoaded = true
                    }
                case .failure(let error):
                    print("Error loading users: \(error.localizedDescription)")
                }
            }
        }
    }
}

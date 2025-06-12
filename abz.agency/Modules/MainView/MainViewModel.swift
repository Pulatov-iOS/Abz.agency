//
//  MainViewModel.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isAllLoaded = false

    private var currentPage = 1
    private let itemsPerPage = 6
    private var totalPages = 1
    private var didLoadFromDB = false

    init() {
        loadInitialUsers()
    }

    func loadInitialUsers() {
           let cached = CoreDataManager.shared.fetchUsers()
           if !cached.isEmpty {
               users = cached.reversed()
               didLoadFromDB = true
           }

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
                       if self.currentPage == 1 {
                           CoreDataManager.shared.saveUsers(response.users)
                           self.users = response.users
                       } else {
                           self.users.append(contentsOf: response.users)
                       }

                       self.totalPages = response.total_pages
                       self.currentPage += 1
                       if self.currentPage > self.totalPages {
                           self.isAllLoaded = true
                       }
                   case .failure(let error):
                       print("API Error: \(error.localizedDescription)")
                   }
               }
           }
       }
}

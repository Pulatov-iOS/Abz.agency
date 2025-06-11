//
//  AppViewModel.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation
import Combine

final class AppViewModel: ObservableObject {
    @Published var selectedTab: TabBarType = .users
    @Published private(set) var isConnected: Bool = true
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        NetworkMonitor.shared.statusPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)
    }
}

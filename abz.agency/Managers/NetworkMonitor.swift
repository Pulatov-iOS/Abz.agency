//
//  NetworkMonitor.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation
import Network
import Combine

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private let statusSubject = CurrentValueSubject<Bool, Never>(true)
    var statusPublisher: AnyPublisher<Bool, Never> {
        statusSubject.eraseToAnyPublisher()
    }

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.statusSubject.send(path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}

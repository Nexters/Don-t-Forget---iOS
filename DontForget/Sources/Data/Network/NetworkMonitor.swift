//
//  NetworkMonitor.swift
//  DontForget
//
//  Created by 제나 on 3/4/24.
//

import Foundation
import Network

@Observable
final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}

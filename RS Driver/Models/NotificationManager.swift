//
//  NotificationManager.swift
//  RS Driver
//
//  Created by Filip Karas on 05/05/2023.
//

import Foundation

class NotificationManager : ObservableObject {
    
    static let shared = NotificationManager()
    
    @Published var selectedTab: Int = 1
    @Published var refreshChallenge: Bool = false
}

//
//  FreelancerPaymentTrackerApp.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//

import SwiftUI
import UserNotifications

@main
struct PaymentTrackerApp: App {
    // Use AppDelegate for notification handling
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    requestNotificationPermission()
                }
        }
    }

    /// Request notification permission from the user
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error.localizedDescription)")
            }
            if granted {
                print("Notifications allowed")
            } else {
                print("Notifications denied")
            }
        }
    }
}


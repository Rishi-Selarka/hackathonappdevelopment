//
//  Payment.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//
import Foundation

/// Enum to represent the status of a project
enum ProjectStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case paid = "Paid"
}

/// Struct to represent a payment record for a project
struct PaymentRecord: Codable, Identifiable {
    var id = UUID()
    var date: Date           // Date of the payment
    var amount: Double       // Payment amount
}

/// Struct to represent a project
struct Project: Identifiable, Codable {
    var id = UUID()                  // Unique identifier for the project
    var name: String                 // Project name
    var amount: Double               // Total project amount
    var status: ProjectStatus        // Project status (e.g., Pending, Paid)
    var dueDate: Date                // Due date for the project
    var paymentHistory: [PaymentRecord] // List of payment records for the project
    
    /// Computed property to calculate the remaining amount
    var remainingAmount: Double {
        let totalPaid = paymentHistory.reduce(0) { $0 + $1.amount }
        return max(amount - totalPaid, 0)
    }
    
    /// Computed property to determine if the project is overdue
    var isOverdue: Bool {
        status == .pending && dueDate < Date()
    }
}




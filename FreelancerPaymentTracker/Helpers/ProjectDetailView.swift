//
//  ProjectDetailView.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//
import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var projects: [Project]
    let project: Project

    var body: some View {
        VStack(spacing: 20) {
            Text(project.name)
                .font(.largeTitle)
                .padding()
            Text("Amount: \(project.amount, format: .currency(code: "USD"))")
            Text("Due Date: \(project.dueDate, style: .date)")
            Text("Status: \(project.status == .paid ? "Paid" : "Pending")")
                .foregroundColor(project.status == .paid ? .green : .orange)
            Spacer()
            Button("Delete Project") {
                deleteProject()
            }
            .foregroundColor(.red)
            .padding()
        }
    }

    private func deleteProject() {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            // Cancel the notification
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [project.id.uuidString])
            // Remove the project
            projects.remove(at: index)
        }
        dismiss() // Close the detail view
    }
}


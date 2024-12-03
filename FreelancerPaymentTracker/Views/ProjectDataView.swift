//
//  ProjectDetailView.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//

import UIKit
import SwiftUICore
import SwiftUI
import Charts

struct ProjectDataView: View {
    @Binding var project: Project

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Project: \(project.name)")
                    .font(.largeTitle)
                Text("Amount: $\(project.amount, specifier: "%.2f")")
                    .font(.title2)
                Text("Status: \(project.status.rawValue)")
                    .font(.headline)
                    .foregroundColor(project.status == .paid ? .green : .red)
                Text("Due Date: \(project.dueDate, style: .date)")
                    .font(.subheadline)

                if !project.paymentHistory.isEmpty {
                    Text("Payment History")
                        .font(.headline)
                    List {
                        ForEach(project.paymentHistory) { payment in
                            HStack {
                                Text(payment.date, style: .date)
                                Spacer()
                                Text("$\(payment.amount, specifier: "%.2f")")
                            }
                        }
                    }
                } else {
                    Text("No payment history available.")
                        .foregroundColor(.secondary)
                }

                Button(action: markAsPaid) {
                    Text("Mark as Paid")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle(project.name)
    }

    private func markAsPaid() {
        project.status = .paid
    }
}



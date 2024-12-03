//
//  PaymentHistoryView.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//

import SwiftUI
import Charts

struct PaymentHistoryView: View {
    @Binding var project: Project
    @State private var newPaymentAmount: String = ""
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            // Project Summary
            VStack(alignment: .leading, spacing: 10) {
                Text("Project: \(project.name)")
                    .font(.headline)
                Text("Total Amount: \(String(format: "%.2f", project.amount))")
                Text("Remaining Amount: \(String(format: "%.2f", project.remainingAmount))")
                    .foregroundColor(project.remainingAmount > 0 ? .red : .green)
                Text("Status: \(project.status.rawValue)")
                    .foregroundColor(project.status == .paid ? .green : .orange)
            }
            .padding()

            // Payment History
            List {
                Section(header: Text("Payment History")) {
                    if project.paymentHistory.isEmpty {
                        Text("No payments added yet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(project.paymentHistory) { payment in
                            HStack {
                                Text(payment.date, style: .date)
                                Spacer()
                                Text("$\(String(format: "%.2f", payment.amount))")
                                    .bold()
                            }
                        }
                        .onDelete(perform: deletePayment)
                    }
                }
            }

            // Add New Payment
            VStack {
                TextField("Enter payment amount", text: $newPaymentAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                Button(action: addPayment) {
                    Text("Add Payment")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Payment History")
        .alert("Invalid Input", isPresented: $showAlert, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("Please enter a valid payment amount.")
        })
    }

    // Add a new payment
    private func addPayment() {
        guard let paymentAmount = Double(newPaymentAmount), paymentAmount > 0 else {
            showAlert = true
            return
        }

        // Append the new payment to the payment history
        let newPayment = PaymentRecord(date: Date(), amount: paymentAmount)
        project.paymentHistory.append(newPayment)

        // Update the project status if the payment completes the total amount
        if project.remainingAmount <= 0 {
            project.status = .paid
        }

        // Clear the input field
        newPaymentAmount = ""
    }

    // Delete a payment
    private func deletePayment(at offsets: IndexSet) {
        project.paymentHistory.remove(atOffsets: offsets)

        // Recalculate project status after deletion
        if project.remainingAmount > 0 {
            project.status = .pending
        }
    }
}

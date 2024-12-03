//
//  AddProjectView.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//
import SwiftUI
import UserNotifications

struct AddProjectView: View {
    @Binding var projects: [Project]
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var dueDate: Date = Date()
    @State private var status: ProjectStatus = .pending
    @State private var showAlert: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }

                Section(header: Text("Status")) {
                    Picker("Status", selection: $status) {
                        ForEach(ProjectStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Project")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProject()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Invalid Input", isPresented: $showAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text("Please provide a valid name and amount.")
            })
        }
    }

    /// Save the project and schedule a notification if necessary
    private func saveProject() {
        guard let projectAmount = Double(amount), !name.isEmpty else {
            showAlert = true
            return
        }

        let newProject = Project(
            name: name,
            amount: projectAmount,
            status: status,
            dueDate: dueDate,
            paymentHistory: []
        )

        // Add the new project to the list
        projects.append(newProject)

        // Schedule a notification for the due date if the status is pending
        if status == .pending {
            scheduleNotification(for: newProject)
        }

        dismiss()
    }

    /// Schedule a notification for the project's due date
    private func scheduleNotification(for project: Project) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Project Due Reminder"
        content.body = "\(project.name) is due today!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: project.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(
            identifier: project.id.uuidString,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}


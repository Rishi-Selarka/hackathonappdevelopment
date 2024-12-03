//
//  ContentView.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//

import SwiftUI
import CoreData
import Foundation
import SwiftData

import UserNotifications

struct ContentView: View {
    @State private var projects: [Project] = [] // List of projects

    var body: some View {
        NavigationView {
            VStack {
                if projects.isEmpty {
                    Text("No projects available. Add a new project!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(projects) { project in
                            NavigationLink(destination: ProjectDetailView(projects: $projects, project: project)) {
                                ProjectRow(project: project)
                            }
                        }
                        .onDelete(perform: deleteProject) // Swipe-to-delete
                    }
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddProjectView(projects: $projects)) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    /// Delete project and cancel any pending notifications for it
    private func deleteProject(at offsets: IndexSet) {
        offsets.forEach { index in
            let project = projects[index]
            // Cancel the notification for the deleted project
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [project.id.uuidString])
        }
        // Remove the project from the list
        projects.remove(atOffsets: offsets)
    }
}


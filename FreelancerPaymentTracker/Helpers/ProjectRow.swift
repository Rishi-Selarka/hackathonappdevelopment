//
//  ProjectRow.swift
//  FreelancerPaymentTracker
//
//  Created by Rishi Selarka on 03/12/24.
//

import SwiftUI

struct ProjectRow: View {
    let project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.name)
                    .font(.headline)
                Text("Due: \(project.dueDate, style: .date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(project.status == .paid ? "Paid" : "Pending")
                .font(.subheadline)
                .foregroundColor(project.status == .paid ? .green : .orange)
        }
        .padding(.vertical, 8)
    }
}

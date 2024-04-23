//
//  test2.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/8/24.
//

import SwiftUI

struct test2: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List {
                ForEach(0..<5) { value in
                    NavigationLink(value: value) {
                        Text("Navigate to screen\(value)")
                    }
                }
            }
            .navigationTitle("Hello")
            .navigationDestination(for: Int.self) { value in
                VStack {
                    Text("Screen \(value)")
                    Button {
                        withAnimation {
                            columnVisibility = .doubleColumn
                        }
                    } label: {
                        Text("show sidebar")
                    }
                }
            }
        } detail: {
            Text("Choose one")
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    test2()
}

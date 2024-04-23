//
//  test.swift
//  Ajibeee
//
//  Created by Hossein Hajimirza on 4/8/24.
//

import SwiftUI

struct test: View {
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(0..<10) { item in
                    NavigationLink(value: item) {
                        Text("Navigate to \(item)")
                    }
                }
            }
            .navigationDestination(for: Int.self) { item in
                S2(item: item)
            }
            .navigationTitle("Title")
        }
    }
}

struct S2: View {
    let item: Int

    init(item: Int) {
        self.item = item
        print(item)
    }

    var body: some View {
        Text("page \(item)")
    }
}

#Preview {
    test()
}

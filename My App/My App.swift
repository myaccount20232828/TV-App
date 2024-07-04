import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            Form {
                Text("tvOS App!")
                    .foregroundColor(.red)
                Button {
                } label: {
                  Text("Test 2")
                }
            }
        }
    }
}

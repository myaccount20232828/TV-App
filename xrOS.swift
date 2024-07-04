import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            Form {
                Text("visionOS App!")
                    .foregroundColor(.indigo)
                Button {
                } label: {
                  Text("Test")
                }
            }
        }
    }
}

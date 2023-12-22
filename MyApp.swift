import SwiftUI

@main
struct MyApp: App {
    @State var Items: [String] = ["Sandboxed"]
    var body: some Scene {
        WindowGroup {
            Form {
                ForEach(Items, id: \.self) { Item in
                    Text(Item)
                }
            }
            .onAppear {
                do {
                    Items = try FileManager.default.contentsOfDirectory(atPath: "/var")
                } catch {
                    print(error)
                }
            }
        }
    }
}

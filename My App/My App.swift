import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                LogView()          
                Button {
                    print("tvOS App! \(Date())")
                } label: {
                    Label("TEST", systemImage: "apple.logo")
                        .font(.system(size: 20))
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: UIScreen.main.bounds.width - 80, height: 70)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)
            }
        }
    }
}

// Just use the same FD every time
let LogPipe = Pipe()

struct LogView: View {
    @State var LogItems: [LogItem] = []
    var body: some View {
        ScrollView {
            ScrollViewReader { scroll in
                VStack(alignment: .leading) {
                    ForEach(LogItems) { Item in
                        Text(Item.Message.lineFix())
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                        .foregroundColor(.white)
                        .id(Item.id)
                    }
                }
                .onChange(of: LogItems) { _ in
                    DispatchQueue.main.async {
                        scroll.scrollTo(LogItems.last?.id, anchor: .bottom)
                    }
                }
                .contextMenu {
                    Button {
                        var LogString = ""
                        for Item in LogItems {
                            LogString += Item.Message
                        }
                        UIPasteboard.general.string = LogString
                    } label: {
                        Label("Copy to clipboard", systemImage: "doc.on.doc")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 80, height: 300)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .onAppear {
            // This code runs every time the log gets updated
            LogPipe.fileHandleForReading.readabilityHandler = { FileHandle in
                if let LogString = String(data: FileHandle.availableData, encoding: .utf8) {
                    LogItems.append(LogItem(Message: LogString))
                }
            }
            // You only need to run these functions once, it just redirects the log FD to the custom one allowing you to read it.
            setvbuf(stdout, nil, _IONBF, 0)
            dup2(LogPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        }
    }
}

// TODO: Add color support for error or regular log messages
struct LogItem: Identifiable, Equatable {
    var id = UUID()
    var Message: String
}

extension String {
    // If last character is a new line remove it
    func lineFix() -> String {
        return String(self.last == "\n" ? String(self.dropLast()) : self)
    }
}

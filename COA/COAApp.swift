import SwiftUI
import SwiftData

@main
struct coaApp: App {
    @Environment(\.modelContext) private var context
    @Query private var items: [Item]
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}

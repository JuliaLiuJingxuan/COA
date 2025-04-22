import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                Tab("Home", systemImage: "house.circle.fill") {
                    HomeView()
                }
                Tab("Add", systemImage: "plus.circle.fill") {
                    AddView()
                }
                Tab("Add", systemImage: "chart.line.uptrend.xyaxis.circle.fill") {
                    StatisticView()
                }
                Tab("Profile", systemImage: "person.crop.circle.fill") {
                    ProfileView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

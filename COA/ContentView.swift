import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 400, height: 76)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                HStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 250, height: 56)
                        .background(.white)
                        .cornerRadius(16)
                    Spacer()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 56, height: 56)
                        .background(.white)
                        .cornerRadius(16)
                    Spacer()
                }
            }
            .frame(width: 390, height: 76)
            ScrollView {
                // Item data
            }
        }
    }
}

struct AddView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var newName: String = ""
    var body: some View {
        VStack {
            Text("Create New Item")
                .font(Font.custom("Inter", size: 24))
                .foregroundColor(.black)
                .frame(width: 192, height: 31, alignment: .topLeading)
            Spacer()
            TextField("Name of new Item...", text: $newName)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                .padding()
            Button("Add") {
                withAnimation {
                    let newItem = Item(name: newName)
                    modelContext.insert(newItem)
                }
            }
            List(items) {
                Text($0.name)
            }
        }
    }
}

struct StatisticView: View {
    var body: some View {
        Text("Statistic")
            .padding()
    }
}

struct ProfileView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
            Text("Name")
        }
            .padding()
    }
}

struct ContentView: View {
    var body: some View {
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

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

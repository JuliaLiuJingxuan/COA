import SwiftUI
import SwiftData

struct EditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var editedName: String
    @State private var editedProperty: String
    @State private var editedValue: String
    var item: Item
    init(item: Item) {
        self.item = item
        _editedName = State(initialValue: item.name)
        _editedProperty = State(initialValue: item.properties ?? "")
        _editedValue = State(initialValue: item.values ?? "")
    }
    var body: some View {
        VStack {
            TextField("Name", text: $editedName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Property", text: $editedProperty)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Value", text: $editedValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Save") {
                item.name = editedName
                item.properties = editedProperty.isEmpty ? nil : editedProperty
                item.values = editedValue.isEmpty ? nil : editedValue
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save item: \(error)")
                }
                dismiss()
            }
            .padding()
        }
        .navigationTitle("Edit Item")
    }
}

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var searchText: String = ""
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 400, height: 76)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                HStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 250, height: 56)
                            .background(.white)
                            .cornerRadius(16)
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            TextField("Search", text: $searchText)
                                .frame(width: 200)
                        }
                    }
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
                VStack(spacing: 5) {
                    ForEach(filteredItems) { item in
                        NavigationLink(destination: EditView(item: item)) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 300, height: 125)
                                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.09, green: 0.09, blue: 0.09), lineWidth: 1)
                                    )
                                VStack {
                                    Text(item.name)
                                    Text(item.properties ?? "")
                                    Text(item.values ?? "")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Home")
    }
}

struct AddView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var newName: String = ""
    @State private var newProperty: String = ""
    @State private var newValue: String = ""
    var body: some View {
        VStack {
            Spacer()
            Text("Create New Item")
                .font(Font.custom("Inter", size: 24))
                .foregroundColor(.black)
                .frame(width: 192, height: 31, alignment: .topLeading)
            Spacer()
            TextField("Name of new item...", text: $newName)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                .padding()
            TextField("Property...", text: $newProperty)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                .padding()
            TextField("Value...", text: $newValue)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                .padding()
            Button("Add") {
                let newItem = Item(name: newName, properties: newProperty.isEmpty ? nil : newProperty, values: newValue.isEmpty ? nil : newProperty)
                modelContext.insert(newItem)
                newName = ""
                newProperty = ""
                newValue = ""
            }
            List {
                ForEach(items) { item in
                    VStack {
                        HStack {
                            Text(item.name)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    modelContext.delete(item)
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print("Failed to delete item: \(error)")
                                    }
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }  
                        }
                    }
                }
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

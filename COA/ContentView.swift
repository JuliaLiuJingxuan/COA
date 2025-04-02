import SwiftUI
import SwiftData
import PhotosUI

struct EditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var editedName: String
    @State private var editedProperty: String
    @State private var editedValue: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    var item: Item
    init(item: Item) {
        self.item = item
        _editedName = State(initialValue: item.name)
        _editedProperty = State(initialValue: item.properties ?? "")
        _editedValue = State(initialValue: item.values ?? "")
        _selectedImage = State(initialValue: item.imageData != nil ? UIImage(data: item.imageData!) : nil)    }
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
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Button("Choose Image") {
                showImagePicker = true
            }
            .padding()
            Button("Save") {
                item.name = editedName
                item.properties = editedProperty.isEmpty ? nil : editedProperty
                item.values = editedValue.isEmpty ? nil : editedValue
                item.imageData = selectedImage?.jpegData(compressionQuality: 0.8)
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
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
                VStack(spacing: 10) {
                    ForEach(filteredItems) { item in
                        NavigationLink(destination: EditView(item: item)) {
                            HStack(alignment: .center, spacing: 15) {
                                if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 3)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                        .background(Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    if let property = item.properties {
                                        Text(property)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.98, green: 0.98, blue: 0.98))
                                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
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
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
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
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
                    .padding()
            }
            Button("Choose Image") {
                showImagePicker = true
            }
            .padding()
            Button("Add") {
                let newItem = Item(name: newName, properties: newProperty.isEmpty ? nil : newProperty, values: newValue.isEmpty ? nil : newValue, imageData: selectedImage?.jpegData(compressionQuality: 0.8))
                modelContext.insert(newItem)
                newName = ""
                newProperty = ""
                newValue = ""
                selectedImage = nil
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
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
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

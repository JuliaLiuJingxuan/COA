import SwiftUI
import SwiftData
import PhotosUI

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

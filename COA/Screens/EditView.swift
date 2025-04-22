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

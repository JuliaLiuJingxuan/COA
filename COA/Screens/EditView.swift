import SwiftUI
import SwiftData
import PhotosUI

struct EditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var editedName: String
    @State private var editedProperty: String
    @State private var editedValue: String
    @State private var editedPrice: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    var item: Item
    init(item: Item) {
        self.item = item
        _editedName = State(initialValue: item.name)
        _editedProperty = State(initialValue: item.properties ?? "")
        _editedValue = State(initialValue: item.values ?? "")
        _editedPrice = State(initialValue: item.price != nil ? String(format: "%.2f", item.price!) : "")
        _selectedImage = State(initialValue: item.imageData != nil ? UIImage(data: item.imageData!) : nil)
    }
    var body: some View {
        Form {
            Section(header: Text("Edit information")) {
                TextField("Name", text: $editedName)
                TextField("Property", text: $editedProperty)
                TextField("value", text: $editedValue)
                TextField("Price", text: $editedPrice)
                    .keyboardType(.decimalPad)
            }
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }
            
            Button("Choose Image") {
                showImagePicker = true
            }
            Button("Save") {
                let priceValue = editedPrice.isEmpty ? nil : Double(editedPrice)
                item.name = editedName
                item.properties = editedProperty.isEmpty ? nil : editedProperty
                item.values = editedValue.isEmpty ? nil : editedValue
                item.price = priceValue
                item.imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save item: \(error)")
                }
            }
        }
        .navigationTitle("Edit Item")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

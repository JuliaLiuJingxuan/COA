import SwiftUI
import SwiftData
import PhotosUI

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

#Preview {
    ProfileView()
        .modelContainer(for: Item.self, inMemory: true)
}

import SwiftUI
import SwiftData
import PhotosUI

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

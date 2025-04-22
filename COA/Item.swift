import Foundation
import SwiftUI
import SwiftData

@Model
class Item {
    @Attribute var name: String
    @Attribute var properties: String?
    @Attribute var values: String?
    @Attribute var price: Double?
    var imageData: Data?

    init(name: String, properties: String? = nil, values: String? = nil, price: Double? = nil, imageData: Data? = nil) {
        self.name = name
        self.properties = properties
        self.values = values
        self.price = price
        self.imageData = imageData
    }
}

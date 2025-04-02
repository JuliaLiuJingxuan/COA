import Foundation
import SwiftUI
import SwiftData

@Model
class Item {
    @Attribute var name: String
    @Attribute var properties: String?
    @Attribute var values: String?
    var imageData: Data?

    init(name: String, properties: String?, values: String?, imageData: Data? = nil) {
        self.name = name
        self.properties = properties
        self.values = values
        self.imageData = imageData
    }
}

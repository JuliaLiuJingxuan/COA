import Foundation
import SwiftUI
import SwiftData

@Model
class Item {
    @Attribute var name: String
    @Attribute var properties: String?
    @Attribute var values: String?

    init(name: String, properties: String?, values: String?) {
        self.name = name
        self.properties = properties
        self.values = properties
    }
}

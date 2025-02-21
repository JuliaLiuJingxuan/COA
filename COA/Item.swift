import Foundation
import SwiftUI
import SwiftData

@Model
class Item {
    var name: String
    var properties: String
//    var value: String
//    init(name: String, properties: String, value: String) {
//        self.name = name
//        self.properties = properties
//        self.value = value
//    }
    init(name: String, properties: String) {
        self.name = name
        self.properties = properties
    }
}

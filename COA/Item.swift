import Foundation
import SwiftUI
import SwiftData

@Model
class Item {
    var name: String
    init(name: String) {
            self.name = name
        }
}

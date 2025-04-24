
import Foundation

struct ItemModel: Identifiable, Codable {
    let id: String
    let title: String
    let isDone: Bool
    
    init(id: String = UUID().uuidString, title: String, isDone: Bool) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
    
    func updateItem() -> ItemModel {
        ItemModel(id: id, title: title, isDone: !isDone)
    }
}

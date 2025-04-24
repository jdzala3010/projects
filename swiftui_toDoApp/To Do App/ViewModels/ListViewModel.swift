
import Foundation

class ListViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    let key: String = "KEY"
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.object(forKey: key),
            let decodedData = try? JSONDecoder().decode([ItemModel].self, from: data as! Data) else { return }
        self.items = decodedData
    }
    
    func deteteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(indexSet: IndexSet, to: Int) {
        items.move(fromOffsets: indexSet, toOffset: to)
    }
    
    func addItem(title: String) {
        let newItem = ItemModel(title: title, isDone: false)
        items.insert(newItem, at: items.startIndex)
    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { item.id == $0.id }) {
            items[index] = item.updateItem()
            print("changed")
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: key)
        }
    }
}

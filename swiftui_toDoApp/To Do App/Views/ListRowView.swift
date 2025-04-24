
import SwiftUI

struct ListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        HStack {
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "checkmark.circle")
                .font(.title3)
                .foregroundStyle(item.isDone ? Color.green : Color.red)
            Text(item.title)
                .font(.title3)
        }
        .padding(.vertical, 7)
    }
}

#Preview {
    
    let item: ItemModel = ItemModel(title: "First Item", isDone: false)
    
    ListRowView(item: item)
}

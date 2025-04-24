

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                if listViewModel.items.isEmpty {
                    NoItemsView()
                } else {
                    List {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item)
                                .onTapGesture {
                                    listViewModel.updateItem(item: item)
                                }
                        }
                        .onDelete(perform: listViewModel.deteteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(.automatic)
                }
            }
            .navigationTitle("ToDo App📝")
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add") {
                        AddView()
                    }
                }
            }
        } // Nav End
    }
}

#Preview {
        ListView()
            .environmentObject(ListViewModel())
}

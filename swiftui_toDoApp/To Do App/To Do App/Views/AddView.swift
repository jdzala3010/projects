import SwiftUI

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textFieldText: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("add something here...", text: $textFieldText)
                    .padding()
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                
                Button {
                    showAlert =  ifTextAppropriate(title: textFieldText)
                }label: {
                    Text("SAVE")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                .alert(isPresented: $showAlert) {
                    customAlert()
                }
                
                .navigationTitle("Add an Item🖊️")

                Spacer()
            }
        }
    }
    
    private func ifTextAppropriate(title: String) -> Bool{
        if title.count > 5 {
            listViewModel.addItem(title: textFieldText)
            dismiss()
            return false
        }
        return true
    }
    
    private func customAlert() -> Alert {
        Alert(title: Text("Not long enough"),
              message: Text("Text must be greater than 5 character"),
              dismissButton: .cancel())
    }
}

#Preview {
        AddView()
            .environmentObject(ListViewModel())
}

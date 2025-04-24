
import SwiftUI

struct NoItemsView: View {
    
    @State var animate: Bool = false
    
    var body: some View {
        VStack {
            Text("There are no Items!")
                .font(.title)
                .bold()
            
            Text("Are you a productive person? I think you should click add button and add a bunch of tasks")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.horizontal)
            
            NavigationLink(destination: AddView()) {
                Text("Add an Item")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(width: animate ? 250 : 270)
                    .scaleEffect(animate ? 1.0 : 1.1)
                    .background(animate ? Color.red: Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .onAppear(perform: isAnimating)
    }
    
    private func isAnimating() {
        guard !animate else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation
                .easeInOut(duration: 2.0)
                .repeatForever())
            {
                animate.toggle()
            }
        }
    }
}

#Preview {
    NavigationView {
        NoItemsView()
    }
}

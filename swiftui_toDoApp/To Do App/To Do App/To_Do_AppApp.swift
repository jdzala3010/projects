
import SwiftUI

@main
struct To_Do_AppApp: App {

    @StateObject var listViewModel: ListViewModel = ListViewModel()

    var body: some Scene {
        WindowGroup {
                ListView()
            .environmentObject(listViewModel)
        }
    }
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "swift")
                    .font(.system(size: 100))
                    .foregroundColor(.orange)
                
                Text("Welcome to Your App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Built with SwiftUI")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                #if DEBUG
                Text("DEBUG MODE")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                #endif
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
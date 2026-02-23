import SwiftUI

struct ContentView: View {
    @State private var isConfirmed = false

    var body: some View {
        VStack {
            Button {
                isConfirmed = true
            } label: {
                Text("OK")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(width: 120, height: 50)
            }
            .buttonStyle(.borderedProminent)
            .alert("確認", isPresented: $isConfirmed) {
                Button("閉じる", role: .cancel) {}
            } message: {
                Text("OKが押されました")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

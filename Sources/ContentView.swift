import SwiftUI

struct ContentView: View {
    @Environment(EventStore.self) private var store
    @State private var showingAddEvent = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            Group {
                if store.events.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(store.events) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventRowView(event: event)
                            }
                        }
                        .onDelete(perform: store.delete)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("赤ちゃんの記録")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddEvent = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsSheet()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.on.rectangle")
                .font(.system(size: 64))
                .foregroundStyle(.pink.opacity(0.6))
            Text("まだイベントがありません")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            Text("右上の + ボタンから\n最初の思い出を記録しましょう")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct SettingsSheet: View {
    @Environment(EventStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var enableBirthDate = false
    @State private var birthDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("生年月日を設定する", isOn: $enableBirthDate.animation())
                    if enableBirthDate {
                        DatePicker(
                            "生年月日",
                            selection: $birthDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                    }
                } footer: {
                    Text(enableBirthDate
                         ? "各イベントに「何歳何ヶ月何日」が表示されます。"
                         : "設定すると各イベントに年齢が表示されます。")
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") {
                        store.birthDate = enableBirthDate ? birthDate : nil
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                if let d = store.birthDate {
                    enableBirthDate = true
                    birthDate = d
                }
            }
        }
    }
}

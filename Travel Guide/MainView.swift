import SwiftUI

struct MainView: View {

    @ObservedObject var model: Model

    var body: some View {
        NavigationView {
            ListView(model: model)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Picker(selection: $model.lang) {
                            ForEach(Array(languages.keys.sorted()), id: \.self) {
                                Text(languages[$0] ?? "")
                            }
                        } label: {
                            Image(systemName: "gear")
                                .font(.headline)
                        }
                        .padding()
                        .pickerStyle(.menu)
                    }
                }
                .navigationTitle("Nearby")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(model: Model())
    }
}

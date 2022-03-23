import SwiftUI
import MapKit

struct ListView: View {

    @ObservedObject var model: Model

    @State private var loading = false
    @State private var catchedError: Error?
    @State private var showAlert = false

    private let formatter = MKDistanceFormatter()
    
    var body: some View {
        Group {
            if loading && model.items.isEmpty {
                ProgressView()
            } else {
                List(model.items, id: \.self) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        ListItemView(item: item, formatter: formatter)
                    }
                }
                .refreshable {
                    await refresh(force: true)
                }
            }
        }
        .task {
            await refresh()
        }
        .onChange(of: model.lang) { _ in
            Task {
                model.items = []
                await refresh(force: true)
            }
        }
        .alert("Something went wrong", isPresented: $showAlert, actions: {
            Button("OK") {
                showAlert = false
            }
        }, message: {
            Text(catchedError?.localizedDescription ?? "")
        })
    }

    private func refresh(force: Bool = false) async {
        loading = true
        do {
            try await model.locateAndFetchItems(force: force)
        } catch {
            catchedError = error
            if let urlError = error as? URLError, urlError.code != .cancelled {
                showAlert = true
            }
        }
        loading = false
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(model: Model())
    }
}

import SwiftUI
import MapKit

struct ListItemView: View {
    let item: GeoSearchItem
    let formatter: MKDistanceFormatter

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: item.thumbnail?.source) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.25)
                    Image(systemName: "eye.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 66, height: 66)
            .aspectRatio(1.0, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
            VStack(alignment: .leading, spacing: 8.0) {
                Text(item.title ?? "")
                    .font(.headline)
                if let distance = item.coordinates.first?.dist {
                    Text(formatter.string(fromDistance: distance))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(
            item: GeoSearchItem(
                title: "Kulosaaren Yhteiskoulun alakoulun yläkoulu",
                index: 0,
                coordinates: []
            ),
            formatter: MKDistanceFormatter()
        )
        .previewLayout(.fixed(width: 350, height: 120))
    }
}

import SwiftUI

public struct ShimmerLoader: ViewModifier {
    @State private var animating = false
    @State private var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = .init(isLoading)
    }

    public func body(content: Content) -> some View {
        if isLoading {
            GeometryReader { geo in
                ZStack {
                    content

                    LinearGradient(colors: [.white, .white.opacity(0)],
                                   startPoint: .trailing,
                                   endPoint: .center)
                    .offset(x: -geo.size.width)
                    .offset(x: animating ? geo.size.width * 2 : 0)
                    .mask(content)
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            animating.toggle()
                        }
                    }
                }
                .redacted(reason: .placeholder)
            }
        } else {
            content
        }
    }
}

public extension View {
    func loadingShimmer(isLoading: Bool = true) -> some View {
        self.modifier(ShimmerLoader(isLoading: isLoading))
    }
}

struct ShimmerLoader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "photo.fill")
                .resizable()
                .frame(width: 200, height: 200)

            Text("Loading Shimmer Modifier Demo")
                .font(.largeTitle)

            Text("Using redacted modifier with linear gradient mask.")
        }
        .loadingShimmer(isLoading: true)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

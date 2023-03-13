import SwiftUI

public struct ShimmerLoader: ViewModifier {
    @State private var animating = false
    @State private var isLoading: Bool
    @State private var contentSize: CGSize = .zero

    public init(isLoading: Bool) {
        self.isLoading = .init(isLoading)
    }

    public func body(content: Content) -> some View {
        if isLoading {
            GeometryReader { geo in
                ZStack {
                    content
                        .background(
                            GeometryReader { innerGeometry in
                                Color.clear
                                    .onAppear {
                                        contentSize = innerGeometry.size
                                    }
                            }
                        )

                    content
                        .mask(
                            Color.white
                                .offset(x: -geo.size.width)
                                .offset(x: animating ? geo.size.width * 2 : 0)
                        )
                        .onAppear {
                            withAnimation {
                                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                    animating.toggle()
                                }
                            }
                        }
                }
                .redacted(reason: .placeholder)
                .frame(
                    width: geo.frame(in: .global).width,
                    height: geo.frame(in: .global).height
                )
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

import SwiftUI

struct ShimmerLoader: ViewModifier {
    @Binding private var isLoading: Bool
    @State private var animating = false
    @State private var size: CGSize = .zero

    init(isLoading: Binding<Bool>) {
        self._isLoading = isLoading
    }

    init() {
        self._isLoading = Binding(get: {
            true
        }, set: { _ in
            return
        })
    }

    public func body(content: Content) -> some View {
        if isLoading {
            ZStack {
                content

                LinearGradient(colors: [.white, .white.opacity(0)],
                               startPoint: .trailing,
                               endPoint: .leading)
                .offset(x: animating ? size.width : -size.width)
                .onAppear {
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                        animating.toggle()
                    }
                }
                .mask(
                    content
                )
            }
            .redacted(reason: .placeholder)
            .fixedSize(horizontal: false, vertical: true)
            .background(
                GeometryReader(content: { geo in
                    Color.clear
                        .onAppear {
                            size = geo.size
                        }
                })
            )
        } else {
            content
        }
    }
}

public extension View {
    func loadingShimmer(isLoading: Binding<Bool>) -> some View {
        self.modifier(ShimmerLoader(isLoading: isLoading))
    }

    /// Modifies the view to redact its contents
    func loadingShimmer() -> some View {
        self.modifier(ShimmerLoader())
    }
}

struct ShimmerLoader_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
            .loadingShimmer()
        
        DebugView()
    }

    struct ContentView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                Text("Loading Shimmer Modifier Demo")
                    .font(.largeTitle)
                
                Text("Using redacted modifier with linear gradient mask.")
            }
            .padding()
        }
    }
    
    struct DebugView: View {
        @State private var isLoading = true

        var body: some View {
            HStack {
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Toggle("Is Loading", isOn: $isLoading)
                    Text(isLoading ? "loading..." : "done")
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .frame(width: 200, height: 200)

                        Text("Loading Shimmer Modifier Demo")
                            .font(.largeTitle)

                        Text("Using redacted modifier with linear gradient mask.")
                    }
                    .padding()
                    .background(Color.orange)
                    .loadingShimmer(isLoading: $isLoading)
                }
                
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
            }
            .previewDisplayName("Debug View")
        }
    }
}

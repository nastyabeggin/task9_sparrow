//

import SwiftUI

struct ContentView: View {
    
    @State private var offset: CGSize = .zero
    
    private let diam = 100.0
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeight = UIScreen.main.bounds.height
    
    private var initialX: Double {
        deviceWidth / 2.0
    }
    private var initialY: Double {
        deviceHeight / 2.0
    }
    
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    gradient: .init(colors: [Color.yellow, Color.red]),
                    center: .center,
                    startRadius: diam / 2,
                    endRadius: diam
                )
            )
            .mask {
                Canvas { context, size in
                    let circle0 = context.resolveSymbol(id: 0)!
                    let circle1 = context.resolveSymbol(id: 1)!
                    
                    context.addFilter(.alphaThreshold(min: 0.5, color: Color.yellow))
                    context.addFilter(.blur(radius: 15))
                    
                    context.drawLayer { ct in
                        ct.draw(circle0, at: CGPoint(x: initialX, y: initialY))
                        ct.draw(circle1, at: CGPoint(x: initialX, y: initialY))
                    }
                } symbols: {
                    Circle()
                        .frame(width: diam, height: diam)
                        .offset(x: offset.width, y: offset.height)
                        .tag(0)
                    Circle()
                        .frame(width: diam, height: diam)
                        .tag(1)
                }
            }
            .overlay {
                Image(systemName: "cloud.sun.rain.fill")
                    .font(.largeTitle)
                    .offset(x: offset.width, y: offset.height)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
            }
            .gesture (
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.bouncy) {
                            offset = .zero
                        }
                    }
            )
            .ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

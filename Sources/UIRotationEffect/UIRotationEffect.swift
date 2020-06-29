import SwiftUI

struct UIRotationView<Content: View>: UIViewRepresentable {
    let content: UIView
    let angle: Angle
    let duration: TimeInterval?
    let delay: TimeInterval?
    let options: UIView.AnimationOptions?
    let completion: ((Bool) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIView {
        content.transform = CGAffineTransform(rotationAngle: CGFloat(angle.radians))
        content.backgroundColor = .clear
        return content
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        UIView.animate(withDuration: duration ?? 0.25, delay: delay ?? 0.0, options: options ?? [], animations: {
            uiView.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle.radians))
        }, completion: completion)
    }

    class Coordinator: NSObject {
        var view: UIRotationView

        init(_ view: UIRotationView) {
            self.view = view
        }
    }
}

struct UIRotationViewModifier: ViewModifier {
    let angle: Angle
    let duration: TimeInterval?
    let delay: TimeInterval?
    let options: UIView.AnimationOptions?
    let completion: ((Bool) -> Void)?
    
    func body(content: Content) -> some View {
        let c = UIHostingController(rootView: content).view
        return UIRotationView<Content>(content: c!, angle: angle, duration: duration, delay: delay, options: options, completion: completion)
    }
}

public extension View {
    func uiRotationEffect(_ angle: Angle, duration: TimeInterval? = nil, delay: TimeInterval? = nil, options: UIView.AnimationOptions? = nil, completion: ((Bool) -> Void)? = nil) -> some View {
        self.modifier(UIRotationViewModifier(angle: angle, duration: duration, delay: delay, options: options, completion: completion))
    }
}

// Example
struct UIRotationView_Previews: PreviewProvider {
    
    static var previews: some View {
        RotationExampleContentView()
    }
    
    struct RotationExampleContentView: View {
        
        @State private var angle: Angle = .degrees(340)
        
        var body: some View {
            VStack {
                Spacer()
                
                Group {
                    Text(".uiRotationEffect")
                        .font(.caption)
                    Image(systemName: "arrow.up")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding()
                        .border(Color.blue)
                        .uiRotationEffect(angle)
                        .frame(width: 60, height: 60)
                }
                
                Spacer()
                
                Group {
                    Text(".uiRotationEffect with options")
                        .font(.caption)
                    Image(systemName: "arrow.up")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding()
                        .border(Color.blue)
                        .uiRotationEffect(angle, duration: 2.0, options: [.curveEaseInOut])
                        .frame(width: 60, height: 60)
                }
                
                Spacer()
                
                Group {
                    Text(".rotationEffect (Default SwiftUI)")
                        .font(.caption)
                    // The rotation animation takes the "long way around" in iOS 13
                    Image(systemName: "arrow.up")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding()
                        .border(Color.blue)
                        .rotationEffect(angle)
                        .animation(.easeInOut(duration: 2.0))
                        .frame(width: 60, height: 60)
                }
                
                Spacer()
                
                Text("Tap to rotate")
                    .padding()
                    .onTapGesture {
                        self.angle = (self.angle == .degrees(340) ? .degrees(20) : .degrees(340))
                    }
            }
        }
    }
}

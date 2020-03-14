//

import SwiftUI

struct SightComponent: Shape {
  let angle: Angle

  func path(in rect: CGRect) -> Path {
    Path { path in
      let radius: CGFloat = min(rect.size.width, rect.size.height) / 2

      path.addArc(
        center: CGPoint(x: radius, y: radius),
        radius: radius,
        startAngle: angle / 2,
        endAngle: -angle / 2,
        clockwise: true,
        transform: .identity
      )

      path.move(to: CGPoint(x: radius * 1.8, y: radius))
      path.addLine(to: CGPoint(x: radius * 2.2, y: radius))
    }
  }
}

struct SightView: View {
  let strokeWidth: CGFloat
  let rotationCount: Int
  let angle: Double
  let innerRadius: CGFloat

  var body: some View {
    ZStack {
      ForEach(0..<rotationCount, id: \.self) { i in
        SightComponent(angle: .degrees(self.angle))
          .stroke(style: StrokeStyle(lineWidth: self.strokeWidth, lineCap: .round))
          .aspectRatio(1, contentMode: .fit)
          .padding(40)
          .rotationEffect(.degrees(Double(i) / Double(self.rotationCount)) * 360.0)
      }
      Circle()
        .frame(width: innerRadius, height: innerRadius)
    }
  }
}

struct LogoView: View {
  let strokeWidth: CGFloat
  let rotationCount: Int
  let angle: Double
  let innerRadius: CGFloat

  var sightView: some View {
    SightView(strokeWidth: strokeWidth, rotationCount: rotationCount, angle: angle, innerRadius: innerRadius)
  }

  func gradient(for geometry: GeometryProxy) -> RadialGradient {
    RadialGradient(
      gradient: Gradient(colors: [.red, .orange]),
      center: UnitPoint(x: 0.25, y: 0.25),
      startRadius: 0,
      endRadius: geometry.size.width
    )
  }

  var body: some View {
    ZStack {
      sightView
        .hidden()
      GeometryReader { geometry in
        self.gradient(for: geometry)
          .mask(self.sightView)
      }
    }
  }
}

struct LogoSettingsView: View {
  @Binding var strokeWidth: CGFloat
  @Binding var innerCircleRadius: CGFloat
  @Binding var rotationNumber: Int
  @Binding var angle: Double

  var body: some View {
    List {
      Section {
        LogoView(strokeWidth: self.strokeWidth, rotationCount: self.rotationNumber, angle: self.angle, innerRadius: self.innerCircleRadius)
      }

      Section(header: Text("Stroke Width: ")) {
        Slider(value: $strokeWidth, in: 0...100, step: 0.1)
      }

      Section(header: Text("Inner Circle Radius: ")) {
        Slider(value: $innerCircleRadius, in: 0...100, step: 0.1)
      }

      Section {
        Stepper("Rotations: ", value: $rotationNumber)
      }

      Section(header: Text("Arc Angle: ")) {
        Slider(value: $angle, in: 10...120, step: 1)
      }
    }
    .listStyle(GroupedListStyle())
    .environment(\.horizontalSizeClass, .regular)
  }
}

struct ContentView_Previews: PreviewProvider {

  static var previews: some View {
    LogoSettingsView(
      strokeWidth: .constant(16),
      innerCircleRadius: .constant(20),
      rotationNumber: .constant(3),
      angle: .constant(90))
  }
}

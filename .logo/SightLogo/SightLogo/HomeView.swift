//

import SwiftUI

struct HomeView: View {
  @State private var strokeWidth: CGFloat = 16
  @State private var innerCircleRadius: CGFloat = 16
  @State private var rotationNumber: Int = 3
  @State private var angle: Double = 90
  var fontSize: CGFloat = 150

  var body: some View {
//    NavigationView  {
      HStack {
//        NavigationLink(
//          destination: LogoSettingsView(
//            strokeWidth: $strokeWidth,
//            innerCircleRadius: $innerCircleRadius,
//            rotationNumber: $rotationNumber,
//            angle: $angle)) {
          Text("___")
            .font(Font.system(size: self.fontSize, weight: .heavy, design: .default))
            .hidden()
            .overlay(
              LogoView(strokeWidth: self.strokeWidth, rotationCount: self.rotationNumber, angle: self.angle, innerRadius: self.innerCircleRadius),
              alignment: .trailing)
//        }

        Text("SIGHT")
          .font(Font.system(size: self.fontSize, weight: .heavy, design: .default))
//      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
          .previewLayout(.fixed(width: 1000, height: 200))
      .padding()
    }
}

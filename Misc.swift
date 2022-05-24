import SwiftUI

public struct Sounds {
    public static var currentSound = "Click"
}

public struct Polygon: Shape {
    public var sides: Int;
    public var angle: Int;

    public func path(in rect: CGRect) -> Path {
        
        var path = Path()
        let center: CGPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius: Double = Double(rect.width / 2)
        for i in stride(from: angle, to: (360 + angle), by: 360/sides) {
            let radians = Double(i) * Double.pi / 180.0
            let x = Double(center.x) + radius * cos(radians)
            let y = Double(center.y) + radius * sin(radians)
            if i == angle {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
    
    // Add handling for sides more than 40 as to not crash
    public init(sides: Int, angle: Int){
        self.sides = sides < 40 ? sides : 40
        self.angle = angle
    }
}

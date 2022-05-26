import Foundation
import UIKit

extension UIView {
    // 그라데이션 컬러 설정
    func GradientColor(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    // 뷰 부분적 cornerRadius 설정
    func CornerRadiusLayerSetting(cornerRadius: CGFloat, cornerLayer: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: cornerLayer)
    }
}

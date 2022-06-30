import Foundation
import UIKit

// 화면 로드 시 실행해는는 뷰 갱신? 프로토콜
protocol ViewUpdate {
    func makeView(view: UIViewController)
}

protocol getAccount {
    func getId() -> String
    func getPwd() -> String
}


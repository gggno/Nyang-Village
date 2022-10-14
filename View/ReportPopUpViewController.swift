import UIKit
import SQLite3
import StompClientLib
import SystemConfiguration

class ReportPopUpViewController: UIViewController, StompClientLibDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var reportPopUpView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    // 소켓 클라이언트 생성
    var socketClient = StompClientLib()
    
    let sql = Sql.shared
    
    var reportNickName: String? // 신고대상 닉네임
    var reportContent: String? // 신고대상이 보낸 채팅 메시지
    var reportWhy: String? // 신고사유
    var reporterNickname: String? // 신고자 닉네임
    var studentId: String? // 신고자 학번
    var roomName: String? // 과목명
    var professorName: String? // 교수이름
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // 소켓 연결
//        registerSockect()
        
        studentId = sql.selectUserInfoStudentId()
        
        // 소켓 주소
        let url = URL(string: "ws://13.209.68.42:8087/stomp")!

        self.nickNameLabel.text = reportNickName!
        self.reportPopUpView.layer.cornerRadius = 15
        self.reportView.CornerRadiusLayerSetting(cornerRadius: 15, cornerLayer: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        self.cancelBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.borderColor = UIColor(named: "MainOrangeColor")?.cgColor
        
        self.sendBtn.layer.cornerRadius = 5
        self.sendBtn.layer.borderWidth = 1
        self.sendBtn.layer.borderColor = UIColor(named: "MainOrangeColor")?.cgColor
    }
    
    // MARK: - IBAction
    
    // 취소 버튼 클릭
    @IBAction func cancelBtnClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // 전송 버튼 클릭
    @IBAction func sendBtnClicked(_ sender: Any) {
        let reportDatas: [String: Any] = ["reportName" : reportNickName!, "reportContent" : reportContent!, "reportWhy" : "", "reporter" : reporterNickname!, "studentId" : studentId!, "roomName" : roomName!, "professorName" : professorName!,]
        
        socketClient.sendJSONForDict(dict: reportDatas as AnyObject, toDestination: "/pub/ay/report")
        dismiss(animated: true)
    }
    
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("stompClient() called")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp socket is disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp socket is connected")
        
        subscribe()
//        chatRoomEntrance()
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("serverDidSendError() called Error send : " + description)
        // disconnect하고 registerSokect이 실행되야 하는데 비동기 처리로 인해 disconnect이 더 늦게 처리 됨.
//        socketClient.disconnect()
//        registerSockect()
    }
    
    func serverDidSendPing() {
        print("serverDidSendPing() called")
    }
    
    // Socket Connection
//    func registerSockect() {
//        socketClient.openSocketWithURLRequest(
//            request: NSURLRequest(url: url),
//            delegate: self,
//            connectionHeaders: [ "jwt" : sql.selectUserInfoJwt()]
//        )
//        print("registerSockect() called")
//    }
    
    func subscribe() {
        print("subscribe() called")
        
    }
    
    // Unsubscribe
    func disconnect() {
        print("disconnect() called")
        socketClient.disconnect()
        
    }

    

}

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("AppDelegate - didFinishLaunchingWithOptions called")
        // Override point for customization after application launch.
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        // 메세징 델리겟
        Messaging.messaging().delegate = self
        // 푸시 포그라운드 설정 (앱이 열려있을 때도 푸시 메세지를 받게 해줌)
        UNUserNotificationCenter.current().delegate = self
        
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // [원격 알림 앱 등록 : APNS 등록]
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
}

// 알림처리: FCM은 APN을 통해 Apple 앱을 타겟팅하는 모든 메시지를 전송합니다.
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print("didReceiveRemoteNotification")
        
        let sql = Sql.shared
        // roomId 형 변환
        let roomIdConvert = (userInfo["roomId"] as! NSString).intValue
        let notiDatas : NotiRoomInfo = sql.selectRoomInfoNoti(roomid: Int(roomIdConvert))
        
        let pushNotification =  UNMutableNotificationContent()
        
        // 자신과 보낸사람 닉네임을 비교해서 같지 않다. -> 알림 안 보냄
//        if sql.selectRoomInfoInNickname(roomid: Int(roomIdConvert)) != userInfo["nickName"] as! String
//        {
            pushNotification.userInfo = userInfo
            pushNotification.title = notiDatas.roomName
            pushNotification.subtitle = userInfo["nickName"] as! String
            pushNotification.body = userInfo["content"] as! String
//            pushNotification.badge = 1
            pushNotification.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.0001, repeats: false)
            let request = UNNotificationRequest(identifier: "\(Int(roomIdConvert))", content: pushNotification, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
        
        
        return UIBackgroundFetchResult.newData
    }
    
    // 앱이 실행 중인 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let application = UIApplication.shared
        let userInfo = notification.request.content.userInfo
        
        // roomId 형 변환
        let roomIdConvert = (userInfo["roomId"] as! NSString).intValue
        
        print("AppDelegate - willPresent called")
        print("설명 :: 앱 포그라운드 상태 푸시 알림 확인")
        print("userInfo :: \(notification.request.content.userInfo)") // 푸시 정보 가져옴
//        print("title :: \(notification.request.content.title)") // 푸시 정보 가져옴
//        print("body :: \(notification.request.content.body)") // 푸시 정보 가져옴
        
//        if application.applicationState == .active {
//            print(".active")
//            if notification.request.identifier == "\(Int(roomIdConvert))" {
//                print("같다.")
//                NotificationCenter.default.post(name: Notification.Name(pushNotificationName), object: roomIdConvert)
//            }
//        }
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // 백그라운드인 경우 & 사용자가 푸시를 클릭한 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        let rootVC = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let application = UIApplication.shared
        let userInfo = response.notification.request.content.userInfo
        
        // roomId 형 변환
        let roomIdConvert = (userInfo["roomId"] as! NSString).intValue
        
        print("AppDelegate - didReceive called")
        print("앱 백그라운드 상태 푸시 알림 확인")
        
//        print("userInfo :: \(response.notification.request.content.userInfo)") // 푸시 정보 가져옴
//        print("title :: \(response.notification.request.content.title)") // 푸시 정보 가져옴
//        print("body :: \(response.notification.request.content.body)") // 푸시 정보 가져옴
        
        // 앱이 켜져있는 상태에 푸시 알림을 눌렀을 때
        if application.applicationState == .active {
            print(".active")
            if response.notification.request.identifier == "\(Int(roomIdConvert))" {
                print("같다.")
                NotificationCenter.default.post(name: Notification.Name(pushNotificationName), object: roomIdConvert)
//                let chatVC = storyboard.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController
//                let naviVC = rootVC as? UINavigationController
//                
//                chatVC?.title = "테스트 타이틀"
//                chatVC?.subjectName = "테스트 과목"
//                chatVC?.professorName = "테스트 교수"
//                
//                chatVC?.roomId = Int(roomIdConvert)
//                naviVC?.pushViewController(chatVC!, animated: true)
            }
        }
        
        // 앱이 꺼져있는 상태에 푸시 알림을 눌렀을 때
        if application.applicationState == .inactive {
            print(".inactive")
            if response.notification.request.identifier == "\(Int(roomIdConvert))" {
                print("같다.")
                NotificationCenter.default.post(name: Notification.Name(pushNotificationName), object: roomIdConvert)
//                let chatVC = storyboard.instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController
//                let naviVC = rootVC as? UINavigationController
//
//                chatVC?.title = "테스트 타이틀"
//                chatVC?.subjectName = "테스트 과목"
//                chatVC?.professorName = "테스트 교수"
//
//                chatVC?.roomId = Int(roomIdConvert)
//                naviVC?.pushViewController(chatVC!, animated: true)
            }
        }
        
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("파베 토큰을 받았다.")
        print("Appdelegate - firebase registration token: \(String(describing: fcmToken))")
    }
    
    // [원격 알림 앱 등록 : APNS 등록 후 >> apnsToken 매핑]
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("AppDelegate - didRegisterForRemoteNotificationsWithDeviceToken called")
        print("설명 :: 원격 알림 앱 등록 : APNS 등록 후 >> apnsToken 매핑")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
}

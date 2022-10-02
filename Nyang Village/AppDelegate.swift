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
        print("AppDelegate - configurationForConnecting called")
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("AppDelegate - didDiscardSceneSessions")
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        print("AppDelegate - supportedInterfaceOrientationsFor")
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }
}

// 알림처리: FCM은 APN을 통해 Apple 앱을 타겟팅하는 모든 메시지를 전송합니다.
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // [앱이 foreground 상태 일 때, 알림이 온 경우]
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        print("AppDelegate - willPresent called")
        print("설명 :: 앱 포그라운드 상태 푸시 알림 확인")
//        print("userInfo :: \(notification.request.content.userInfo)") // 푸시 정보 가져옴
//        print("title :: \(notification.request.content.title)") // 푸시 정보 가져옴
//        print("body :: \(notification.request.content.body)") // 푸시 정보 가져옴
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // ...
        
        // Print full message.
//        print(userInfo)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // 알림 온 노티를 눌렀을 때 실행 됨.[앱이 background 상태 일 때, 알림이 온 경우]
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print("AppDelegate - didReceive called")
        print("앱 백그라운드 상태 푸시 알림 확인")
//        print("userInfo :: \(response.notification.request.content.userInfo)") // 푸시 정보 가져옴
//        print("title :: \(response.notification.request.content.title)") // 푸시 정보 가져옴
//        print("body :: \(response.notification.request.content.body)") // 푸시 정보 가져옴
        
        // [completionHandler : 푸시 알림 상태창 표시]
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print("didReceiveRemoteNotification")
            
//        print("userInfo: \(userInfo)")

        
        
        return UIBackgroundFetchResult.newData
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

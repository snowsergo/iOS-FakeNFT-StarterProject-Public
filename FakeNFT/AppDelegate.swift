import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Создаем экземпляр UIWindow
//          window = UIWindow(frame: UIScreen.main.bounds)
//
//          // Создаем и настраиваем экземпляр UINavigationController
//          let navigationController = UINavigationController(rootViewController: StatisticsPageViewController())
//
//          // Назначаем UINavigationController как корневой контроллер окна
//          window?.rootViewController = navigationController
//
//          // Делаем окно видимым
//          window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

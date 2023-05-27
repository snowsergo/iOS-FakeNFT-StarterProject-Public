import UIKit
import ProgressHUD

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .asset(.black)

        // Available main UITabBarController
        guard let tabController = window?.rootViewController as? UITabBarController else { return }
        (UIApplication.shared.delegate as! AppDelegate).rootTabBarController = tabController
    }
}

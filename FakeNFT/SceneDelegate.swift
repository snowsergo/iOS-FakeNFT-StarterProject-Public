import UIKit
import ProgressHUD

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = ColorScheme.black
    }
}

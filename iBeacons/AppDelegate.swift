import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let beaconManager = BeaconManager.sharedInstance
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")))
        {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound , UIUserNotificationType.Alert , UIUserNotificationType.Badge], categories: nil))
        }
        else
        {
            //do iOS 7 stuff, which is pretty much nothing for local notifications.
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        print("Application will resign active")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("Application entered background.")
        beaconManager.appActive = false
        beaconManager.startMonitoring()
        beaconManager.removeBeaconsInRangeFromMemory()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print("Application enters foreground...")
        beaconManager.appActive = true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print("Application become active")
        beaconManager.appActive = true
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


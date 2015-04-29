import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let beaconManager = BeaconManager.sharedInstance
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")))
        {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        }
        else
        {
            //do iOS 7 stuff, which is pretty much nothing for local notifications.
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        println("Application will resign active")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        println("Application entered background.")
        beaconManager.appActive = false
        beaconManager.startMonitoring()
        beaconManager.removeBeaconsInRangeFromMemory()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        println("Application enters foreground...")
        beaconManager.appActive = true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("Application become active")
        beaconManager.appActive = true
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


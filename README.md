# bugfree-beacon-ios

App uses Cocoapods to manage dependencies. [Read more](http://guides.cocoapods.org/using/getting-started.html) to get started. 

Before starting the project make sure that all of them are install by typing following command in main directory of project: 
```
$ pod install
```

Make sure to check version of Cocoapods:
```
$ pod --version
```
It should be at least 0.36.


Always open the Xcode workspace instead of the project file when building your project:
```
$ open iBeacons.xcworkspace
```

## REST API connection

Calls are easier thanks to [Alamofire](https://github.com/Alamofire/Alamofire).

To parse JSON API responses and requests there is an [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON). 
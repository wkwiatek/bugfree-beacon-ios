import UIKit
import SwiftyJSON

class BeaconsTableViewController: UITableViewController {

    private struct Storyboard {
        static let RangedCellReuseIdentifier = "RangedBeaconCell"
        static let MyCellReuseIdentifier = "MyBeaconCell"
    }
    
    enum BeaconType {
        case MY, RANGED
    }
    
    var beacons = [AbstractBeacon]()
    var listType: BeaconType?
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        
        refresh(refreshControl)
    }
 

    @IBAction func refresh(sender: UIRefreshControl?) {
        
        switch listType! {
        case .MY:
            print ("Refreshing my beacons")
            
            BeaconFeeder.feedMyBeacons({ (newBeacons) -> () in
                
                // It will be an asynchronous API - we don't want to block main queue
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newBeacons.count > 0 {
                        self.beacons.removeAll()
                        self.beacons = newBeacons
                        self.tableView.reloadData()
                        sender?.endRefreshing()
                    }
                }
            })
            
            break
        case .RANGED:
            print("Refreshing ranged beacons")
            
            BeaconFeeder.feedFromRanging { (newBeacons) -> () in
                
                // It will be an asynchronous API - we don't want to block main queue
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newBeacons.count > 0 {
                        self.beacons.removeAll()
                        self.beacons = newBeacons
                        self.tableView.reloadData()
                        sender?.endRefreshing()
                    }
                }
                
            }
            
            break
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: BeaconTableViewCell
        
        switch listType! {
        case .MY:
            cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MyCellReuseIdentifier, forIndexPath: indexPath) as! BeaconTableViewCell
    
        case .RANGED:
            cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.RangedCellReuseIdentifier, forIndexPath: indexPath) as! BeaconTableViewCell
        }
        
        // Configure the cell using it's public API
        cell.abstractBeacon = beacons[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {

            let cell = sender as! BeaconTableViewCell
            
            if let indexPath = tableView.indexPathForCell(cell) {

                switch identifier {
                case "show_range_details":
                    let beacon = beacons[indexPath.item] as! RangedBeacon
                    let destinationMVC = segue.destinationViewController as! RangedBeaconDetailsViewController
                    
                    destinationMVC.beacon = beacon
                    
                    BejkonREST.findBeacon(beacon.uuid, major: beacon.major, minor: beacon.minor) { response in
                        let json = JSON(response.response!)
                        let id = json[0]["id"].string
                        
                        if id == nil {
                            // We don't have this beacon in db
                        } else {
                            // Fetch data from server
                            destinationMVC.feedMyBeaconData(
                                json[0]["id"].string!,
                                title: json[0]["data"]["title"].string!,
                                subtitle: json[0]["data"]["subtitle"].string!,
                                content: json[0]["data"]["content"].string!,
                                template: json[0]["template"]["type"].string!,
                                imageURL: json[0]["data"]["imageUrl"].string!,
                                detailsURL: json[0]["data"]["detailsUrl"].string!,
                                titleColor: json[0]["template"]["titleColor"].string!,
                                subtitleColor: json[0]["template"]["subtitleColor"].string!,
                                contentColor: json[0]["template"]["contentColor"].string!,
                                backgroundColor: json[0]["template"]["backgroundColor"].string!
                            )
                        }
                        
                    }
                    
                case "show_my_details":
                    let beacon = beacons[indexPath.item] as! MyBeacon
                    let destinationMVC = segue.destinationViewController as! MyBeaconDetailsViewController
                    destinationMVC.beacon = beacon
                    
                default: break
                }
            }
        }
    }
    
}

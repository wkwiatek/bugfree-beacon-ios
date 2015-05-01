import UIKit

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
            println ("Refreshin my beacons")
            
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
            println("Refreshing ranged beacons")
            
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
            if identifier == "show_details" {
                let cell = sender as! BeaconTableViewCell
                
                if let indexPath = tableView.indexPathForCell(cell) {
                    println("Settings things for the detailed view, ip: \(indexPath)")

                    switch listType! {
                    case .MY:
                        println("Processing to MyBeaconDetailsViewController")
                        let destinationMVC = segue.destinationViewController as! MyBeaconDetailsViewController
                        
                    case .RANGED:
                        println("Processing to RangedBeaconDetailsViewController")
                        let destinationMVC = segue.destinationViewController as! RangedBeaconDetailsViewController
                    }
                    
                }
                
            }
        }
    }
    
}

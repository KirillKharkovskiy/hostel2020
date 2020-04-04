
import UIKit

class MainClientAdminVC: UIViewController {
    @IBOutlet weak var acceptedOrder: UIView!
    @IBOutlet weak var newOrderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            newOrderView.alpha = 1
            acceptedOrder.alpha = 0
        }else{
            newOrderView.alpha = 0
            acceptedOrder.alpha = 1
        }
    }
}

import UIKit
class MainClientAdminVC: UIViewController {
    @IBOutlet weak var acceptedOrder: UIView!
    @IBOutlet weak var newOrderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            acceptedOrder.isHidden = true
            newOrderView.isHidden = false
        }else{
            newOrderView.isHidden = true
            acceptedOrder.isHidden = false
        }
    }
}

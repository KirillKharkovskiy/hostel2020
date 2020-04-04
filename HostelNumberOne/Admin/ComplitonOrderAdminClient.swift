import UIKit

class ComplitonOrderAdminClient: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
}

// MARK: - TableView
extension ComplitonOrderAdminClient: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ComplitionOrderTableViewCell
        cell.titleLabel.text = "OrderComplition"
        return cell
    }
    
    
}

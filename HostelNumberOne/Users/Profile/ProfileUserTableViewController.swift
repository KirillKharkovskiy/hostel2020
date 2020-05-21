import UIKit
class ProfileUserTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        setupBackButton()
    }
    func setupBackButton(){
        self.navigationItem.backBarButtonItem=UIBarButtonItem(title:"", style: .plain, target: nil, action: nil)//с кнопки назад убирает название
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileUserTableViewCell
            cell.titleLabel.text = "Мои данные"
            cell.accessoryType = .disclosureIndicator
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellHistory", for: indexPath) as! ProfileUserTableViewCell
            cell.titleLabel.text = "История заказов"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}



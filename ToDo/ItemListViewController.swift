import UIKit

class ItemListViewController: UIViewController {
    
    let itemManager = ItemManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
}


import Foundation
import UIKit
class RoomViewController:UIViewController {
    
    @IBOutlet weak var roomTableView: UITableView!
    
    var roomID : String!
    private let viewModel = RoomViewModel()
    
    @IBOutlet weak var titleUINavigationItem: UINavigationItem!
    override func viewDidLoad() {
        viewModel.delegate = self
        titleUINavigationItem.title = roomID
        viewModel.roomID = roomID
        viewModel.connect()
    }
    @IBAction func didTapDismiss(_ sender: UIBarButtonItem) {
        viewModel.disconnect()
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func didTapSend(_ sender: Any) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                let date = formatter.string(from: Date())
                let message = ["message":"date:\(date)"]
                do {
                    let data = try JSONSerialization.data(withJSONObject: message, options: [])
                    viewModel.socket?.write(data: data)
                } catch let error {
                    print(error)
                }
    }
}
extension RoomViewController:RoomViewModelDelegate {
    func reloadTable() {
        roomTableView.reloadData()
    }
}
extension RoomViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell", for: indexPath)
        cell.backgroundColor = .gray
        cell.textLabel?.text = viewModel.messages[indexPath.row].message
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

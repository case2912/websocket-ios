import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    @IBAction func didTapCreateRoom(_ sender: Any) {
        viewModel.createRoom()
    }
    @IBAction func didTapReload(_ sender: Any) {
        viewModel.fetchRooms()
    }
    


}
extension ViewController:ViewModelDelegate {
    func reloadTable() {
        tableView.reloadData()
    }
    func presentRoomViewController(roomID : String) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "RoomViewController") as? RoomViewController else {
            return
        }
        controller.roomID = roomID
        self.present(controller, animated: false, completion: nil)
    }
}
extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.backgroundColor = .orange
        cell.textLabel?.text = viewModel.rooms[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentRoomViewController(roomID: viewModel.rooms[indexPath.row])
    }
}



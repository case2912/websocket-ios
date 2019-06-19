import Foundation


protocol ViewModelDelegate {
    func reloadTable()
    func presentRoomViewController(roomID:String)
}
struct RoomListResponse:Codable {
    var rooms:[String]
}
struct RoomCreateResponse: Codable {
    var room_id: String
}
final class ViewModel {
    var delegate:ViewModelDelegate?
    private(set) var rooms :[String] = []
    func createRoom() {
        guard let url = URL(string: "http://127.0.0.1:8080/room/create")else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONDecoder().decode(RoomCreateResponse.self, from: data) else {
                return
            }
            DispatchQueue.main.async {
                self.delegate?.presentRoomViewController(roomID: json.room_id)
            }
            }.resume()
    }
    func fetchRooms() {
        guard let url = URL(string: "http://127.0.0.1:8080/roomlist")else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else {
                return
            }
            guard let json = try? JSONDecoder().decode(RoomListResponse.self, from: data) else {
                return
            }
            self.rooms.removeAll()
            self.rooms += json.rooms
            DispatchQueue.main.async {
                self.delegate?.reloadTable()
            }
        }.resume()
    }
}

import Foundation
import Starscream

protocol RoomViewModelDelegate {
    func reloadTable()
}
final class RoomViewModel {
    var delegate: RoomViewModelDelegate?
    var roomID : String!
    var socket :WebSocket?
    var messages: [Messsage] = []
    func connect() {
        guard let url = URL(string: "ws://127.0.0.1:8080/room?id=\(roomID!)") else {
            return
        }
        socket = WebSocket(url: url)
        socket?.delegate = self
        socket?.connect()
    }
    func disconnect() {
        socket?.disconnect()
    }
}


extension RoomViewModel:WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("didConnect")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("didDisconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("didRecieveMessage")
        guard let data = text.data(using: .utf8)else {return}
        guard let json =  try? JSONDecoder().decode(Messsage.self, from: data) else {return}
        messages += [json]
        delegate?.reloadTable()
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("didRecieveData")
    }
}
struct Messsage:Codable {
    var message:String
}

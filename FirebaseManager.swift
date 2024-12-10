import Foundation
//import FirebaseCore
//import FirebaseDatabase

//class FirebaseManager: ObservableObject {
    //static let shared = FirebaseManager()
    private var ref: DatabaseReference
    
    @Published var notifications: [Notification] = []
    
    //private init() {
        //FirebaseApp.configure()
        //self.ref = Database.database().reference()
        
        // Start listening for notifications
        //observeNotifications()
}
    
    func observeNotifications() {
        ref.child("notifications").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: Any]] else { return }
            
            self.notifications = value.compactMap { (key, value) in
                guard let type = value["type"] as? String,
                      let message = value["message"] as? String,
                      let timestamp = value["timestamp"] as? Double else { return nil }
                
                return Notification(
                    id: key,
                    type: NotificationType(rawValue: type) ?? .general,
                    message: message,
                    timestamp: Date(timeIntervalSince1970: timestamp)
                )
            }
        }
    }
}

struct Notification: Identifiable {
    let id: String
    let type: NotificationType
    let message: String
    let timestamp: Date
}

enum NotificationType: String {
    case door = "door"
    case temperature = "temperature"
    case sound = "sound"
    case general = "general"
    
    var icon: String {
        switch self {
        case .door: return "door.left.hand.open"
        case .temperature: return "thermometer"
        case .sound: return "speaker.wave.2.fill"
        case .general: return "bell.fill"
        }
    }
} 

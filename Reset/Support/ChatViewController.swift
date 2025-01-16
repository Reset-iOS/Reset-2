//
//  ChatViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType, Codable {
    var displayName: String
    var senderId: String
}

struct Message: MessageType, Codable {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var recipient: SenderType

    enum CodingKeys: String, CodingKey {
        case sender, messageId, sentDate, kind, recipient
    }

    // Manually encode MessageKind and SenderType
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sender as! Sender, forKey: .sender)
        try container.encode(messageId, forKey: .messageId)
        try container.encode(sentDate, forKey: .sentDate)
        try container.encode(recipient as! Sender, forKey: .recipient)

        // Handle MessageKind encoding
        switch kind {
        case .text(let text):
            try container.encode("text", forKey: .kind)
            try container.encode(text, forKey: .kind)
        default:
            throw EncodingError.invalidValue(kind, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported MessageKind"))
        }
    }

    // Manually decode MessageKind and SenderType
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sender = try container.decode(Sender.self, forKey: .sender)
        messageId = try container.decode(String.self, forKey: .messageId)
        sentDate = try container.decode(Date.self, forKey: .sentDate)
        recipient = try container.decode(Sender.self, forKey: .recipient)

        // Handle MessageKind decoding
        if let text = try? container.decode(String.self, forKey: .kind) {
            kind = .text(text)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .kind, in: container, debugDescription: "Unsupported MessageKind")
        }
    }

    init(sender: SenderType, messageId: String, sentDate: Date, kind: MessageKind, recipient: SenderType) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
        self.recipient = recipient
    }
}

enum CodingKeys: String, CodingKey {
        case sender, messageId, sentDate, kind, recipient
}

class ChatViewController: MessagesViewController, MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate,InputBarAccessoryViewDelegate {
    
    var user:Contact?
    var currentUser: Sender = Sender(displayName: "Emily", senderId: "self")
    var otherUser: Sender?
    var messages = [MessageType]() {
            didSet {
                saveMessages()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = user else {
                print("Error: user is nil. Make sure to pass a valid Contact before navigating to ChatViewController.")
                return
        }
        
        otherUser = Sender(displayName: user.name, senderId: user.name)
        
        messages = loadMessages()
        print(messages)
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.reloadData()
        
        title = user.name
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true) // Dismiss the keyboard
    }
    
    var currentSender: SenderType {
        return currentUser
    }
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> any MessageType {
        print(messages[indexPath.section])
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(sender: currentSender, messageId: UUID().uuidString,
                              sentDate: Date(),
                              kind: .text(text),
                              recipient: otherUser!)
        print("Pressed Send")
        messages.append(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
        inputBar.inputTextView.text = ""
    }
    
    private func getConversationKey() -> String {
        guard let otherUserId = otherUser?.senderId else {
                print("Error: otherUser is nil")
                return ""
            }
        return "\(currentUser.senderId)_\(otherUserId)"
    }

    private func saveMessages() {
            let conversationKey = getConversationKey()
            let encoder = JSONEncoder()
            if let encodedMessages = try? encoder.encode(messages as! [Message]) {
                UserDefaults.standard.set(encodedMessages, forKey: conversationKey)
            }
    }

    private func loadMessages() -> [MessageType] {
            let conversationKey = getConversationKey()
            if let savedMessagesData = UserDefaults.standard.data(forKey: conversationKey) {
                let decoder = JSONDecoder()
                if let decodedMessages = try? decoder.decode([Message].self, from: savedMessagesData) {
                    return decodedMessages
                }
            }
            return []
    }


}

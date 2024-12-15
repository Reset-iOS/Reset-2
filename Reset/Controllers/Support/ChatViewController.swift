//
//  ChatViewController.swift
//  Reset
//
//  Created by Prasanjit Panda on 15/12/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var displayName: String
    var senderId: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}

class ChatViewController: MessagesViewController, MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate,InputBarAccessoryViewDelegate {
    
    var user:Contact?
    var currentUser: Sender = Sender(displayName: "Emily", senderId: "self")
    var otherUser: Sender = Sender(displayName: "John Doe", senderId: "other")
    
    var messages = [MessageType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(
            Message(sender:currentUser,
                    messageId:"1",
                    sentDate:Date().addingTimeInterval(-86400),
                    kind:.text("Hi, there!")
                   ))
        messages.append(
            Message(sender:otherUser,
                    messageId:"2",
                    sentDate:Date().addingTimeInterval(-80000),
                    kind:.text("Hi!")
                   ))
        messages.append(
            Message(sender:currentUser,
                    messageId:"3",
                    sentDate:Date().addingTimeInterval(-78000),
                    kind:.text("How are you?")
                   ))
        messages.append(
            Message(sender:currentUser,
                    messageId:"4",
                    sentDate:Date().addingTimeInterval(-76000),
                    kind:.text("I'm fine. How've you been?")
                   ))
        print(messages)
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.reloadData()
        
        title = user?.name
        
        
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
                              kind: .text(text))
        print("Pressed Send")
        messages.append(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
        inputBar.inputTextView.text = ""
    }


}

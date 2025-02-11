//
//  AgoraChatSendTextViewController.swift
//  ShengwangChatApiExample
//
//  Created by 朱继超 on 2022/6/20.
//

import UIKit
import ZSwiftBaseLib

final class AgoraChatSendTextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, AgoraChatClientDelegate, AgoraChatManagerDelegate, UITextFieldDelegate {
    
    private var filePath = ""
    
    private var heightMap = Dictionary<String,CGFloat>()
    
    private var messages: [AgoraChatMessage] = [AgoraChatMessage]()
    
    private var conversation: AgoraChatConversation?
        
    private lazy var messagesList: UITableView = {
        UITableView(frame: CGRect(x: 0, y: ZNavgationHeight, width: ScreenWidth, height: ScreenHeight-ZNavgationHeight-40-CGFloat(ZBottombarHeight)), style: .plain).delegate(self).dataSource(self).tableFooterView(UIView()).separatorStyle(.none)
    }()
    
    private lazy var messageField: UITextField = {
        UITextField(frame: CGRect(x: 2, y: Int(ScreenHeight) - 40 - ZBottombarHeight, width: Int(ScreenWidth) - 4, height: 40)).delegate(self).layerProperties(.systemBlue, 2).placeholder("Send Text Message").cornerRadius(5).leftView(UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40)), .always)
    }()
    
    convenience init(_ conversationId: String) {
        self.init()
        self.conversation = AgoraChatClient.shared().chatManager?.getConversationWithConvId(conversationId)
        let messages = self.conversation?.loadMessagesStart(fromId: "", count: 50, searchDirection: .up) ?? []
        for message in messages {
            if message.body.type == .text {
                self.messages.append(message)
                if self.heightMap[message.messageId] ?? 0 <= 0 {
                    self.heightMap[message.messageId] = AgoraChatTextCell.contentHeight(message)+52
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubViews([self.messagesList,self.messageField])
        self.messageField.returnKeyType = .send
        AgoraChatClient.shared().add(self, delegateQueue: .main)
        AgoraChatClient.shared().chatManager?.add(self, delegateQueue: .main)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    deinit {
        AgoraChatClient.shared().removeDelegate(self)
        AgoraChatClient.shared().chatManager?.remove(self)
        NotificationCenter.default.removeObserver(self)
    }
}

extension AgoraChatSendTextViewController {
    
    //MARK: - UITableViewDelegate&UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message: AgoraChatMessage = self.messages[safe: indexPath.row]!
        return self.heightMap[message.messageId] ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: AgoraChatMessage = self.messages[safe: indexPath.row]!
        var cell = tableView.dequeueReusableCell(withIdentifier: "AgoraChatTextCell") as? AgoraChatTextCell
        if cell == nil {
            cell = AgoraChatTextCell(style: .subtitle, reuseIdentifier: "AgoraChatTextCell")
        }
        cell?.updateLayout(message: message)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        guard let text = textField.text else { return false }
        self.sendTextMessage(text)
        textField.text = ""
        return true
    }
    
    private func sendTextMessage(_ text: String) {
        let to = self.conversation?.conversationId ?? ""
        let message = AgoraChatMessage(conversationID: to, from: AgoraChatClient.shared().currentUsername!, to: to, body: AgoraChatTextMessageBody(text: text), ext: [:])
        AgoraChatClient.shared().chatManager?.send(message, progress: nil) { [weak self] sendMessage, error in
            guard let self = self else { return }
            if error == nil {
                if self.heightMap[message.messageId] ?? 0 <= 0 {
                    self.heightMap[message.messageId] = AgoraChatTextCell.contentHeight(message)+52
                }
                self.messages.append(message)
                self.messagesList.reloadData()
            } else {
                print("\(error?.errorDescription ?? "")")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.keyboardRaiseAnimation()
    }
        
    //MARK: - AgoraChatManagerDelegate
    func messagesDidReceive(_ aMessages: [AgoraChatMessage]) {
        self.messages.append(contentsOf: aMessages)
        DispatchQueue.main.async {
            self.messagesList.reloadData()
            self.messagesList.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    private func keyboardRaiseAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.messageField.frame = CGRect(x: 10, y: Int(ScreenHeight) - 40 - ZBottombarHeight, width: Int(ScreenWidth) - 20, height: 40)
        }
    }
    
    @objc private func showKeyboard(notify: Notification) {
        guard let frame = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        UIView.animate(withDuration: 0.25) {
            self.messageField.frame = CGRect(x: 10, y: Int(ScreenHeight) - 40 - Int(frame.cgRectValue.height), width: Int(ScreenWidth) - 20, height: 40)
        }
    }
}


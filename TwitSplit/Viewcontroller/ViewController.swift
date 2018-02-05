//
//  ViewController.swift
//  TwitSplit
//
//  Created by Mettamdaica on 1/30/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit
import CoreData

class ViewController: BaseViewController {

    @IBOutlet weak var inputTextView: RSKGrowingTextView!
    @IBOutlet weak var inputTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    fileprivate var chunks: [String] = []
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        // setup inputTextview
        inputTextView.placeholder = Constant.textViewPlaceholder as NSString
        inputTextView.layer.cornerRadius = 5                
        
        // setup tableview
        let cellNib = UINib(nibName: MessageTableViewCell.cellID, bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: MessageTableViewCell.cellID)
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 72
        
        // reload data from coredata
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        do {
            let message = try PersistenService.context.fetch(fetchRequest)
            for message in message {
                self.chunks.append(message.chunk!)
                self.tableview.reloadData()
            }
        } catch {}
    }

    // MARK: Keyboard
    override func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        inputTextViewBottomConstraint.constant = keyboardFrame.size.height + 10
        UIView.animate(withDuration: 0.2, animations: {
          self.view.layoutIfNeeded()
        })

    }
    
    override func keyboardWillHide(notification: NSNotification) {
        inputTextViewBottomConstraint.constant = 10
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnSend(_ sender: Any) {
        switch MessageManager.isMessageValid(message: inputTextView.text) {
        case .invalidCharacter:
            inputTextView.text = ""
            return
        case .invalidLength:
            let alert = UIAlertHepler.alertController(title: Constant.invalidMessageAlertTitle, message: Constant.invalidMessageAlertMessage, cancel: "OK", others: nil, handleAction: nil)
            self.present(alert, animated: true, completion: nil)
            return
        case .valid:
            // clear text view and split message in background thread
            guard let inputText = self.inputTextView.text else {
                return
            }
            self.inputTextView.text = ""
            DispatchQueue.global().async {
                let splitedChunks = MessageManager.splitMessage(inputMessage: inputText)
                // save splited message
                for chunk in splitedChunks {
                    let message = Message(context: PersistenService.context)
                    message.chunk = chunk
                    PersistenService.saveContext()
                }
                self.chunks += splitedChunks
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    // Move to bottom of tableview
                    let indexPath = NSIndexPath(row: self.chunks.count - 1, section: 0)
                    self.tableview.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                }
            }
        }
    }
}

// MARK: Tableview
extension  ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chunks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.cellID, for: indexPath) as! MessageTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero        
        cell.lbMessage.text = chunks[indexPath.row]
        
        return cell
    }
}


//
//  ViewController.swift
//  TwitSplit
//
//  Created by Mettamdaica on 1/30/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var inputTextView: RSKGrowingTextView!
    @IBOutlet weak var inputTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    fileprivate var chunks: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Keyboard Notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // setup inputTextview
        inputTextView.placeholder = "Enter text here....."
        inputTextView.layer.cornerRadius = 5
        
        // add dismiss keyboard gesture
        self.view.addDismissKeyboardGesture()
        
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
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        inputTextViewBottomConstraint.constant = keyboardFrame.size.height + 10
        UIView.animate(withDuration: 0.2, animations: {
          self.view.layoutIfNeeded()
        })

    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        inputTextViewBottomConstraint.constant = 10
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnSend(_ sender: Any) {
        // remove whitespace from beggin and end of message
        let inputMessage = inputTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if inputMessage.isEmpty {
            inputTextView.text = ""
            return
        }
        
        // display error if the message contains a span of non-whitespace characters longer than 50 characters
        if !inputMessage.isInputMessageValid() {
            let alert = UIAlertController(title: "Please try again", message: "The message contains a span of non-whitespace characters longer than 50 characters.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // clear text view and split message in background thread to improve performance
        self.inputTextView.text = ""
        DispatchQueue.global().async {
            let splitedChunks = MessageSpitManager.init().splitMessage(inputMessage: inputMessage)
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


//
//  ViewController.swift
//  TwitSplit
//
//  Created by Mettamdaica on 1/30/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import UIKit

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        chunks += splitMessage(inputMessage: inputTextView.text)
        inputTextView.text = ""
        tableview.reloadData()
        // Move to bottom of tableview
        let indexPath = NSIndexPath(row: chunks.count - 1, section: 0)
        tableview.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    // MARK: Split message
    func splitMessage(inputMessage: String) -> [String] {
        // if input string length < 50 -> return
        if inputMessage.count < 50 {
            return [inputMessage]
        }
        // estimate number of chunk
        var numberOfChunk = Int(round(Double(Double(inputMessage.count)/50)))
        // start split message with estimate numberOfChunk. If the message can not be splited try again with numberOfChunk+1
        var chunks = splitWith(message: inputMessage, numberOfChunk: numberOfChunk)
        if chunks.count == 0 {
            numberOfChunk += 1
            chunks = splitWith(message: inputMessage, numberOfChunk: numberOfChunk)
        }
        return chunks
    }
    
    func splitWith(message : String, numberOfChunk : Int) -> [String] {
        var chunks = [String]()
        // Messages will only be split on whitespace
        var inputMessageArr = message.split(separator: " ")
        
        // create chunk with numberOfChunk
        for index in 1...numberOfChunk {
            // create part indicator
            var chunk = String(format: "%d/%d",index, numberOfChunk)
            // create chunk
            while(chunk.count < 50 && inputMessageArr.count > 0) {
                // part indicator count toward the character limit.
                // +1 is a white space
                if chunk.count + inputMessageArr[0].count + 1 < 50 {
                    // add word into chunk
                    chunk = String(format: "%@ %@",chunk, String(inputMessageArr[0]))
                    inputMessageArr.remove(at: 0)
                } else {
                    break
                }
            }
            chunks.append(chunk)
        }
        
        if inputMessageArr.count == 0 {
            return chunks
        }
        
        return [String]()
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


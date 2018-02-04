//
//  MessageSplitManager.swift
//  TwitSplit
//
//  Created by Mettamdaica on 2/4/18.
//  Copyright © 2018 Mettamdaica. All rights reserved.
//

import Foundation

enum MessageValidation : String {
    case valid
    case invalidLength
    case invalidCharacter
}

class MessageManager {        
    // MARK: Split message
    static func splitMessage(inputMessage: String) -> [String] {
        // if input string length < 50 -> return
        if inputMessage.count < Constant.chunkMaxLength {
            return [inputMessage]
        }
        // estimate number of chunk
        var numberOfChunk = Int(round(Double(Double(inputMessage.count)/50)))
        
        // start split message with estimate numberOfChunk. If the message can not be splited try again with numberOfChunk+1
        var chunks = splitWith(message: inputMessage, numberOfChunk: numberOfChunk)
        while (chunks.count == 0) {
            numberOfChunk += 1
            chunks = splitWith(message: inputMessage, numberOfChunk: numberOfChunk)
        }
        return chunks
    }
    
    static func splitWith(message : String, numberOfChunk : Int) -> [String] {
        var chunks = [String]()
        // Messages will only be split on whitespace
        var inputMessageArr = message.split(separator: " ")
        
        // create chunk with numberOfChunk
        for index in 1...numberOfChunk {
            // create part indicator
            var chunk = String(format: "%d/%d",index, numberOfChunk)
            // create chunk
            while(chunk.count < Constant.chunkMaxLength && inputMessageArr.count > 0) {
                // part indicator count toward the character limit.
                // +1 is a white space
                if chunk.count + inputMessageArr[0].count + 1 < Constant.chunkMaxLength {
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
    
    // MARK: check input
    static func isMessageValid(message : String?) -> MessageValidation {
        guard let message = message else {
            return MessageValidation.invalidCharacter
        }
        
        let newMessage = message.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if newMessage.isEmpty {
            return MessageValidation.invalidCharacter
        }

        let inputMessageArr = newMessage.split(separator: " ")
        for word in inputMessageArr {
            if String(word).count > Constant.wordMaxLength {
                return MessageValidation.invalidLength
            }
        }
        
        return MessageValidation.valid
    }
}

//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright (c) 2014 vluxe. All rights reserved.
//

import ReactiveCocoa
import ReactiveStarscream
import UIKit

class ViewController: UIViewController {
    var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/")!, protocols: ["chat", "superchat"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.textEvents
            |> map { return "Recieved text: \($0)" }
            |> observe(next: println)
        
        socket.dataEvents
            |> map { return "Recieved data: \($0.length)" }
            |> observe(next: println)
        
        socket.textEvents
            |> observe(error: { println("websocket is disconnected: \($0.localizedDescription)") })
        
        socket.connect()
    }
    
    // MARK: Write Text Action
    
    @IBAction func writeText(sender: UIBarButtonItem) {
        socket.writeString("hello there!")
    }
    
    // MARK: Disconnect Action
    
    @IBAction func disconnect(sender: UIBarButtonItem) {
        if socket.isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
    
}


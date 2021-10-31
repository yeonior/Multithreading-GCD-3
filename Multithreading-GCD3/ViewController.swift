//
//  ViewController.swift
//  Multithreading-GCD3
//
//  Created by ruslan on 30.10.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    private enum QueueState {
        case inactive
        case active
        case suspended
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private let queue = DispatchQueue(label: "inactive", attributes: [.initiallyInactive])
    private var state: QueueState = .inactive
    private var number = 0 {
        didSet {
            DispatchQueue.main.sync {
                label.text = number.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 15
    }
    
    private func setUpTitleForButton(finalBlock: Bool = false) {
        if !finalBlock {
            if self.state == .suspended {
                self.button.setTitle("Continue", for: .normal)
                self.button.titleLabel?.alpha = 1.0
                self.button.isEnabled = true
            }
        } else if finalBlock {
            self.button.setTitle("Reset", for: .normal)
            self.button.titleLabel?.alpha = 1.0
            self.button.isEnabled = true
        }
    }
    
    private func setUpQueueBlock(from: Int, to: Int, withEmoji: String, finalBlock: Bool = false, extraBlock: (() -> Void)? = nil) {
        queue.async {
            for i in from...to {
                self.number = i
                print(withEmoji + " = \(i)", Thread.current)
            }
            DispatchQueue.main.sync {
                if let extraBlock = extraBlock {
                    extraBlock()
                }
                self.setUpTitleForButton(finalBlock: finalBlock)
            }
        }
    }
    
    private func setUpQueue() {
        setUpQueueBlock(from: 1, to: 1000, withEmoji: "❤️")
        setUpQueueBlock(from: 1001, to: 2000, withEmoji: "🧡")
        setUpQueueBlock(from: 2001, to: 3000, withEmoji: "💚")
        setUpQueueBlock(from: 3001, to: 4000, withEmoji: "💙", finalBlock: true) {
            if self.state == .suspended {
                self.queue.resume()
            }
            self.state = .inactive
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch state {
        case .inactive:
            setUpQueue()
            queue.activate()
            state = .active
            button.setTitle("Pause", for: .normal)
        case .active:
            queue.suspend()
            state = .suspended
            button.setTitle("Wait...", for: .normal)
            button.titleLabel?.alpha = 0.5
            button.isEnabled = false
        case .suspended:
            queue.resume()
            state = .active
            button.setTitle("Pause", for: .normal)
        }
    }
}


//
//  ViewController.swift
//  Multithreading-GCD3
//
//  Created by ruslan on 30.10.2021.
//

import UIKit

final class ViewController: UIViewController {
        
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private let inactiveQueue = DispatchQueue(label: "inactive", attributes: [.concurrent, .initiallyInactive])
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
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
    }
}


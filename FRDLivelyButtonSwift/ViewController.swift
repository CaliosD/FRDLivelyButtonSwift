//
//  ViewController.swift
//  FRDLivelyButtonSwift
//
//  Created by Calios on 8/18/17.
//  Copyright © 2017 Calios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var caretButton = FRDLivelyButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		caretButton.backgroundColor = UIColor.orange
		caretButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
		view.addSubview(caretButton)
		
		caretButton.setStyle(.caretUp, animated: false)
	}
	
	func buttonPressed(_ sender: FRDLivelyButton) {

		if sender.buttonStyle == .caretUp {
			sender.setStyle(.caretDown, animated: true)
		} else {
			sender.setStyle(.caretUp, animated: true)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


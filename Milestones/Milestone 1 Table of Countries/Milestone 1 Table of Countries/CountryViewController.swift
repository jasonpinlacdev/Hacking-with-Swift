//
//  CountryViewController.swift
//  Milestone 1 Table of Countries
//
//  Created by Jason Pinlac on 10/30/19.
//  Copyright © 2019 Jason Pinlac. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
	
	var countrySelected: String?
	@IBOutlet var countryImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = countrySelected!
		navigationItem.largeTitleDisplayMode = .never
		countryImageView.image = UIImage(named: countrySelected!)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}


}

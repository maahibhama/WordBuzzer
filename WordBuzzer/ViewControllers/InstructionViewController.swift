//
//  InstructionViewController.swift
//  WordBuzzer
//
//  Created by Maahi Bhama  on 10/10/19.
//  Copyright © 2019 Mahendra Bhama. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    
    //MARK:- Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var instructionArray: [String] = []
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setDataSource()
    }
    
    
    //MARK:- Helper Methods
    func setUpUI() {
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: AppConstants.InstructionTableViewCell, bundle: nil), forCellReuseIdentifier: AppConstants.InstructionTableViewCell)
    }
    
    func setDataSource() {
        self.instructionArray = AppConstants.GameInstruction
        self.tableView.reloadData()
    }
    
}


//MARK:- Table View Methods
extension InstructionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: InstructionTableViewCell = tableView.dequeueReusableCell(withIdentifier: AppConstants.InstructionTableViewCell, for: indexPath) as! InstructionTableViewCell
        
        cell.instructionLabel.text = self.instructionArray[indexPath.row]
        
        return cell
    }
}

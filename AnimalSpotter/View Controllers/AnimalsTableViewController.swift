//
//  AnimalsTableViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalsTableViewController: UITableViewController {
    
    private var animalNames: [String] = []
    
    let apiController = APIController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // transition to login view if conditions require
        if self.apiController.bearer == nil {
            performSegue(withIdentifier: "LoginViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animalNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.animalNames[indexPath.row]

        return cell
    }

    // MARK: - Actions
    @IBAction func getAnimals(_ sender: UIBarButtonItem) {
        // fetch all animals from API
        self.apiController.fetchAllAnimalNames { (result) in
            if let names = try? result.get() {
                DispatchQueue.main.async {
                    self.animalNames = names
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnimalDetailSegue" {
            // inject dependencies
            guard let animalDVC = segue.destination as? AnimalDetailViewController else { return }
            animalDVC.apiController = self.apiController
        }
        else if segue.identifier == "LoginViewModalSegue" {
            // inject dependencies
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.apiController = self.apiController
        }
    }
}

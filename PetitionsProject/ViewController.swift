//
//  ViewController.swift
//  PetitionsProject
//
//  Created by Rodrigo on 22-10-24.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() { 
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptSearch))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                filteredPetitions = petitions
                return
            }
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Error Loading Data", message: "There was an error while loading the data", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let response = try? decoder.decode(Petitions.self, from: json) {
            petitions = response.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func promptSearch() {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchAction = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            guard let word = ac?.textFields?[0].text else { return }
            
            self?.searchPetition(word: word)
        }
        
        ac.addAction(searchAction)
        present(ac, animated: true)
    }
    
    func searchPetition(word: String) {
        filteredPetitions = petitions.filter({ $0.title.contains(word) })
        tableView.reloadData()
    }
}


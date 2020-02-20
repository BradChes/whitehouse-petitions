//
//  ViewController.swift
//  whitehouse-petitions
//
//  Created by Bradley Chesworth on 14/02/2020.
//  Copyright © 2020 Brad Chesworth. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allPetitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
        
        performSelector(inBackground: #selector(fetchJson), with: nil)
    }
    
    @objc private func fetchJson(urlString: String) {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc private func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; Please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)
    }
    
    @objc private func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This data has come from the 'We The People' API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)
    }
    
    @objc private func showFilter() {
        let ac = UIAlertController(title: "Filter?", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let term = ac?.textFields?[0].text else { return }
            self?.filter(term)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    private func filter(_ term: String) {
        if(!term.isEmpty) {
            filteredPetitions.removeAll()
            
            for petition in allPetitions {
                if petition.title.range(of: term, options: .caseInsensitive) != nil || petition.body.range(of: term, options: .caseInsensitive) != nil {
                    filteredPetitions.append(petition)
                }
            }
        } else {
            filteredPetitions = allPetitions
        }
        tableView.reloadData()
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()

        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            filteredPetitions = allPetitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
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
}

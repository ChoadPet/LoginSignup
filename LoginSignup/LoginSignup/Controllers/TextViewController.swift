//
//  TextViewController.swift
//  LoginSignup
//
//  Created by Vetaliy Poltavets on 3/15/18.
//  Copyright © 2018 vpoltave. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var CustonTableView: UITableView!
    @IBOutlet weak var numberOfCharsLbl: UILabel!

    var letterCount = [Character: Int]()
    var uniqueOfLetters = Set<Character>()
    var sortedArray = Array<Character>()
    let sortVal = SortManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkManager.getText { [weak self] (success, text) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let strongSelf = self else { return }
            if success {
                strongSelf.SortData(text)
                strongSelf.CustonTableView.reloadData()
            } else {
                strongSelf.numberOfCharsLbl.text = "Some error!"
            }
        }
    }
    
    func SortData(_ text: String) {
        uniqueOfLetters = Set<Character>(text)
        sortedArray = Array<Character>(uniqueOfLetters)
        sortedArray = sortedArray.sorted(by: { (c1, c2) -> Bool in
            sortVal.customSort(c1, c2)
        })
        print(sortedArray)
        Array<Character>(text).forEach { letterCount[$0, default: 0] += 1 }
        numberOfCharsLbl.text = "Characters: \(uniqueOfLetters.count)"
    }

    @IBAction func LogOutPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "navigationController")
        
        UserDefaults.standard.set(nil, forKey: "access_token")
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}

extension TextViewController {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueOfLetters.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = CustonTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TextOutputTableViewCell {
            let str = "<\"\(sortedArray[indexPath.row])\" - \(letterCount[sortedArray[indexPath.row]] ?? 0) times>"
            cell.letterInfoLbl.text = str
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


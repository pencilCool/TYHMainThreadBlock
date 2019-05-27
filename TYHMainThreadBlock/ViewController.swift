//
//  ViewController.swift
//  TYHMainThreadBlock
//
//  Created by pencilCool on 2019/5/21.
//  Copyright © 2019 pencilCool. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
//        let nib = UINib(nibName: "cell", bundle: nil)
//        self.tableView.register(nib, forCellReuseIdentifier:"cell")
//
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        doSomeHardTing()
        return cell
    }
    
    func doSomeHardTing() {
        usleep(1000 * 30)
    }
    

}


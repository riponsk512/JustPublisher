//
//  ViewController.swift
//  JustPublisher
//
//  Created by Ripon sk on 08/10/22.
//

import UIKit
import Combine
struct User:Codable{
    var name:String?
}
class ViewController: UIViewController {
    var users = [String]()
    var observer:AnyCancellable?
    @IBOutlet weak var tableviews: UITableView!
    private var arrUser = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
     observer = fetchdata().receive(on: DispatchQueue.main).sink { user in
            self.arrUser = user
            self.tableviews.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    func fetchdata() -> AnyPublisher<[User],Never>{
        
        guard let urls = url  else{
            return Just([]).eraseToAnyPublisher()
        }
      return  URLSession.shared.dataTaskPublisher(for: urls).map{$0.data}.decode(type: [User].self, decoder: JSONDecoder()).catch{ _ in
            return Just([])
        }.eraseToAnyPublisher()
            
    }
   
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrUser[indexPath.row].name
        return cell
    }
    
    
}

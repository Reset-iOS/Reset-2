import UIKit

class ContactsViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    var searchController: UISearchController!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the search controller
        setupSearchController()
        
        // Load initial contacts
        contacts = ContactManager.shared.contacts
        
        tableView.register(UINib(nibName: "ContactsTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        
        // Optional: Add title to navigation bar
        title = "Sponsors"
    }
    
    // MARK: - Search Controller Setup
    private func setupSearchController() {
        // Create the search results view controller (in this case, we'll use the same view controller)
        searchController = UISearchController(searchResultsController: nil)
        
        // Configure the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sponsors"
        
        // Explicitly configure search bar
        searchController.searchBar.delegate = self
        
//        // Alternative method to add search bar
//        tableView.tableHeaderView = searchController.searchBar
        
        // Optional: Configure search bar appearance
        searchController.searchBar.sizeToFit()
        
//         If you want it in navigation bar (alternative to table header)
         navigationItem.searchController = searchController
         navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        // Get the search text
        guard let searchText = searchController.searchBar.text else { return }
        
        // Filter contacts
        filteredContacts = ContactManager.shared.searchContacts(with: searchText)
        
        // Reload the table view
        tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate (Optional, but can be useful)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredContacts = ContactManager.shared.searchContacts(with: searchText)
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Use filtered contacts if search is active, otherwise use all contacts
        return searchController.isActive ? filteredContacts.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactsTableViewCell else {
                    fatalError("Unable to dequeue ContactTableViewCell")
                }
                
                // Determine which contacts array to use based on search state
        let currentContacts = searchController.isActive ? filteredContacts : []
        let contact = currentContacts[indexPath.row]
                
                // Configure the cell
        cell.configure(with: contact)
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        // Instantiate DetailViewController from the storyboard
        let detailVC = storyboard.instantiateViewController(identifier: "Detail") as! DetailViewController
        let user = filteredContacts[indexPath.row]
        detailVC.contact = user
        
        // Push DetailViewController onto the navigation stack
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

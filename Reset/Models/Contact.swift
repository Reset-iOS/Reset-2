//
//  Contact.swift
//  Reset
//
//  Created by Prasanjit Panda on 30/11/24.
//


struct Contact {
    let name: String
    let phone: String
    let email: String
    let profile: String
}

class ContactManager {
    static let shared = ContactManager()
    
    private init() {}
    
    let contacts: [Contact] = [
        Contact(name: "John Doe", phone: "555-1234", email: "john.doe@example.com",profile: "Emily"),
        Contact(name: "Jane Smith", phone: "555-5678", email: "jane.smith@example.com",profile: "Emily"),
        Contact(name: "Alice Johnson", phone: "555-9012", email: "alice.johnson@example.com",profile: "Emily"),
        Contact(name: "Bob Williams", phone: "555-3456", email: "bob.williams@example.com",profile: "Emily"),
        Contact(name: "Emma Brown", phone: "555-7890", email: "emma.brown@example.com",profile: "Emily"),
        Contact(name: "Michael Davis", phone: "555-2345", email: "michael.davis@example.com",profile: "Emily"),
        Contact(name: "Sarah Miller", phone: "555-6789", email: "sarah.miller@example.com",profile: "Emily")
    ]
    
    var support: [Contact] = []
    
    func searchContacts(with searchText: String) -> [Contact] {
        guard !searchText.isEmpty else { return contacts }
        
        return contacts.filter { contact in
            contact.name.localizedCaseInsensitiveContains(searchText) ||
            contact.phone.contains(searchText) ||
            contact.email.localizedCaseInsensitiveContains(searchText)
        }
    }
}

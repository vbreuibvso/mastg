// SUMMARY: This sample demonstrates insecure object persistence using NSCoding instead of NSSecureCoding, and storing sensitive data without encryption.

import Foundation

// FAIL: [MASTG-TEST-0313] Using NSCoding instead of NSSecureCoding allows type confusion attacks during deserialization.
class UserCredentials: NSObject, NSCoding {
    var username: String
    var password: String  // Sensitive data stored without encryption
    var authToken: String
    
    init(username: String, password: String, authToken: String) {
        self.username = username
        self.password = password
        self.authToken = authToken
        super.init()
    }
    
    // FAIL: [MASTG-TEST-0313] NSCoding does not validate object types during deserialization
    func encode(with coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(password, forKey: "password")
        coder.encode(authToken, forKey: "authToken")
    }
    
    required convenience init?(coder: NSCoder) {
        // No type validation - vulnerable to type confusion attacks
        guard let username = coder.decodeObject(forKey: "username") as? String,
              let password = coder.decodeObject(forKey: "password") as? String,
              let authToken = coder.decodeObject(forKey: "authToken") as? String else {
            return nil
        }
        self.init(username: username, password: password, authToken: authToken)
    }
}

struct MastgTest {
    static func mastgTest(completion: @escaping (String) -> Void) {
        // Create credentials with sensitive data
        let credentials = UserCredentials(
            username: "admin",
            password: "SuperSecretPassword123!",
            authToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.secrettoken"
        )
        
        // Get documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("credentials.archive")
        
        do {
            // FAIL: [MASTG-TEST-0313] Storing sensitive data without encryption using NSKeyedArchiver
            let data = try NSKeyedArchiver.archivedData(withRootObject: credentials, requiringSecureCoding: false)
            try data.write(to: archiveURL)
            
            // Read back the archived data
            let readData = try Data(contentsOf: archiveURL)
            
            // FAIL: [MASTG-TEST-0313] Deserializing without secure coding validation
            if let loadedCredentials = try NSKeyedUnarchiver.unarchivedObject(ofClass: UserCredentials.self, from: readData) {
                completion("""
                Credentials archived and loaded successfully (INSECURE):
                Username: \(loadedCredentials.username)
                Password: \(loadedCredentials.password)
                Token: \(loadedCredentials.authToken)
                File path: \(archiveURL.path)
                """)
            }
        } catch {
            completion("Error: \(error.localizedDescription)")
        }
    }
}

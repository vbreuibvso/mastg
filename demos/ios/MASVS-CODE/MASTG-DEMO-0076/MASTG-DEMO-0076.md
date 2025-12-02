---
platform: ios
title: Insecure Object Persistence Using NSCoding
code: [swift]
id: MASTG-DEMO-0076
test: MASTG-TEST-0313
---

### Sample

The code snippet below shows an insecure implementation of object persistence using `NSCoding` instead of `NSSecureCoding`. The `UserCredentials` class stores sensitive data (password and authentication token) and archives it without encryption.

{{ MastgTest.swift }}

### Steps

1. Unzip the app package and locate the main binary file (@MASTG-TECH-0058), which in this case is `./Payload/MASTestApp.app/MASTestApp`.
2. Run the r2 script to identify object persistence APIs.

{{ nscoding.r2 }}

{{ run.sh }}

### Observation

The output shows the use of `NSKeyedArchiver` and `NSKeyedUnarchiver` for object persistence, along with the `encode` and `init(coder:)` methods from the `NSCoding` protocol.

{{ output.txt }}

### Evaluation

The test fails for the following reasons:

1. **Insecure deserialization protocol**: The `UserCredentials` class uses `NSCoding` instead of `NSSecureCoding`. This means the app does not validate the class type during deserialization, making it vulnerable to type confusion attacks where an attacker could substitute a malicious object.

2. **Sensitive data without encryption**: The password and authentication token are stored in plaintext in the archived file. An attacker with access to the device's file system or backups could extract these credentials.

3. **No integrity verification**: The archived data lacks HMAC or digital signature verification, allowing attackers to modify the serialized data without detection.

To fix these issues, the app should:

- Implement `NSSecureCoding` with `supportsSecureCoding = true`
- Use `decodeObject(of:forKey:)` instead of `decodeObject(forKey:)`
- Encrypt sensitive data before archiving
- Add HMAC verification for data integrity

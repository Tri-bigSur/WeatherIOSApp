//
//  HandleData.swift
//  Weather
//
//  Created by warbo on 16/11/25.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        // 1. Locate the fule in the app bundle
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("Fail to locate \(file) in bundle.")
        }
        // 2. Load the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Fail to load \(file) from bundle.")
        }
        // 3. Decode the data into the specified type (T)
        let decoder = JSONDecoder()
//        guard let decoded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Fail to decode \(file) from bundle.")
//            
//        }
        // 4. Return the ready Swift object
//        return decoded
        do{
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            // ❌ This tells you which key is missing
            fatalError(" Failed to decode \(file) from bundle: Missing key '\(key.stringValue)' - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            // ❌ This tells you which type failed (e.g., Int when it should be Double)
            fatalError("❌ Failed to decode \(file) from bundle: Type Mismatch for type '\(type)' - \(context.debugDescription)")
        } catch {
            // ❌ General error (e.g., malformed JSON)
            fatalError("❌ Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}

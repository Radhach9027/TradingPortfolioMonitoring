//
//  JsonDecoder+extensions.swift
//  BarakaMobileAssignment
//
//  Created by radha chilamkurthy on 24/09/25.
//

import Foundation

enum JSONDecodingError: LocalizedError {
    case conversionError(String)
    
    var errorDescription: String? {
        switch self {
        case .conversionError(let message):
            return "Decoding Failed: \(message)"
        }
    }
}

func jsonCodableConversionError(_ message: String) -> JSONDecodingError {
    return .conversionError(message)
}

extension JSONDecoder {
    static func dataDecoding<T: Decodable>(
        codable: T.Type,
        data: Data
    ) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            switch error {
            case let .dataCorrupted(context):
                throw jsonCodableConversionError("Data corrupted: \(context.debugDescription)")
                
            case let .keyNotFound(key, context):
                throw jsonCodableConversionError(
                    "Key '\(key.stringValue)' not found: \(context.debugDescription) in '\(T.self)'"
                )
                
            case let .valueNotFound(value, context):
                throw jsonCodableConversionError(
                    "Value '\(value)' not found: \(context.debugDescription) in '\(T.self)'"
                )
                
            case let .typeMismatch(type, context):
                throw jsonCodableConversionError(
                    "Type '\(type)' mismatch: \(context.debugDescription) in '\(T.self)'"
                )
                
            @unknown default:
                throw jsonCodableConversionError("Unknown decoding error in '\(T.self)': \(error.localizedDescription)")
            }
            
        } catch {
            throw jsonCodableConversionError("Unexpected error: \(error.localizedDescription)")
        }
    }
}

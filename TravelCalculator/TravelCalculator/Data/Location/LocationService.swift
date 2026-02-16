//
//  LocationService.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

import CoreLocation

protocol LocationServiceProtocol {
    func fetchCountryCode() async throws -> String
}

final class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func fetchCountryCode() async throws -> String {
        let location = try await requestLocation()
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)

        guard let countryCode = placemarks.first?.isoCountryCode else {
            throw LocationError.geocodingFailed
        }
        return countryCode
    }
    
    private func requestLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        continuation?.resume(returning: location)
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
    
    // MARK: - Error
    
    enum LocationError: LocalizedError {
        case geocodingFailed

        var errorDescription: String? {
            switch self {
            case .geocodingFailed: return "위치 정보를 확인할 수 없습니다."
            }
        }
    }
}

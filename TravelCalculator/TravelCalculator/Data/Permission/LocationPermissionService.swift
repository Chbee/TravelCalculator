//
//  LocationPermissionService.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

import CoreLocation

final class LocationPermissionService: NSObject, PermissionService, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<PermissionStatus, Never>?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func status() -> PermissionStatus {
        mapStatus(manager.authorizationStatus)
    }
    
    func request() async -> PermissionStatus {
        let current = status()
        guard current == .notDetermined else { return current }

        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }
    
    private func mapStatus(_ status: CLAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorizedWhenInUse, .authorizedAlways: return .granted
        default: return .denied
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        continuation?.resume(returning: mapStatus(manager.authorizationStatus))
        continuation = nil
    }
}

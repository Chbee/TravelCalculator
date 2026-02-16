//
//  PermissionService.swift
//  TravelCalculator
//
//  Created by 손지영 on 2/16/26.
//

// 권한 종류
enum PermissionType {
    case location
}

enum PermissionStatus {
    case notDetermined
    case granted
    case denied
}

protocol PermissionService {
    func status() -> PermissionStatus
    func request() async -> PermissionStatus
}

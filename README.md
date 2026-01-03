# 💱 TravelCalculator
여행지에서 사용할 계산기를 만드는 iOS 앱입니다.  
SwiftUI와 MVI 아키텍처를 중심으로 설계하고, 학습과 실험을 함께 진행합니다.

## ✨ 프로젝트 개요
- 여행 중 가격/환율 계산을 빠르게 처리하는 계산기 앱
- MVI와 SwiftUI를 활용해 화면 상태와 사용자 입력 흐름을 명확히 관리

## ✅ 목표
- MVI 기반 상태 관리 흐름 설계와 적용
- SwiftUI로 빠르고 직관적인 UI 구성
- 실사용 시나리오에 맞는 계산 로직 구성

## 🧪 테스트 계획
- XCTest로 비동기/네트워크 처리 테스트 (예정, 상황에 따라 조정될 수 있음)
- UI 테스트로 핵심 플로우 검증 (예정)

## 🗺️ 진행 방식
- 요구사항 정리 → 화면/상태 설계 → 기능 구현 → 테스트 보강 순서로 진행
- 핵심 흐름부터 구현하고, 점진적으로 기능 확장

## 🏗️ 아키텍처
- MVI (Model-View-Intent) 패턴 적용
- 단방향 데이터 흐름과 예측 가능한 상태 전이를 목표로 구성

## 📁 폴더 구조
```
TravelCalculator/
├── Core/                    # 공통 유틸리티
│   ├── DI/                  # 의존성 주입
│   └── Extensions/          # Swift 확장
│
├── Domain/                  # 비즈니스 로직 (Model)
│   ├── Models/              # 데이터 모델
│   ├── UseCases/            # 비즈니스 로직
│   └── Repositories/        # Repository 프로토콜
│
├── Data/                    # 데이터 레이어
│   ├── Network/             # API 클라이언트
│   ├── Firebase/            # Firebase 캐싱
│   ├── Location/            # 위치 서비스
│   ├── Local/               # 로컬 저장소
│   └── RepositoryImpl/      # Repository 구현체
│
└── Presentation/            # UI 레이어 (View + Intent)
    ├── Calculator/          # 계산기 화면
    ├── ExchangeRate/        # 환율 정보 화면
    ├── Settings/            # 설정 화면
    └── Components/          # 재사용 UI 컴포넌트
```

## 🛠️ 기술 스택
- SwiftUI
- MVI
- iOS 15.0+

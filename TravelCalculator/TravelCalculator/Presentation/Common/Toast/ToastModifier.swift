//
//  ToastModifier.swift
//  TravelCalculator
//
//  Created by RadCNS_SonJiYoung on 2/12/26.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var payload: ToastPayload?
    @State private var workItem: DispatchWorkItem?
    @State private var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    toastView().offset(y: -30)
                }.animation(.spring(), value: payload?.id)
            )
            .onAppear {
                feedbackGenerator.prepare()
                showToast()
            }
            .onChange(of: payload) { _, newValue in
                if newValue != nil {
                    showToast()
                } else {
                    dismissToast()
                }
            }
    }
    
    @ViewBuilder func toastView() -> some View {
        if let payload {
            GeometryReader { proxy in
                VStack {
                    Spacer()
                    ToastView(payload: payload)
                        .frame(width: proxy.size.width * 0.7)
                }
                .frame(width: proxy.size.width,
                       height: proxy.size.height)
            }
            .id(payload.id)
            .transition(
                .asymmetric(
                    insertion: .move(
                        edge: .bottom
                    ),
                    removal: .move(
                        edge: .bottom
                    )
                )
            )
        }
    }
    
    private func showToast() {
        guard let payload else { return }

        feedbackGenerator.impactOccurred()
        
        if payload.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + payload.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            payload = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toast(_ payload: Binding<ToastPayload?>) -> some View {
        self.modifier(ToastModifier(payload: payload))
    }
}

#Preview("Toast") {
    ToastModifierPreviewHost()
}

extension ToastStyle: CaseIterable {
    static var allCases: [ToastStyle] {
        [.success, .error, .warning, .info]
    }
}

extension ToastPayload {
    static func sample(style: ToastStyle) -> ToastPayload {
        switch style {
        case .success:
            return .init(style: .success, title: "성공", message: "저장되었습니다.")
        case .error:
            return .init(style: .error, title: "오류", message: "문제가 발생했습니다.")
        case .warning:
            return .init(style: .warning, title: "주의", message: "입력을 확인해주세요.")
        case .info:
            return .init(style: .info, title: "알림", message: "새로운 기능이 추가되었습니다.")
        }
    }
}

private struct ToastModifierPreviewHost: View {
    @State private var toast: ToastPayload?
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 12) {
                Text("토스트 메시지 테스트")
                    .font(.headline)
                
                ForEach(ToastStyle.allCases, id: \.self) { style in
                    Button("\(String(describing: style).capitalized) Toast") {
                        toast = .sample(style: style)
                    }
                }
            }
            .padding()
        }
        .toast($toast)
    }
}

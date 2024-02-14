//
//  LottieView.swift
//  DontForget
//
//  Created by 제나 on 2/9/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode
    @Binding var play: Bool
    
    let animationView: LottieAnimationView
    
    init(
        name: String,
        loopMode: LottieLoopMode = .playOnce,
        animationSpeed: CGFloat = 1,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        play: Binding<Bool> = .constant(true)
    ) {
        self.name = name
        self.animationView = LottieAnimationView(name: name)
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
        self._play = play
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(animationView)
        view.backgroundColor = .clear
        animationView.backgroundColor = .clear
        animationView.contentMode = contentMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 400), /// 높이 넒이 알잘딱하게 수정하시면됩니다.
            animationView.heightAnchor.constraint(equalToConstant: 390),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if play {
            animationView.play { _ in
                play = false
            }
        }
    }
}

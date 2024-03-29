//
//  CompassView.swift
//  Qibla
//
//  Created by shahid on 27/03/24.
//

import SwiftUI

struct CompassView: View {
    
    @ObservedObject var viewModel: QiblaViewModel
    @State var wave = false
    
    var body: some View {
        
        ZStack(){
            ZStack {
                //Top Circle
                VStack {
                    Circle()
                        .fill(Color("transparentGrey"))
                        .frame(width: 18, height: 18)
                        .offset(y: -9)
                        .opacity(viewModel.mode == .ahead ? 0 : 1)
                    
                    Spacer()
                }
                
                //SemiCircle
                ZStack {
                    if viewModel.mode == .right {
                        Circle()
                            .trim(from: 0.03, to: (viewModel.directionOfKabahTo360Format/360) - 0.03)
                            .rotation(Angle(degrees: -90))
                            .stroke(Color("semicircleGrey"), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    } else if viewModel.mode == .left {
                        Circle()
                            .trim(from:(viewModel.directionOfKabahTo360Format/360) + 0.03, to: 0.97)
                            .rotation(Angle(degrees: -90))
                            .stroke(Color("semicircleGrey"), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    }
                }
                
                // Aroow with top circle
                ZStack {
                    ZStack{
                        Circle().fill(.white).frame(width: viewModel.mode == .ahead ? 32 : 18, height: viewModel.mode == .ahead ? 32 : 18)
                        if viewModel.mode == .ahead {
                            PulsatingCircle(mode: $viewModel.mode)
                        }
                    }
                    .offset(y: -312/2)
                    Image(systemName: "arrow.up")
                        .font(.system(size: 192, weight: .bold))
                        .foregroundColor(.white)
                }
                .rotationEffect(viewModel.directionOfKabah)
            }
            .frame(maxWidth: .infinity, maxHeight: 312)
        }
    }
}

struct PulsatingCircle: View {
    
    @Binding var mode: Mode
    @State var animate = false
    
    var body: some View {
        ZStack{
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: mode == .ahead ? 32 * 6 : 16 * 6, height: mode == .ahead ? 32 * 6 : 16 * 6)
                .scaleEffect(animate ? 1 : 0)
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: mode == .ahead ? 32 * 3 : 16 * 3, height: mode == .ahead ? 32 * 3 : 16 * 3)
                .scaleEffect(animate ? 1 : 0)
        }
        .onAppear(){
            animate = true
        }
        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: true))
    }
}

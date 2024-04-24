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
        GeometryReader { geo in
            let smallerSide = geo.size.width < geo.size.height ? geo.size.width : geo.size.height
            
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
                
                // Arrow with top circle
                ZStack {
                    //top circle
                    ZStack{
                        ZStack{
                            Circle().fill(.white).frame(width: viewModel.mode == .ahead ? 32 : 18, height: viewModel.mode == .ahead ? 32 : 18)
                            Image("qibla")
                                .resizable()
                                .frame(width: Int(viewModel.directionOfKabahTo360Format) == 0 ? 20 : 16, height: Int(viewModel.directionOfKabahTo360Format) == 0 ? 20 : 16)
                                .opacity(viewModel.mode == .ahead ? 1 : 0)
                        }
                        if viewModel.mode == .ahead {
                            PulsatingCircle(mode: $viewModel.mode)
                        }
                    }
                    .offset(y: -(geo.size.width)/2)
                    
                    //arrow
                    Image(systemName: "arrow.up")
                        .font(.system(size: (geo.size.width) * 0.615, weight: .bold))
                        .foregroundColor(.white)
                }
                .rotationEffect(viewModel.directionOfKabah)
            }
            .frame(maxWidth: smallerSide, maxHeight: smallerSide)
            .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).maxY - smallerSide/2)
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
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                animate = true
            }
            
        }
    }
}

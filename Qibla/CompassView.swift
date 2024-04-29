//
//  CompassView.swift
//  Qibla
//
//  Created by shahid on 25/04/24.
//

import SwiftUI

struct CompassView: View {
    
    @ObservedObject var viewModel: QiblaViewModel
    @State var wave = false
    var mesurements = CompassComponentsMeasurements()
    
    var body: some View {
        GeometryReader { geo in
            let smallerSide = geo.size.width < geo.size.height ? geo.size.width : geo.size.height
            
            ZStack {
                //Top Circle
                VStack {
                    Circle()
                        .fill(Color("transparentGrey"))
                        .frame(width: mesurements.circleSize, height: mesurements.circleSize)
                        .offset(y: -mesurements.circleSize/2)
                        .opacity(viewModel.mode.isApproxQibla ? 0 : 1)
                    Spacer()
                }
                
                //SemiCircle
                ZStack {
                    if viewModel.mode == .right {
                        Circle()
                            .trim(
                                from: mesurements.semiCirclePadding,
                                  to: (viewModel.directionOfKabahTo360Format/360) - mesurements.semiCirclePadding
                            )
                            .rotation(Angle(degrees: -90))
                            .stroke(
                                Color("semicircleGrey"),
                                style: StrokeStyle(lineWidth: mesurements.semiCircleLineWidth,lineCap: .round)
                            )
                    } else if viewModel.mode == .left {
                        Circle()
                            .trim(
                                from:(viewModel.directionOfKabahTo360Format/360) + mesurements.semiCirclePadding,
                                to: 1 - mesurements.semiCirclePadding
                            )
                            .rotation(Angle(degrees: -90))
                            .stroke(
                                Color("semicircleGrey"),
                                style: StrokeStyle(lineWidth: mesurements.semiCircleLineWidth, lineCap: .round)
                            )
                    }
                }
                
                // Arrow with top circle
                ZStack {
                    //top circle
                    ZStack{
                        ZStack{
                            Circle().fill(.white)
                                .frame(
                                    width: viewModel.mode.isApproxQibla ? mesurements.circleSizeExpanded : mesurements.circleSize,
                                    height: viewModel.mode.isApproxQibla ? mesurements.circleSizeExpanded : mesurements.circleSize
                                )
                            Image("qibla")
                                .resizable()
                                .frame(
                                    width: Int(viewModel.directionOfKabahTo360Format) == 0 ? mesurements.qiblaIconExpanded : mesurements.qiblaIconSize,
                                    height: Int(viewModel.directionOfKabahTo360Format) == 0 ? mesurements.qiblaIconExpanded : mesurements.qiblaIconSize
                                )
                                .opacity(viewModel.mode.isApproxQibla ? 1 : 0)
                        }
                        if viewModel.mode.isApproxQibla {
                            //TODO: change for watch
                            PulsatingCircle(mode: $viewModel.mode)
                        }
                    }
                    .offset(y: -smallerSide/2)
                    
                    //arrow
                    Image(systemName: "arrow.up")
                        .font(.system(size: smallerSide * 0.615, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: smallerSide, maxHeight: smallerSide)
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

#Preview {
    CompassView(viewModel: QiblaViewModel())
}

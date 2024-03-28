//
//  CopassView.swift
//  Qibla
//
//  Created by shahid on 27/03/24.
//

import SwiftUI

struct CompassView: View {
    
    @ObservedObject var viewModel: QiblaViewModel
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                ZStack {
                    //Top Circle
                    VStack {
                        Circle()
                            .fill(Color(viewModel.mode == .ahead ? UIColor.label : UIColor.secondaryLabel))
                            .frame(width: 16, height: 16)
                            .offset(y: viewModel.mode == .ahead ? -4 : -8)
                            .scaleEffect(viewModel.mode == .ahead ? 2 : 1)
                        
                        Spacer()
                    }
                    
                    //SemiCircle
                    ZStack {
                        Circle()
                            .trim(from: 0.025, to: (viewModel.directionOfKabahTo360Format/360) - 0.025)
                            .rotation(Angle(degrees: -90))
                            .stroke(Color(UIColor.label), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                            .opacity(viewModel.mode == .ahead ? 0 : 1)
                    }
                    
                    // Aroow with top circle
                    ZStack {
                        Circle()
                            .frame(width: 16, height: 16)
                            .offset(y: -geo.size.width/2)
                            .opacity(viewModel.mode == .ahead ? 0 : 1)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 192, weight: .bold))
                    }
                    .rotationEffect(viewModel.directionOfKabah)
                }
            }
            .frame(width: geo.size.width, height: geo.size.width)
            
        }
    }
}

//
//  ContentView.swift
//  Qibla
//
//  Created by shahid on 25/03/24.
//

import SwiftUI

struct QiblaView: View {
    
    @StateObject var viewModel = QiblaViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9){
            
            VStack(alignment: .leading) {
                Text("LOCATION")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(viewModel.currentLocation)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(20)
            
            Spacer()
            
            CompassView(viewModel: viewModel)
                .padding(.horizontal, 20)
            
            
            VStack(alignment: .leading){
                HStack {
                    Text("\(Int(viewModel.directionOfKabahTo360Format))")
                    Text("°")
                        .foregroundColor(.white.opacity(0.7))
                }
                
                HStack {
                    if viewModel.mode == .right {
                        Text("to your")
                            .foregroundColor(.white.opacity(0.7))
                        Text("right")
                    }
                    else if viewModel.mode == .left {
                        Text("to your")
                            .foregroundColor(.white.opacity(0.7))
                        Text("left")
                    }
                    else {
                        if Int(viewModel.directionOfKabahTo360Format) == 0 {
                            Text("facing")
                                .foregroundColor(.white.opacity(0.7))
                            Text("Qibla")
                        } else if viewModel.directionOfKabahTo360Format > 335 {
                            Text("slight to")
                                .foregroundColor(.white.opacity(0.7))
                            Text("left")
                            
                        } else {
                            Text("slight to")
                                .foregroundColor(.white.opacity(0.7))
                            Text("right")
                            
                        }
                    }
                }
                
                HStack {
                    Button(action: { }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(Color("transparentButton"))
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Button(action: { }) {
                        Image("rosary")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .tint(.white)
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(Color("transparentButton"))
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 26)
            }
            .font(.system(size: 48, design: .rounded))
            .padding(.horizontal, 20)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .background((viewModel.mode == .ahead ? Color("backgroundPrimary") : Color("backgroundSecondary")).edgesIgnoringSafeArea(.all))
        .onAppear(){
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

#Preview {
    QiblaView()
}

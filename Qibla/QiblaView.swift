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
                    Text(viewModel.mode.directionVerb)
                        .foregroundColor(.white.opacity(0.7))
                    Text(viewModel.mode.directionString)
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
        .background((viewModel.mode.isApproxQibla ? Color("backgroundPrimary") : Color("backgroundSecondary")).edgesIgnoringSafeArea(.all))
        .onAppear(){
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

#Preview {
    QiblaView()
}

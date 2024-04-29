//
//  ContentView.swift
//  QiblaWatch Watch App
//
//  Created by shahid on 24/04/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = QiblaViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            Text(viewModel.currentLocation)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.vertical, 10)
            
            //CompassWatchView()
            CompassView(viewModel: viewModel)
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
            }
        }
        .foregroundColor(.white)
        .padding(10)
        .edgesIgnoringSafeArea(.all)
        .background((viewModel.mode.isApproxQibla ? Color("backgroundPrimary") : Color("backgroundSecondary")).edgesIgnoringSafeArea(.all))
        .onAppear(){
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

#Preview {
    ContentView()
}


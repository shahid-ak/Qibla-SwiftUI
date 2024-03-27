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
        VStack {
            Image(systemName: "arrow.up")
                .rotationEffect(viewModel.directionOfKabah)
            Text("\(viewModel.directionOfKabahTo360Format)")
        }
        .padding()
        .onAppear(){
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

#Preview {
    QiblaView()
}


import SwiftUI

struct PontosRiscadosView: View {
    @StateObject private var viewModel = PontosRiscadosViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            // Forest Background
            LinearGradient(
                colors: [Color(hex: "081C15"), Color(hex: "1B4332"), Color(hex: "081C15")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Pontos Riscados")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Text("✦")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "D8F3DC").opacity(0.6))
                            Rectangle()
                                .fill(Color(hex: "D8F3DC").opacity(0.3))
                                .frame(width: 40, height: 1)
                            Text("✦")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "D8F3DC").opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .background(Color(hex: "081C15").opacity(0.8))
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.white)
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.pontos) { ponto in
                                NavigationLink(destination: PontoRiscadoDetailView(ponto: ponto)) {
                                    PontoRiscadoGridCell(ponto: ponto)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchPontos()
        }
    }
}

struct PontoRiscadoGridCell: View {
    let ponto: PontoRiscado
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Image Thumbnail Container
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "2D6A4F").opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "40916C").opacity(0.3), lineWidth: 1)
                    )
                
                if let image = UIImage(named: ponto.imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding(15)
                } else {
                    Image(systemName: "sparkles")
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "D8F3DC").opacity(0.2))
                }
            }
            .frame(height: 140)
            
            // Text Label
            Text(ponto.nome)
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundColor(Color(hex: "D8F3DC"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 40)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.05))
        )
        .scaleEffect(isAnimating ? 1.0 : 0.95)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    NavigationView {
        PontosRiscadosView()
    }
}

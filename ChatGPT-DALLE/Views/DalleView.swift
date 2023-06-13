//
//  DalleView.swift
//  ChatGPT-DALLE
//
//  Created by Caleb Hrenchir on 6/12/23.
//

import SwiftUI

struct DalleView: View {
    let examples = [
        "\"A purple elephant wearing a top hat.\"",
        "\"A futuristic cityscape at sunset with flying cars.\"",
        "\"A beach scene with palm trees, white sand, and turquoise water.\"",
        "\"A steaming cup of coffee with latte art.\"",
        "\"A mystical forest with glowing mushrooms and fairies.\"",
        "\"A vintage bicycle with a basket filled with colorful flowers.\"",
        "\"A spaceship exploring a distant galaxy.\"",
        "\"A majestic waterfall cascading down a rocky cliff.\"",
        "\"A plate of mouthwatering sushi rolls arranged beautifully.\"",
        "\"An enchanted castle surrounded by a magical moat and floating lanterns.\""
    ]
    
    @State private var randomExample = ""
    @State var typingMessage: String = ""
    @ObservedObject var dalleViewModel = DalleViewModel()
    @Namespace var bottomID
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        NavigationView() {
            VStack(alignment: .leading) {
                if !dalleViewModel.messages.isEmpty {
                    ScrollViewReader { reader in
                        ScrollView(.vertical) {
                            ForEach(dalleViewModel.messages.indices, id: \.self) { index in
                                let message = dalleViewModel.messages[index]
                                MessageView(message: message)
                            }
                            Text("").id(bottomID)
                        }
                        .onAppear {
                            withAnimation {
                                reader.scrollTo(bottomID)
                            }
                        }
                        .onChange(of: dalleViewModel.messages.count) { _ in
                            withAnimation{
                                reader.scrollTo(bottomID)
                            }
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "paintbrush")
                            .font(.largeTitle)
                        Text(randomExample)
                            .font(.subheadline)
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                HStack(alignment: .center) {
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .focused($fieldIsFocused)
                        .padding()
                        .foregroundColor(.black)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onTapGesture {
                            fieldIsFocused = true
                        }
                    Button(action: sendMessage) {
                        Image(systemName: typingMessage.isEmpty ? "circle" : "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(typingMessage.isEmpty ? .black.opacity(0.75) : .black)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                }
                .onDisappear {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                .background(Color(red: 200/255, green: 200/255, blue: 200/255, opacity: 1))
                .cornerRadius(12)
                .padding([.leading, .trailing, .bottom], 10)
                .shadow(color: .black, radius: 0.5)
            }
            .background(Color(red: 255/255, green: 255/255, blue: 255/255))
            .gesture(TapGesture().onEnded {
                hideKeyboard()
            })
            .navigationTitle("DALL·E 2")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            chooseRandomExample()
        }
    }
    
    private func chooseRandomExample() {
        randomExample = examples.randomElement() ?? ""
    }
    
    private func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        Task {
            if !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty {
                let tempMessage = typingMessage
                typingMessage = ""
                hideKeyboard()
                await dalleViewModel.generateImage(prompt: tempMessage)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DalleView_Previews: PreviewProvider {
    static var previews: some View {
        DalleView()
    }
}

//
//  CustomInputFields.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-03.
//

import SwiftUI

struct CustomInputFields: View {
    let imageName: String
    let placeholderText: String
    var isSecureField: Bool? = false
    @Binding var text: String
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                if isSecureField ?? false{
                    SecureField(placeholderText, text: $text)
                } else{
                    TextField(placeholderText, text: $text)
                }
            }
            Divider().background()
        }
    }
}

struct CustomInputFields_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputFields(imageName: "envelope", placeholderText: "Email", isSecureField: false, text: .constant(""))
    }
}

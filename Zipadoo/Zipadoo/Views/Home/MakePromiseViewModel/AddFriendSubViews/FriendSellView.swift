//
//  FriendSellView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

/// 더미 유저
let dummyUser: User = User(id: "1", name: "gs", nickName: "닉네임", phoneNumber: "01", profileImageString: "22", friendsIdArray: ["12", "2"], friendsIdRequestArray: ["3"])

struct FriendSellView: View {
    var friend: User
    @Binding var selectedFriends: [User]
    
    var body: some View {
        //        ForEach(selectedFriends.indices, id: \.self) { index in
        VStack {
            ZStack {
                ProfileImageView(imageString: friend.profileImageString, size: .small)
                //                    .frame(width: 75, height: 60)
                // MARK: - 삭제버튼(-)
                Button {
                    print("친구 삭제")
                    deleteFriend(friend)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
                .offset(x: 25, y: -24)
            }
            .shadow(radius: 1)
            .tint(.red)
            
            Text("\(friend.nickName)")
                .font(.callout)
        }
        .frame(width: 85, height: 85)
        //        }
    }
    func deleteFriend(_ item: User) {
        if let index = selectedFriends.firstIndex(of: item) {
            selectedFriends.remove(at: index)
        }
    }
}

#Preview {
    FriendSellView(friend: dummyUser, selectedFriends: .constant([dummyUser]))
}

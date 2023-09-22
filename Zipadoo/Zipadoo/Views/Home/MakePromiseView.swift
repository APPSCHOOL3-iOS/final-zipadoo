//
//  MakePromiseView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/21.
//

import SwiftUI

struct MakePromiseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var promiseTitle: String = ""
    @State private var date = Date()
    //    var friends = ["병구", "상규", "예슬"]
    @State private var friends = ["병구", "상규", "예슬", "한구", "아라", "해수", "여훈"]
    private let today = Calendar.current.startOfDay(for: Date())
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                AddPromiseUserCell(userName: "임병구")
                    .padding() // 사용자 Cell Hstack
                
                VStack {
                    AddPromiseTitleCell()
                        .padding(.top, -15) // 약속 타이틀 추가뷰
                    
                    AddDateCell()
                        .padding(.top) // 날짜 추가뷰
                    
                    AddPromisePlaceCell()
                        .padding(.top) // 장소 추가뷰
                    
                    AddPenaltyCell()
                        .padding(.top)
                    
                    AddFriendCellView(friends: friends)
                        .padding(.top) // 친구 추가뷰
                    
                }.padding(.top, 5) // 작성뷰
                
                Spacer()
            }
            .scrollIndicators(.hidden)
            .navigationTitle("약속 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("등록")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    MakePromiseView()
}

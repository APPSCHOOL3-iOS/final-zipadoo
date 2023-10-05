//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct LoginEmailCheckView: View {
    
    @ObservedObject private var emailLoginStore: EmailLoginStore = EmailLoginStore()
    
    @State private var uniqueEmail: Bool = false // 이메일 중복 체크
    
    @State private var isSigninLinkActive: Bool = false // uniqueEmail = false일 경우 회원가입뷰 버튼으로 활성화
    @State private var isLoginLinkActive: Bool = false // uniqueEmail = true일 경우 로그인뷰 버튼으로 활성화
    @State private var validMessage: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all) // 배경색
            VStack(alignment: .leading) { // 왼쪽 정렬
                
                Rectangle().frame(height: 50) // Spacer()기능
                
                HStack {
                    Text("이메일을 입력해 주세요.") // 상단 안내 문구
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }
                
                Text("로그인과 비밀번호 찾기에 사용됩니다.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 7)
      
                // 이메일 중복 체크 하여 각 경우에 따라 뷰 버튼 활성화
                HStack {
                    NavigationLink(destination: SigninByEmailView(emailLoginStore: emailLoginStore), isActive: $isSigninLinkActive) {
                        EmptyView() // 빈 뷰를 사용하여 링크 트리거를 활성화합니다.
                    }
                    .hidden() // 빈
                    
                    NavigationLink(destination: LoginByEmailPWView(emailLoginStore: emailLoginStore), isActive: $isLoginLinkActive) {
                        EmptyView() // 빈 뷰를 사용하여 링크 트리거를 활성화합니다.
                    }
                    .hidden() // 빈
                }
                             
                Group {
                    HStack {
                        // 이메일 입력 칸
                        TextField("이메일", text: $emailLoginStore.email, prompt: Text("이메일").foregroundColor(.gray))
                            .foregroundColor(Color.white)
                            .opacity(0.9)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .autocapitalization(.none)
                            .frame(height: 35)
                            .keyboardType(.emailAddress)
                        
                        // 내용 지우기 버튼
                        Button {
                            emailLoginStore.email = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                    }
                    .foregroundColor(Color.white.opacity(0.4))
                    
                    Rectangle().frame(height: 1)
                        .foregroundStyle(Color.white.opacity(0.5))
                        .padding(.bottom, 5)
                    
                    HStack {
                        // TextField가 비어있을때만이메일형식 유효 메세지
                        if emailLoginStore.email.isEmpty {
                            Text("\(validMessage)")
                                .font(.subheadline)
                                .foregroundStyle(Color.red.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                } // Group
                .background(Color.black)
                .navigationBarItems(trailing:
                                        Button("다음") {
                    if isCorrectEmail(email: emailLoginStore.email) {
                        // 여기에 데이터를 파이어베이스로 보내고 중복 체크를 수행하는 코드를 추가합니다.
                        emailLoginStore.emailCheck(email: emailLoginStore.email) { isUnique in
                            uniqueEmail = isUnique // 중복 체크 결과를 업데이트합니다.
                            if isUnique {
                                // 중복이 없으면 회원가입 뷰로 이동
                                self.uniqueEmail = true
                                self.isSigninLinkActive = true
                            } else {
                                // 이메일이 중복이 있을 때 비밀번호 입력창으로 이동
                                self.isLoginLinkActive = true
                                
                            }
                        }
                    } else {
                        validMessage = "이메일형식이 유효하지 않습니다"
                        emailLoginStore.email = ""
                    }
                    
                    }
                    .foregroundColor(.blue)
                    .font(.headline)
                    .padding(.trailing, 5)
                    .disabled(emailLoginStore.email.isEmpty)
                )
                    
            } // VStack
            .padding([.leading, .trailing])
        } // ZStack
    }
}
#Preview {
    NavigationStack {
        LoginEmailCheckView()
    }
}

//
//  AddPromiseView.swift
//  Zipadoo
//  약속 추가 뷰
//
//  Created by 나예슬 on 2023/09/25.
//

import SwiftUI
import CoreLocation

struct AddPromiseView: View {
    
    // 환경변수
    @Environment(\.dismiss) private var dismiss
    
    var promiseViewModel: PromiseViewModel = PromiseViewModel()
    //    var user: User
    
    // 저장될 변수
    @State private var id: String = ""
    @State private var promiseTitle: String = ""
    @State private var date = Date()
    @State private var destination: String = "" // 약속 장소 이름
    @State private var address = "" // 약속장소 주소
    @State private var coordX = 0.0 // 약속장소 위도
    @State private var coordY = 0.0 // 약속장소 경도
    
    // 지각비 변수 및 상수 값
    @State private var selectedValue: Int = 0
    let minValue: Int = 0
    let maxValue: Int = 5000
    let step: Int = 100
    
    private let today = Calendar.current.startOfDay(for: Date())
    @State private var addFriendSheet: Bool = false
    @State private var selectedFriends: [String] = []
    @State private var mapViewSheet: Bool = false
    @State var promiseLocation: PromiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780) // 장소에 대한 정보 값
    @State var isClickedPlace: Bool = false /// 검색 결과에 나온 장소 클릭값
    @State var addLocationButton: Bool = false /// 장소 추가 버튼 클릭값
    @State private var showingConfirmAlert: Bool = false
    @State private var showingCancelAlert: Bool = false
    @State private var showingPenalty: Bool = false
    
    var isAllWrite: Bool {
        return !promiseTitle.isEmpty &&
        Calendar.current.startOfDay(for: date) != today &&
        !promiseLocation.address.isEmpty
    }
    
    @State private var addPromise: Promise = Promise()
    
    @StateObject private var promise: PromiseViewModel = PromiseViewModel()
    @StateObject private var authUser: AuthStore = AuthStore()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                // MARK: - 약속 이름 작성 구현
                VStack(alignment: .leading) {
                    Text("약속 이름")
                        .font(.title2)
                        .bold()
                        .padding(.top, 15)
                    
                    HStack {
                        TextField("약속 이름을 입력해주세요.", text: $promiseTitle)
                        
                            .onChange(of: promiseTitle) {
                                if promiseTitle.count > 15 {
                                    promiseTitle = String(promiseTitle.prefix(15))
                                }
                            }
                        
                        Text("\(promiseTitle.count)")
                            .foregroundColor(.gray)
                            .padding(.trailing, -7)
                        Text("/15")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
                    
                    // MARK: - 약속 날짜/시간 선택 구현
                    Text("약속 날짜/시간")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    Text("약속시간 1시간 전부터 위치공유가 시작됩니다.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    DatePicker("날짜/시간", selection: $date, in: self.today..., displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(.top, 10)
                    
                    
                    
                    // MARK: - 약속 장소 구현
                    Text("약속 장소")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    
                    HStack {
                        /// Sheet 대신 NavigationLink로 이동하여 장소 설정하도록 설정
                        NavigationLink {
                            AddPlaceOptionCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, promiseLocation: $promiseLocation)
                        } label: {
                            Label("지역검색", systemImage: "mappin")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        if !promiseLocation.destination.isEmpty {
                            Button {
                                mapViewSheet = true
                            } label: {
                                HStack {
                                    Text("\(promiseLocation.destination)")
                                        .font(.callout)
                                    Image(systemName: "chevron.forward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 6)
                                        .padding(.leading, -5)
                                }
                            }
                            .sheet(isPresented: $mapViewSheet) {
                                VStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 50, height: 5)
                                        .foregroundStyle(Color.gray)
                                        .padding(.top, 10)
                                    
                                    PreviewPlaceOnMap(promiseLocation: $promiseLocation)
                                        .presentationDetents([.height(700)])
                                        .padding(.top, 15)
                                }
                            }
                        }
                        Spacer()
                    }
                    // MARK: - 지각비 구현
                    /*
                     지각비 구현 초기안
                     Text("지각비")
                     .font(.title2)
                     .bold()
                     .padding(.top, 40)
                     Text("100 단위로 입력 가능합니다.")
                     .foregroundColor(.gray)
                     
                     HStack {
                     TextField("지각 시 제출 할 감자수를 입력해주세요", text: $penaltyString, axis: .horizontal)
                     .frame(maxWidth: .infinity)
                     .textFieldStyle(.roundedBorder)
                     .keyboardType(.numberPad)
                     .multilineTextAlignment(.trailing)
                     Text("개")
                     }
                     */
                    
                    Text("지각비")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    Text("100 단위로 선택 가능합니다.")
                        .foregroundColor(.gray)
                    
                    HStack {
                        Button {
                            showingPenalty.toggle()
                        } label: {
                            Text("지각비를 선택해주세요.")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Text("\(selectedValue)개")
                            .font(.title3)
                            .padding(.leading, 100)
                    }
                    .padding(.top, 10)
                    
                    // MARK: - 약속 친구 추가 구현
                    AddFriendCellView()
                }
                .padding(.horizontal, 15)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("약속 추가")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // MARK: - 약속 등록 버튼 구현
                    Button {
                        promise.addPromiseData(promise: Promise(
                            id: UUID().uuidString, // 새로운 UUID 생성
                            makingUserID: authUser.currentUser?.id ?? "not ID",
                            promiseTitle: promiseTitle,
                            promiseDate: date.timeIntervalSince1970, // 시간을 타임스탬프로 변환
                            destination: promiseLocation.address,
                            participantIdArray: selectedFriends, // 선택한 친구들의 ID 배열
                            checkDoublePromise: false, // 기본값 설정
                            locationIdArray: [] // 기본값 설정
                        ))
                        showingConfirmAlert.toggle()
                    } label: {
                        Text("등록")
                            .foregroundColor(isAllWrite ? .blue : .gray)
                    }
                    .disabled(!isAllWrite)
                    .alert(isPresented: $showingConfirmAlert) {
                        Alert(
                            title: Text(""),
                            message: Text("등록이 완료되었습니다."),
                            dismissButton:
                                    .default(Text("확인"),
                                             action: {
                                                 dismiss()
                                                 promiseViewModel.addPromise(Promise(
                                                    makingUserID: "유저ID" /*user.id*/, // 사용자 ID를 적절히 설정해야 합니다.
                                                    promiseTitle: promiseTitle,
                                                    promiseDate: date.timeIntervalSince1970, // 날짜 및 시간을 TimeInterval로 변환
                                                    destination: promiseLocation.destination,
                                                    address: promiseLocation.address,
                                                    latitude: promiseLocation.latitude,
                                                    longitude: promiseLocation.longitude,
                                                    participantIdArray: selectedFriends,
                                                    checkDoublePromise: false, // 원하는 값으로 설정
                                                    locationIdArray: []))
                                             })
                        )
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showingCancelAlert.toggle()
                    } label: {
                        Text("취소")
                            .foregroundColor(.red)
                            .bold()
                    }
                    .alert(isPresented: $showingCancelAlert) {
                        Alert(
                            title: Text("약속 등록을 취소합니다."),
                            message: Text("작성 중인 내용은 저장되지 않습니다."),
                            primaryButton: .destructive(Text("등록 취소"), action: {
                                dismiss()
                            }),
                            secondaryButton: .default(Text("계속 작성"), action: {
                                
                            })
                        )
                    }
                }
                
            }
            .sheet(isPresented: $showingPenalty, content: {
                HStack {
                    Spacer()
                    Button {
                        showingPenalty.toggle()
                    } label: {
                        Text("결정")
                    }
                }
                .padding(.horizontal, 15)
                
                Picker(selection: $selectedValue, label: Text("지각비")) {
                    ForEach((minValue...maxValue).filter { $0 % step == 0 }, id: \.self, content: { value in
                        Text("\(value)").tag(value)
                    })
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .presentationDetents([.height(300)])
            })
            //            .sheet(isPresented: $addFriendSheet) {
            //                FriendsListVIew(isShowingSheet: $addFriendSheet, selectedFriends: $selectedFriends)
            //            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

//#Preview {
//    AddPromiseView(/*user: User(id: "", name: "", nickName: "", phoneNumber: "", profileImageString: "")*/)
//}

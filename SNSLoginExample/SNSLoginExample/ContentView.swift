//
//  ContentView.swift
//  SNSLoginExample
//
//  Created by twim on 2021/10/12.
//

// https://ksk9820.tistory.com/64

import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

// Model
struct Person {
    var name: String
}

struct FacebookResponse: Codable {
    let firstname: String?
    let id: String?
    let name: String?
}

// ViewModel
class PersonViewModel: UIViewController, ObservableObject {
    let today = Date()
    
    // ViewModel이 Model을 소유함
    // @Published : 변경을 감시할 변수
    @Published var soyoung = Person(name: "정보 없음")
    
    func loginKakao() {
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 설치되어 있으면 카카오톡을 통한 로그인 진행
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    self.getUserInfobyKakao()
                }
            }
        }
        //카카오톡이 설치되어있지 않다면 사파리를 통한 로그인 진행
        else {
            // prompts:[.Login] : 기존 로그인 여부와 상관없이 사용자에게 재인증 요청
            UserApi.shared.loginWithKakaoAccount(prompts:[.Login]) {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                        self.getUserInfobyKakao()
                    }
                }
        }
    }
    
    func getUserInfobyKakao() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                //do something
                _ = user
                self.soyoung.name = user!.kakaoAccount?.profile?.nickname ?? "실패"
            }
        }
    }
    
    func logoutKakao() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                self.soyoung.name = "정보 없음"
            }
        }
    }
    
    
    func loginGoogle() {
        let signInConfig = GIDConfiguration.init(clientID: "476449241976-s4bq3pvmntjtshl4dn9fojn4ebqhu17a.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { print(error!); return }
            guard let user = user else { return }

            //let emailAddress = user.profile?.email
            self.soyoung.name = user.profile?.name ?? "실패"
            //let givenName = user.profile?.givenName
            //let familyName = user.profile?.familyName

            //let profilePicUrl = user.profile?.imageURL(withDimension: 320)
        }
    }
    
    func loginFacebook() {
        var userData = FacebookResponse(firstname: "정보 없음", id: "정보 없음", name: "정보 없음")
        let loginManager = LoginManager()
            loginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("####### Facebook Login Success #######")

                    //print("Logged in! \(grantedPermissions) \(declinedPermissions) \(accessToken)")
                    GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name"]).start(completion: { (connection, result, error) -> Void in
                            do {
                                let data = try JSONSerialization.data(withJSONObject: result, options: [])
                                userData = try JSONDecoder().decode(FacebookResponse.self, from: data)
                                self.soyoung.name = userData.name ?? "실패"
                             }
                             catch {
                                 print("====== Error ======")
                               print(error)
                             }
                        
                    })
                }
            }
    }
}

struct ContentView: View {
    @StateObject var viewmodel = PersonViewModel()
    
    var body: some View {
        VStack {
            Button(action : {viewmodel.loginKakao()}){
                //Image("kakao_login_large_narrow").resizable().frame(width: 120, height: 50)
                Text("카카오 로그인")
            }
//            //ios가 버전이 올라감에 따라 sceneDelegate를 더이상 사용하지 않게되었다
//            //그래서 로그인을 한후 리턴값을 인식을 하여야하는데 해당 코드를 적어주지않으면 리턴값을 인식되지않는다
//            //swiftUI로 바뀌면서 가장큰 차이점이다.
//            .onOpenURL(perform: { url in
//                if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                    _ = AuthController.handleOpenUrl(url: url)
//                }
//            })
            Button(action : {viewmodel.logoutKakao()}){
                //Image("kakao_login_large_narrow").resizable().frame(width: 120, height: 50)
                Text("카카오 로그아웃")
            }
            Button(action : {viewmodel.loginGoogle()}){
                Text("구글 로그인")
            }
            Button(action : {viewmodel.loginFacebook()}){
                Text("페이스북 로그인")
            }
            Text(viewmodel.soyoung.name)
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



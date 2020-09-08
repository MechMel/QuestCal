//
//  QST_GoogleAuthController.swift
//  QuestCal
//
//  Created by Melchiah Mauck on 9/4/20.
//  Copyright © 2020 Melchiah Mauck. All rights reserved.
//

import Foundation
import AppAuth
import GTMAppAuth
import GoogleAPIClientForREST

class QST_GoogleAuthController {
    //static var authState: OIDAuthState?;
    static private let kClientID = "423183768627-698mbal732j20b16vng1bsed3v1iei68.apps.googleusercontent.com";
    static private let kRedirectURI = "com.googleusercontent.apps.423183768627-698mbal732j20b16vng1bsed3v1iei68://";
    static private let kIssuer = "https://accounts.google.com";
    static private var aCurrentAuthorizationFlow : OIDExternalUserAgentSession?;
    static var authorization: GTMAppAuthFetcherAuthorization?;

    
    static func setup(viewController: UIViewController) {
        authorization = GTMAppAuthFetcherAuthorization.init(fromKeychainForName: "googleAuth");
        if (authorization != nil && authorization!.canAuthorize()) {
            print("Google is verified!");
        } else {
            auth(viewController: viewController);
        }
    }

    static func auth(viewController: UIViewController)
    {
        //need this potatoe
        let issuer = URL(string: kIssuer)!
        let redirectURI = URL(string: kRedirectURI)!

        // discovers endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer, completion: {(_ configuration: OIDServiceConfiguration?, _ error: Error?) -> Void in
            if configuration == nil {
                return
            }
            let scopes = ["https://www.googleapis.com/auth/calendar"]
            let request = OIDAuthorizationRequest(configuration: configuration!, clientId: kClientID, scopes: scopes, redirectURL: redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)

            aCurrentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController, callback: {(_ authState: OIDAuthState?, _ error: Error?) -> Void in
                if authState != nil {
                    authorization = GTMAppAuthFetcherAuthorization(authState: authState!)
                    
                    if authorization != nil && (authorization?.canAuthorize())! {
                        GTMAppAuthFetcherAuthorization.save(authorization!, toKeychainForName: "googleAuth");
                    }
                    else {
                        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: "googleAuth");
                    }
                }
            })
        })
    }
}

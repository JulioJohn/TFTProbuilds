//
//  TftServiceTest.swift
//  TFT-ProTeamsTests
//
//  Created by Júlio John Tavares Ramos on 16/01/20.
//  Copyright © 2020 Júlio John Tavares Ramos. All rights reserved.
//

import XCTest
@testable import TFT_ProTeams

class TftServiceTest: XCTestCase {

    var tftService: TftServices = TftServices()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEmptyName() {
        //Inicializando mock
        tftService.tftDAO = TftDAOMock()
        
        let expectation = XCTestExpectation(description: "Expect an error, if string is empty")
        
        tftService.championLoadJson(filename: "") { (champion, error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }

    func testNilChampion() {
        //Inicializando mock
        tftService.tftDAO = TftDAOMockChampionNil()
        
        tftService.championLoadJson(filename: "MyName") { (champion, error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testIfErrorPassError() {
        //Inicializando mock
        tftService.tftDAO = TftDAOMockIfErrorPassError()
        
        tftService.championLoadJson(filename: "MyName") { (champion, error) in
            
            guard let error = error as? PlayerErrors else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(error, PlayerErrors.jsonCantBeLoaded, "O erro nao foi transmitido do DAO para o service")
        }
    }
    
    func testIfError() {
        //Inicializando mock
        tftService.tftDAO = TftDAOMock()
        
        tftService.getUserData(userName: "") { (userDetails, error) in
            XCTAssertNotNil(error)
        }
    }

}

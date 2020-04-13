//
//  DataTests.swift
//  RoutinesTests
//
//  Created by PEACH,RYAN (K-Atlanta,ex1) on 4/13/20.
//  Copyright © 2020 Peach. All rights reserved.
//

import XCTest
@testable import Routines

class DataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDaysOfWeekEncodingSimple() throws {
        XCTAssertEqual(daysOfWeekFromInt(daysOfWeekToInt([DayOfWeek.Monday])), DayOfWeek.Monday)
        XCTAssertEqual(daysOfWeekFromInt(daysOfWeekToInt([DayOfWeek.Tuesday])), DayOfWeek.Tuesday)
        XCTAssertEqual(daysOfWeekFromInt(daysOfWeekToInt([DayOfWeek.Wednesday])), DayOfWeek.Wednesday)
        XCTAssertEqual(daysOfWeekFromInt(daysOfWeekToInt([DayOfWeek.Thursday])), DayOfWeek.Thursday)
        XCTAssertEqual(daysOfWeekFromInt(daysOfWeekToInt([DayOfWeek.Friday])), DayOfWeek.Friday)
        XCTAssertEqual(daysOfWeekFromInt(daysOfWeekToInt([DayOfWeek.Saturday])), DayOfWeek.Saturday)
        XCTAssertEqual(daysOfWeekFromInt(daysOfWeekToInt([DayOfWeek.Sunday])), DayOfWeek.Sunday)
    }

}

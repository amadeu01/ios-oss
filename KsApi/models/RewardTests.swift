import XCTest
@testable import KsApi
import Prelude

final class RewardTests: XCTestCase {

  func testIsNoReward() {
    XCTAssertEqual(Reward.noReward.isNoReward, true)
    XCTAssertEqual(Reward.template.isNoReward, false)
  }

  func testEquatable() {
    XCTAssertEqual(Reward.template, Reward.template)
    XCTAssertNotEqual(Reward.template, Reward.template |> Reward.lens.id %~ { $0 + 1})
    XCTAssertNotEqual(Reward.template, Reward.noReward)
  }

  func testComparable() {
    let reward1 = Reward.template |> Reward.lens.id .~ 1 <> Reward.lens.minimum .~ 10
    let reward2 = Reward.template |> Reward.lens.id .~ 4 <> Reward.lens.minimum .~ 30
    let reward3 = Reward.template |> Reward.lens.id .~ 3 <> Reward.lens.minimum .~ 20
    let reward4 = Reward.template |> Reward.lens.id .~ 2 <> Reward.lens.minimum .~ 30

    let rewards = [reward1, reward2, reward3, reward4]
    let sorted = rewards.sorted()

    XCTAssertEqual(sorted, [reward1, reward3, reward4, reward2])
  }

  func testJsonParsing_WithMinimalData_AndDescription() {
    let reward: Reward? = Reward.decodeJSONDictionary([
      "id": 1,
      "minimum": 10,
      "description": "cool stuff"
      ])

    XCTAssertNotNil(reward)
    XCTAssertEqual(reward?.id, 1)
    XCTAssertEqual(reward?.description, "cool stuff")
    XCTAssertNotNil(reward?.shipping)
    XCTAssertEqual(false, reward?.shipping.enabled)

  }

  func testJsonParsing_WithMinimalData_AndReward() {
    let reward: Reward? = Reward.decodeJSONDictionary([
      "id": 1,
      "minimum": 10,
      "reward": "cool stuff"
      ])

    XCTAssertNotNil(reward)
    XCTAssertEqual(reward?.id, 1)
    XCTAssertEqual(reward?.minimum, 10)
    XCTAssertEqual(reward?.description, "cool stuff")
  }

  func testJsonParsing_WithFullData() {
    let reward: Reward? = Reward.decodeJSONDictionary([
      "id": 1,
      "description": "Some reward",
      "minimum": 10,
      "backers_count": 10
      ])

    XCTAssertNotNil(reward)
    XCTAssertEqual(reward?.id, 1)
    XCTAssertEqual(reward?.description, "Some reward")
    XCTAssertEqual(reward?.minimum, 10)
    XCTAssertEqual(reward?.backersCount, 10)
  }

  func testJsonDecoding_WithShipping() {

    let reward: Reward? = Reward.decodeJSONDictionary([
      "id": 1,
      "description": "Some reward",
      "minimum": 10,
      "backers_count": 10,
      "shipping_enabled": true,
      "shipping_preference": "unrestricted",
      "shipping_summary": "Ships anywhere in the world."
      ])

    XCTAssertNotNil(reward)
    XCTAssertEqual(reward?.id, 1)
    XCTAssertEqual(reward?.description, "Some reward")
    XCTAssertEqual(reward?.minimum, 10)
    XCTAssertEqual(reward?.backersCount, 10)
    XCTAssertEqual(true, reward?.shipping.enabled)
    XCTAssertEqual(.unrestricted, reward?.shipping.preference)
    XCTAssertEqual("Ships anywhere in the world.", reward?.shipping.summary)
  }
}

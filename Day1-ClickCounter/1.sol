// SPDX-License-Identifier:MIT

pragma Solidity ^0.8.0;

contract ClickCounter {

  uint256 public counter;

  function click() public {
    counter++;
  }
}

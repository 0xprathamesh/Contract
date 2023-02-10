// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Course {
    struct CourseData {
        uint price;
        bytes32 nameHash;
        address payable owner;
    }

    mapping (address => CourseData) public courses;

    event CourseAdded(address payable owner, bytes32 nameHash, uint price);
    event CoursePurchased(address payable  owner, bytes32 nameHash, uint price, address buyer);

    function addCourse(string memory courseName, uint price) public {
        courses[msg.sender] = CourseData(price, keccak256(abi.encodePacked(courseName)), payable(msg.sender));
        emit CourseAdded(payable(msg.sender), keccak256(abi.encodePacked(courseName)), price);
    }

    function purchaseCourse(address owner, string memory courseName) public payable {
        CourseData storage courseData = courses[owner];
        require(courseData.nameHash == keccak256(abi.encodePacked(courseName)), "Course not found");
        require(courseData.price <= msg.value, "Insufficient funds");
        require(courseData.owner != msg.sender, "You cannot purchase your own course");

         courseData.owner.transfer(msg.value);
        emit CoursePurchased(payable(owner), courseData.nameHash, courseData.price, msg.sender);
    }
}

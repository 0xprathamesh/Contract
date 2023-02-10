// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Course {
    enum Role { Teacher, Student }

    mapping (address => Role) public roles;

    struct CourseData {
        uint price;
        bytes32 nameHash;
        address payable owner;
    }

    mapping (address => CourseData) public courses;

    event CourseAdded(address payable owner, bytes32 nameHash, uint price);
    event CoursePurchased(address payable  owner, bytes32 nameHash, uint price, address buyer);

    function addAsTeacher() public {
        require(roles[msg.sender] == Role.Teacher || roles[msg.sender] == Role.Student, "Already assigned a role");
        roles[msg.sender] = Role.Teacher;
    }

    function addAsStudent() public {
        require(roles[msg.sender] == Role.Teacher || roles[msg.sender] == Role.Student, "Already assigned a role");
        roles[msg.sender] = Role.Student;
    }

    function addCourse(string memory courseName, uint price) public {
        require(roles[msg.sender] == Role.Teacher, "Only teachers can add courses");
        courses[msg.sender] = CourseData(price, keccak256(abi.encodePacked(courseName)), payable(msg.sender));
        emit CourseAdded(payable(msg.sender), keccak256(abi.encodePacked(courseName)), price);
    }

    function purchaseCourse(address owner, string memory courseName) public payable {
        require(roles[msg.sender] == Role.Student, "Only students can purchase courses");
        CourseData storage courseData = courses[owner];
        require(courseData.nameHash == keccak256(abi.encodePacked(courseName)), "Course not found");
        require(courseData.price <= msg.value, "Insufficient funds");
        require(courseData.owner != msg.sender, "You cannot purchase your own course");

        courseData.owner.transfer(msg.value);
        emit CoursePurchased(payable(owner), courseData.nameHash, courseData.price, msg.sender);
    }
}

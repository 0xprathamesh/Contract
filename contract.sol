// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract CodeCamp {
   
    enum Role { Teacher, Student }

    mapping (address => Role) public roles;

      string public name = "Codecamp";
      uint256 public videoCount = 0;

  
     struct Course{
        uint256 id;
        string hash;
        string title;
        string description;
        string location;
        string category;
        string thumbnailHash;
        string date;
        string teacherName;
        uint256 courseCost;
        address payable author;
         }      
   
     mapping(uint256 => Course) public courses;
     
      
       event UploadCourse (
        uint256 id,
        string hash,
        string title,
        string description,
        string location,
        string category,
        string thumbnailHash, 
        string date,
        string teacherName,
        uint256 courseCost,
        address payable author
        );

        event PurchaseCourse(
           uint256 id,
           string hash,
           string title,
           string description,
           string location,
           string category,
           string thumbnailHash,
           string date,
           string teacherName,
           uint256 courseCost,
           address payable author
          );

   

    //Roles
    function addAsTeacher() public {
        require(roles[msg.sender] == Role.Teacher || roles[msg.sender] == Role.Student, "Already assigned a role");
        roles[msg.sender] = Role.Teacher;
    }

    function addAsStudent() public {
        require(roles[msg.sender] == Role.Teacher || roles[msg.sender] == Role.Student, "Already assigned a role");
        roles[msg.sender] = Role.Student;
    }
    function addCourse(
        string memory _videoHash,
        string memory _title,
        string memory _description,
        string memory _location,
        string memory _category,
        string memory _thumbnailHash,
        string memory _date,
        string memory _teacherName,
        uint256 _courseCost
    ) public {
        require(roles[msg.sender] == Role.Teacher, "Only teachers can add courses");
        
        require(bytes(_videoHash).length > 0);
        require(bytes(_title).length > 0);
        require(msg.sender != address(0));
        videoCount++;
        courses[videoCount] = Course(
            videoCount,
            _videoHash,
            _title,
            _description,
            _location,
            _category,
            _thumbnailHash,
            _date,
            _teacherName,
            _courseCost,
            payable(msg.sender)
        );
        emit UploadCourse(
            videoCount,
            _videoHash,
            _title,
            _description,
            _location,
            _category,
            _thumbnailHash,
            _date,
            _teacherName,
            _courseCost,
            payable(msg.sender)
        );
    }
    
    function getCourseDetails(uint256 _courseId) public view returns (string memory, string memory, string memory, string memory, string memory, string memory, string memory, string memory, uint256) {
    Course storage courseData = courses[_courseId];
    require(courseData.id == _courseId, "Course not found");
    return (
        courseData.hash,
        courseData.title,
        courseData.description,
        courseData.location,
        courseData.category,
        courseData.thumbnailHash,
        courseData.date,
        courseData.teacherName,
        courseData.courseCost
    );
}

    
    function purchaseCourse(uint256 _courseId) public payable {
     require(roles[msg.sender] == Role.Student, "Only students can purchase courses");
        Course storage courseData = courses[_courseId];
        require(courseData.id == _courseId, "Course not found");
        require(courseData.courseCost <= msg.value, "Insufficient funds");
        require(courseData.author != msg.sender, "You cannot purchase your own course");

        courseData.author.transfer(msg.value);
        emit PurchaseCourse(
             courseData.id,
             courseData.hash,
             courseData.title,
             courseData.description,
             courseData.location,
             courseData.category,
             courseData.thumbnailHash,
             courseData.date,
             courseData.teacherName,
             courseData.courseCost,
             courseData.author
        );
    }
    struct User {
        string name;
        string handle;
        string bio;
        address walletAddress;
    }

    mapping (address => User) public users;

    function addProfile(string memory _name, string memory _handle, string memory _bio, address _walletAddress) public {
        users[msg.sender] = User(_name, _handle, _bio, _walletAddress);
    }
}

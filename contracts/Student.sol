pragma solidity ^0.4.23;

import "./Course.sol";

contract Student is Course {
    struct student {
        address Address;
        string name;
        uint256[] AllCourses;
        mapping(uint256 => uint8) MilestoneProgress;
        mapping(uint256 => bool) MilestonesDone;
        mapping(uint256 => uint8) CoursesProgress;
        mapping(uint256 => bool) CoursesDone;
        mapping(uint256 => bool) VideosDone;
        mapping(uint256 => bool) CodesDone;
        mapping(uint256 => uint8) CodeResult;
        mapping(uint256 => bool) QuizesDone;
        mapping(uint256 => uint8) QuizResult;

        uint256 Rewards;
    }

    student[] AllStudents;
    mapping(address => uint256) StudentIndex;

    mapping(address => uint256) balances;

    function RegisterNewStudent(address _student, string _name) public onlyOwner {
        uint256 studentIndex = AllStudents.length;
        student storage newStudent = AllStudents[studentIndex];
        newStudent.Address = _student;
        newStudent.name = _name;
    }

    function EnrollNewCourse(address _student, uint256 _courseCode) public onlyOwner {
        uint256 courseIndex = getCourseIndex(_courseCode);
        uint256 studentIndex = StudentIndex[_student];
        student storage _Student = AllStudents[studentIndex];
        _Student.AllCourses.push(courseIndex);
    }

    function videoCompleted(address _student, uint256 _courseCode, uint256 _milestoneCode, uint256 _videoCode) public onlyOwner {
        uint256 studentIndex = StudentIndex[_student];
        uint256 courseIndex = getCourseIndex(_courseCode);
        uint256 milestoneIndex = getMilestoneIndex(_milestoneCode);
        uint256 videoIndex = getVideoIndex(_videoCode);
        uint8 progress = getProgressByVideo(milestoneIndex, videoIndex);
        student storage _Student = AllStudents[studentIndex];
        require(!_Student.VideosDone[videoIndex]);
        _Student.VideosDone[videoIndex] = true;
        _Student.MilestoneProgress[milestoneIndex] += progress;
        if (_Student.MilestoneProgress[milestoneIndex] == 100) {
            _Student.MilestonesDone[milestoneIndex] = true;
            _Student.Rewards.add(getMilestoneReward(courseIndex, milestoneIndex));
            balances[_student].add(getMilestoneReward(courseIndex, milestoneIndex));
        }
    }

    function codeProjectCompleted(
        address _student, 
        uint256 _courseCode, 
        uint256 _milestoneCode, 
        uint256 _codeProjectCode, 
        uint8 _result) 
        public onlyOwner 
    {
        uint256 studentIndex = StudentIndex[_student];
        uint256 courseIndex = getCourseIndex(_courseCode);
        uint256 milestoneIndex = getMilestoneIndex(_milestoneCode);
        uint256 codeIndex = getVideoIndex(_codeProjectCode);
        uint8 progress = getProgressByVideo(milestoneIndex, codeIndex);
        student storage _Student = AllStudents[studentIndex];
        require(!_Student.CodesDone[codeIndex]);
        _Student.CodesDone[codeIndex] = true;
        _Student.MilestoneProgress[milestoneIndex] += progress;
        if (_Student.MilestoneProgress[milestoneIndex] == 100) {
            _Student.MilestonesDone[milestoneIndex] = true;
            _Student.Rewards.add(getMilestoneReward(courseIndex, milestoneIndex).mul(_result).div(100));
        }
        balances[_student].add(getMilestoneReward(courseIndex, milestoneIndex));
    }

    function quizCompleted(
        address _student, 
        uint256 _courseCode, 
        uint256 _milestoneCode, 
        uint256 _quizCode,
        uint8 _result) 
        public onlyOwner 
    {
        uint256 studentIndex = StudentIndex[_student];
        uint256 courseIndex = getCourseIndex(_courseCode);
        uint256 milestoneIndex = getMilestoneIndex(_milestoneCode);
        uint256 quizIndex = getVideoIndex(_quizCode);
        uint8 progress = getProgressByVideo(milestoneIndex, quizIndex);
        student storage _Student = AllStudents[studentIndex];
        require(!_Student.QuizesDone[quizIndex]);
        _Student.QuizesDone[quizIndex] = true;
        _Student.MilestoneProgress[milestoneIndex] += progress;
        if (_Student.MilestoneProgress[milestoneIndex] == 100) {
            _Student.MilestonesDone[milestoneIndex] = true;
            _Student.Rewards.add(getMilestoneReward(courseIndex, milestoneIndex).mul(_result).div(100));
        }
        balances[_student].add(getMilestoneReward(courseIndex, milestoneIndex));
    }

    function getStudentRewards(address _student) public view returns (uint256) {
        uint256 index = StudentIndex[_student];
        student memory student_ = AllStudents[index];
        return student_.Rewards;
    }
}
pragma solidity ^0.4.23;

import "./Migrations.sol";
import "./SafeMath.sol";

contract Materials is Migrations {
    using SafeMath for uint256;

    struct Video {
        uint256 uniqueCode;
        string name;
    }

    struct CodeProject {
        uint256 uniqueCode;
        string name;
    }

    struct Quiz {
        uint256 uniqueCode;
        string name;
    }

    Video[] AllVideos;
    CodeProject[] AllCodeProjects;
    Quiz[] AllQuizes;

    mapping(uint256 => uint256) videoIndex;
    mapping(uint256 => uint256) codeProjectIndex;
    mapping(uint256 => uint256) quizIndex;

    function addVideo(uint256 _uniqueCode, string _name) public onlyOwner {
        Video storage newVideo = AllVideos[AllVideos.length];
        newVideo.uniqueCode = _uniqueCode;
        newVideo.name = _name;
        videoIndex[_uniqueCode] = AllVideos.length.sub(1);
    }

    function addCodeProject(uint256 _uniqueCode, string _name) public onlyOwner {
        CodeProject storage newCodeProject = AllCodeProjects[AllCodeProjects.length];
        newCodeProject.uniqueCode = _uniqueCode;
        newCodeProject.name = _name;
        codeProjectIndex[_uniqueCode] = AllCodeProjects.length.sub(1);
    }

    function addQuiz(uint256 _uniqueCode, string _name) public onlyOwner {
        Quiz storage newQuiz = AllQuizes[AllQuizes.length];
        newQuiz.uniqueCode = _uniqueCode;
        newQuiz.name = _name;
        quizIndex[_uniqueCode] = AllQuizes.length.sub(1);
    }

    function getVideoIndex(uint256 _uniqueCode) internal view returns (uint256) {
        return videoIndex[_uniqueCode];
    }

    function getCodeProjectIndex(uint256 _uniqueCode) internal view returns (uint256) {
        return codeProjectIndex[_uniqueCode];
    }

    function getQuizIndex(uint256 _uniqueCode) internal view returns (uint256) {
        return quizIndex[_uniqueCode];
    }

}

contract Milestone is Materials {
    struct mileStone {
        uint256 uniqueCode;
        string name;

        uint256[] videoIndex;
        uint256[] codeProjectIndex;
        uint256[] quizIndex;

        mapping(uint256 => uint8) videoShare;
        mapping(uint256 => uint8) codeProjectShare;
        mapping(uint256 => uint8) quizShare;
    }

    mileStone[] ALlMilestones;
    mapping(uint256 => uint256) MilestoneIndex;

    function createMilestone(uint256 _uniqueCode, string _name) public onlyOwner {
        mileStone storage newMilestone = ALlMilestones[ALlMilestones.length];
        newMilestone.uniqueCode = _uniqueCode;
        newMilestone.name = _name;
    }

    function addVideoToMilestone(uint256 _MilestoneUniqueCode, uint256 _VideoUniqueCode, uint8 _share) public onlyOwner {
        uint256 milestoneIndex = MilestoneIndex[_MilestoneUniqueCode];
        mileStone storage milestone = ALlMilestones[milestoneIndex];
        milestone.videoIndex.push(getVideoIndex(_VideoUniqueCode));
        milestone.videoShare[_VideoUniqueCode] = _share;
    }

    function addCodeProjectToMilestone(uint256 _MilestoneUniqueCode, uint256 _CodeProjectUniqueCode, uint8 _share) public onlyOwner {
        uint256 milestoneIndex = MilestoneIndex[_MilestoneUniqueCode];
        mileStone storage milestone = ALlMilestones[milestoneIndex];
        milestone.codeProjectIndex.push(getCodeProjectIndex(_CodeProjectUniqueCode));
        milestone.codeProjectShare[_CodeProjectUniqueCode] = _share;
    }

    function addQuizToMilestone(uint256 _MilestoneUniqueCode, uint256 _QuizUniqueCode, uint8 _share) public onlyOwner {
        uint256 milestoneIndex = MilestoneIndex[_MilestoneUniqueCode];
        mileStone storage milestone = ALlMilestones[milestoneIndex];
        milestone.quizIndex.push(getQuizIndex(_QuizUniqueCode));
        milestone.quizShare[_QuizUniqueCode] = _share;
    }

    function getMilestoneIndex(uint256 _uniqueCode) internal view returns (uint256) {
        return MilestoneIndex[_uniqueCode];
    }
}

contract Course is Milestone {
    struct course {
        uint256 uniqueCode;
        string name;

        uint256[] MilestoneIndex;
        mapping(uint256 => uint256) MilestoneShare;

        uint256 Reward;
    }

    course[] AllCourses;
    mapping(uint256 => uint256) CourseIndex;

    function createCourse(uint256 _uniqueCode, string _name, uint256 _reward) public onlyOwner {
        course storage newCourse = AllCourses[_uniqueCode];
        newCourse.uniqueCode = _uniqueCode;
        newCourse.name = _name;
        newCourse.Reward = _reward;
    }

    function addMilestoneToCourse(uint256 _courseCode, uint256 _milestoneCode, uint8 _share) public onlyOwner {
        uint256 courseIndex = CourseIndex[_courseCode];
        course storage _course = AllCourses[courseIndex];
        _course.MilestoneIndex.push(getMilestoneIndex(_milestoneCode));
        _course.MilestoneShare[getMilestoneIndex(_milestoneCode)] = _share;
    }

    function getCourseIndex(uint256 _courseCode) internal view returns (uint256) {
        return CourseIndex[_courseCode];
    }
}
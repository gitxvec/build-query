/* 
Peter Miles 
103599491 
*/

/*
SUBJECT(SUBJCODE, DESCRIPTION)
PRIMARY KEY (SUBJCODE)

TEACHER(STAFFID, SURNAME GIVENNAME)
PRIMARY KEY (STAFFID)

STUDENT(STUDENTID, SURNAME, GIVENNAME, GENDER)
PRIMARY KEY (STUDENTID)

SUBJECTOFFERING(SUBJCODE, YEAR, SEMESTER, FEE, STAFFID)
PRIMARY KEY (SUBJCODE, YEAR, SEMESTER)
FOREIGN KEY (SUBJCODE) REFERENCES SUBJECT
FOREIGN KEY (STAFFID) REFERENCES TEACHER

ENROLMENT (STUDENTID, SUBJCODE, YEAR, SEMESTER, DATEENROLLED, GRADE)
PRIMARY KEY (STUDENTID, SUBJCODE, YEAR, SEMESTER)
FOREIGN KEY (STUDENTID) REFERENCES STUDENT
FOREIGN KEY (SUBJCODE, YEAR, SEMESTER) REFERENCES SUBJECTOFFERING
*/

USE BQ;
GO
DROP TABLE IF EXISTS ENROLMENT, SUBJECTOFFERING, STUDENT, TEACHER, [SUBJECT];

SELECT NAME FROM SYS.OBJECTS WHERE TYPE = 'U';

CREATE TABLE [SUBJECT] (
    SUBJCODE NVARCHAR(100), 
    DESCRIPTION NVARCHAR(500),
    PRIMARY KEY (SUBJCODE)
)

CREATE TABLE [TEACHER] (
    STAFFID INT, 
    SURNAME NVARCHAR(100) NOT NULL,
    GIVENNAME NVARCHAR(100) NOT NULL,
    PRIMARY KEY (STAFFID),
    CONSTRAINT CHK_TEACHER_STAFFID CHECK (LEN(STAFFID) = 8)
)

CREATE TABLE [STUDENT] (
    STUDENTID NVARCHAR(10), 
    SURNAME NVARCHAR(100) NOT NULL, 
    GIVENNAME NVARCHAR(100) NOT NULL, 
    GENDER NVARCHAR(1),
    PRIMARY KEY (STUDENTID),
    CONSTRAINT CHK_STUDENT_GENDER CHECK(GENDER IN ('M', 'F', 'I'))
)

CREATE TABLE [SUBJECTOFFERING] (
    SUBJCODE NVARCHAR(100), 
    [YEAR] INT, 
    SEMESTER INT, 
    FEE MONEY NOT NULL, 
    STAFFID INT,
    PRIMARY KEY (SUBJCODE, YEAR, SEMESTER),
    FOREIGN KEY (SUBJCODE) REFERENCES [SUBJECT],
    FOREIGN KEY (STAFFID) REFERENCES TEACHER,
    CONSTRAINT CHK_SUBJECTOFFERING_YEAR CHECK(LEN([YEAR]) = 4),
    CONSTRAINT CHK_SUBJECTOFFERING_SEMESTER CHECK(SEMESTER IN (1, 2)),
    CONSTRAINT CHK_SUBJECTOFFERING_MONEY CHECK(FEE > 0),
)

CREATE TABLE [ENROLMENT] (
    STUDENTID NVARCHAR(10), 
    SUBJCODE NVARCHAR(100), 
    YEAR INT, 
    SEMESTER INT, 
    DATEENROLLED DATE, 
    GRADE NVARCHAR(2) DEFAULT NULL,
    PRIMARY KEY (STUDENTID, SUBJCODE, YEAR, SEMESTER),
    FOREIGN KEY (STUDENTID) REFERENCES STUDENT,
    FOREIGN KEY (SUBJCODE, YEAR, SEMESTER) REFERENCES SUBJECTOFFERING,
    CONSTRAINT CHK_ENROLMENT_YEAR CHECK(LEN([YEAR]) = 4),
    CONSTRAINT CHK_ENROLMENT_SEMESTER CHECK(SEMESTER IN (1, 2)),
    CONSTRAINT CHK_ENROLMENT_GRADE CHECK(GRADE in ('N', 'P', 'C', 'D', 'HD')),
)
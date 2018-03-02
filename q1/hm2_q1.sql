
--	1b
	SELECT fName,lName,birthDate,city
	FROM STUDENT
	
--	1c 
	select s.fName,s.lName,d.dName, (st.fName +' '+ st.lName)advisor
	from STUDENT s, DEPARTMENT d, STAFF st, ADVISOR a
	where s.deptCode = d.deptCode and st.staffID=a.staffID and d.deptCode=st.deptCode and a.staffID=s.advisorID
	order by d.deptCode asc, s.lName asc

	
--	1d
	select s.fName, s.lName
	from [cse355-sis].dbo.STUDENT s,[cse355-sis].dbo.DEPARTMENT d
	where d.dName ='Computer Engineering'
	
--	1e
	select 
	from [cse355-sis].dbo.STUDENT
	where fname like'%at%'
	
--	1f	
	select s.staffID, s.fName, s.lName, s.birthDate
	from dbo.STAFF s, MANAGER m
	where noOfChildren>=2 and (year(getdate())-year(birthdate))>40 and isMarried='True' and m.staffID=s.staffID
	ORDER BY year(s.birthDate), month(s.birthDate), day(s.birthDate)
	
	
--	1g
	select s.studentID, s.fName, s.lName, d.dName, dip.dateOfGraduation
	from STUDENT s, DEPARTMENT d, DIPLOMA dip
	where s.studentID=dip.studentID and s.deptCode=d.deptCode and dip.dateOfGraduation > 2010-21-05



--	2b
	update player set age=year(getdate())-year(birthDate)
		
	--update player set age=(year(getdate())+month(getdate()+ day(getdate()))-(year(birthDate)+month(birthDate)+day(birthDate)))
--	2c
	select p.playerID, (p.firstName + ' ' + p.lastName)FullName, p.age
	from player p, team t, player_team pt
	where p.age < (select AVG(age) AS average FROM player) and
	      p.playerID=pt.playerID and t.teamID=pt.teamID and
		  p.firstName not like '%nec%'
	
--	2d
	update team set city = 
		concat(city 
		,
		' #p'
		,
		(select count(*)numberOfPlayers
		from player_team
		where team.teamID=player_team.teamID
		group by teamID)
		,
		' g'
		,
		(select count(*)forwardGoals
		from goals g,player_team pt
		where g.isOwnGoal=0  and pt.playerID=g.playerID and team.teamID=pt.teamID
		group by pt.teamID))*/
-- 2e
	select p.playerID,p.firstName,p.lastName,abc.goalcount,def.NumberOfMatchesPlayerDidntGoal,AVG(GoalCountMatchID.goalcount) average_number_of_goals_per_scored_matches
	from player p,
					(select playerID, count(*) goalcount
					from goals 
					group by playerID) abc--number of goals of a player
					,
					(select playerID, 34-count(*) NumberOfMatchesPlayerDidntGoal
					from goals 
					group by playerID)def--number of matches that player didnt goal
					,
					(select count(*) goalcount,matchID,playerID
					from goals 
					group by matchID,playerID) GoalCountMatchID--average_number_of_goals_per_scored_matches
	where p.playerID=abc.playerID and def.playerID=abc.playerID 
	group by p.playerID,p.firstName,p.lastName,abc.goalcount,def.NumberOfMatchesPlayerDidntGoal
	order by abc.goalcount desc



	select top(10) p.playerID,p.firstName,p.lastName,abc.goalcount,def.NumberOfMatchesPlayerDidntGoal,avgdeal.resultavg
	from player p,
					(select playerID, count(*) goalcount
					from goals 
					group by playerID) abc--number of goals of a player
					,
					(select playerID, 34-count(*) NumberOfMatchesPlayerDidntGoal
					from goals 
					group by playerID)def--number of matches that player didnt goal
					,
					(select (NumberOfAllGoalsofPlayerTable.NumberOfAllGoalsofPlayer/NumberOfMatchesPlayerGoaledTable.NumberOfMatchesPlayerGoaled) resultavg,NumberOfMatchesPlayerGoaledTable.playerID
					from	
							(select playerID, count(*) NumberOfAllGoalsofPlayer
							from goals 
							group by playerID) NumberOfAllGoalsofPlayerTable
							,
							(select abc.playerID,count(*) NumberOfMatchesPlayerGoaled
							from 		
										(select playerID, count(*) goalcount,matchID
										from goals 
										group by playerID,matchID)abc
							group by abc.playerID) NumberOfMatchesPlayerGoaledTable
					where NumberOfAllGoalsofPlayerTable.playerID=NumberOfMatchesPlayerGoaledTable.playerID)avgdeal--wanted average
	where p.playerID=abc.playerID and def.playerID=p.playerID and avgdeal.playerID=p.playerID
	group by p.playerID,p.firstName,p.lastName,abc.goalcount,def.NumberOfMatchesPlayerDidntGoal,avgdeal.resultavg
	order by abc.goalcount desc

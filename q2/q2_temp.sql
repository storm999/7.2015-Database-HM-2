/*
update team set city = CONCAT( team.city , "" )
						*/
						
				 /* bir takýmdaki toplam oyuncu sayýsý*/
				select count(*)numberOfPlayers
				from player_team
				group by teamID


				/*bir takýmýn karþýya attýðý toplam göl sayýsý*/
				select count(g.matchID)forwardGoals,pt.teamID
				from goals g,player_team pt,match m
				where (g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID )
						or
						(g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
				group by pt.teamID
				order by forwardGoals

				/*Br takýmýn oynadýðý tüm maçlardaki ki goller*/
				select count(*)AllGoals,pt.teamID
				from goals g,player_team pt
				where pt.playerID=g.playerID
				group by pt.teamID


				/*bir takýmýn karþýya attýðý toplam göl sayýsý+karþý takýmlarýn kendilerine attýðý goller*/
				select(fgoal.forwardGoals+ ISNULL(stupidGoal.gcount,0) ) GF	
				from
					(select count(g.matchID)forwardGoals,pt.teamID
					from goals g,player_team pt,match m

					where (g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID )
							or
							(g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
					group by pt.teamID) fgoal 
				full outer join
					(select count(g.matchID) gcount,teamID
					from goals g,player_team pt,match m
					where (g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID)
					or
					(g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
					group by pt.teamID 
					)stupidGoal 
				on stupidGoal.teamID=fgoal.teamID
-----------------GA MERGE
													select	(alls.AllGoals-fw.GF) GA
													from		(select count(*)AllGoals,pt.teamID
																from goals g,player_team pt
																where pt.playerID=g.playerID
																group by pt.teamID) alls
																,
																(select(fgoal.forwardGoals+ ISNULL(stupidGoal.gcount,0) ) GF, fgoal.teamID
																from
																	(select count(g.matchID)forwardGoals,pt.teamID
																	from goals g,player_team pt,match m

																	where (g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID )
																			or
																			(g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
																	group by pt.teamID) fgoal 
																full outer join
																	(select count(g.matchID) gcount,teamID
																	from goals g,player_team pt,match m
																	where (g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID)
																	or
																	(g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
																	group by pt.teamID 
																	)stupidGoal 
																on stupidGoal.teamID=fgoal.teamID) fw
														where fw.teamID=alls.teamID

				/*takým yediði toplam gol sayýsý*/
				select(fgoal.forwardGoals+ ISNULL(stupidGoal.gcount,0) ) GF	
				from
					(select count(g.matchID)forwardGoals,pt.teamID
					from goals g,player_team pt,match m

					where (g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID )
							or
							(g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
					group by pt.teamID) fgoal 
				full outer join
					(select count(g.matchID) gcount,teamID
					from goals g,player_team pt,match m
					where (g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID)
					or
					(g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
					group by pt.teamID 
					)stupidGoal 
				on stupidGoal.teamID=fgoal.teamID





					/* oyuncunun toplam gol sayýsý:*/
					select playerID, count(*) goalcount
									from goals 
									group by playerID
									order by goalcount
				

			/* number of matches that one player goaled*/
			select abc.playerID,count(*) NumberOfMatchesPlayerGoaled
			from 		
							(select playerID, count(*) goalcount,matchID
							from goals 
							group by playerID,matchID
							)abc
			group by abc.playerID
			order by NumberOfMatchesPlayerGoaled



			/* bir maçta atýlan toplam gol sayýsý */
			select count(*) goalcount,matchID
							from goals 
							group by matchID
							order by goalcount

/*Average of goals*/
select avg (allGoals.goalcount)
from			(select count(*) goalcount,matchID
				from goals 
				group by matchID)allGoals


			/*En çok gol atan 10 oyuncu */
			select top(10) p.playerID,p.firstName,p.lastName,goalcount
			from					(select playerID, count(*) goalcount
									from goals 
									group by playerID
									) abc
				,player p
			where p.playerID=abc.playerID
			order by abc.goalcount desc

----------------------------------------------------------------------
--Merging Q2
	select p.playerID,p.firstName,p.lastName,abc.goalcount,def.NumberOfMatchesPlayerDidntGoal,avgdeal.resultavg
	from player p,
					(select playerID, count(*) goalcount
					from goals 
					group by playerID) abc--number of goals of a player
					,
					(select playerID, 34-count(*) NumberOfMatchesPlayerDidntGoal
					from goals 
					group by playerID)def--number of matches that player didnt goal
					,
					(select (NumberOfAllGoalsofPlayerTable.NumberOfAllGoalsofPlayer/NumberOfMatchesPlayerGoaledTable.NumberOfMatchesPlayerGoaled) resultavg
					from	
							(select playerID, count(*) NumberOfAllGoalsofPlayer
							from goals 
							group by playerID) NumberOfAllGoalsofPlayerTable
							,
							(select playerID,matchID, count(*) NumberOfMatchesPlayerGoaled
							from goals
							group by playerID,matchID) NumberOfMatchesPlayerGoaledTable
					where NumberOfAllGoalsofPlayerTable.playerID=NumberOfMatchesPlayerGoaledTable.playerID)avgdeal--wanted average
	where p.playerID=abc.playerID and def.playerID=p.playerID
	group by p.playerID,p.firstName,p.lastName,abc.goalcount,def.NumberOfMatchesPlayerDidntGoal,avgdeal.resultavg
	order by abc.goalcount desc

------------------------
select AVG(GoalCountMatchID.goalcount),p.playerID
from			(select count(*) goalcount,matchID,playerID
				from goals 
				group by matchID,playerID) GoalCountMatchID
				,
				player p
where p.playerID=GoalCountMatchID.playerID and p.player=
group by p.playerID
order by GoalCountMatchID.goalcount
				------------------------------------------
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


						






						select abc.playerID,count(*) NumberOfMatchesPlayerGoaled
						from 		
										(select playerID, count(*) goalcount,matchID
										from goals 
										group by playerID,matchID
										)abc
						group by abc.playerID
						order by NumberOfMatchesPlayerGoaled



						select playerID,matchID,count(*)
						from goals
						where matchID=224
						group by playerID,matchID


						select *
						from goals
						where playerID=5
						group by matchID,playerID

			select abc.playerID,count(*) NumberOfMatchesPlayerGoaled
			from 		
							(select playerID, count(*) goalcount,matchID
							from goals 
							group by playerID,matchID
							)abc
			group by abc.playerID
			order by NumberOfMatchesPlayerGoaled
------------------------------------------
--Merge q1
/*
select t.city,totplayer.numberOfPlayers,TotforwardGoals.forwardGoals
from team t,
				(select count(*)numberOfPlayers,teamID
				from player_team
				group by teamID)totplayer,

				(select count(*)forwardGoals,pt.teamID
				from goals g,player_team pt
				where g.isOwnGoal=0  and pt.playerID=g.playerID
				group by pt.teamID)TotforwardGoals
where t.teamID =TotforwardGoals.teamID and totplayer.teamID=t.teamID
				
				
				 /* bir takýmdaki toplam oyuncu sayýsý*/
				select count(*)numberOfPlayers
				from player_team
				group by teamID


				/*bir takýmýn karþýya attýðý toplam göl sayýsý*/
				select count(*)forwardGoals,pt.teamID
				from goals g,player_team pt
				where g.isOwnGoal=0  and pt.playerID=g.playerID
				group by pt.teamID


				----- q1-d done
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

--------------------------------
hm3 merging
select *--mCount.name 'Team Name', mCount.GP,GF.GF
from
	(select team.name, (matchcount.home+matchcount2.visit) GP, team.teamID
	from	team,
			(select homeTeamID, count(*) home
			from match 
			group by homeTeamID) matchcount
			 ,
			(select visitingTeamID, count(*) visit
			from match 
			group by visitingTeamID) matchcount2
	where matchcount.homeTeamID=matchcount2.visitingTeamID and team.teamID=matchcount2.visitingTeamID) mCount 
	,
	(select(fgoal.forwardGoals+ ISNULL(stupidGoal.gcount,0) ) GF,fgoal.teamID
	from
			(select count(g.matchID)forwardGoals,pt.teamID
			from goals g,player_team pt,match m

			where (g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID )
					or
					(g.isOwnGoal=0  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
			group by pt.teamID) fgoal 
		full outer join
			(select count(g.matchID) gcount,teamID
			from goals g,player_team pt,match m
			where (g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.homeTeamID)
			or
			(g.isOwnGoal=1  and pt.playerID=g.playerID and g.matchID=m.matchID and pt.teamID=m.visitingTeamID)
			group by pt.teamID 
			)stupidGoal 
		on stupidGoal.teamID=fgoal.teamID
	) GF
where mCount.teamID=GF.teamID

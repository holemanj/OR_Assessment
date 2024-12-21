const fs=require("fs")

fs.readFile("./TypeScript_Source_Data.txt", function(err,data) {
	processInput(JSON.parse(data));
})

function processInput(ticket_data) {
	let count=0;
	let teams=[];

	class Team {
		constructor(team_name,time,satisfaction) {
			this.total_time = time;
			this.max_time = time;
			this.min_time = time;
			this.total_satisfaction = satisfaction;
			this.max_satisfaction = satisfaction;
			this.min_satisfaction = satisfaction;
			this.count=1;
			this.team_name = team_name;
		}
		check_name(name) {
			if(this.team_name === name) {
				return true;
			} else {
				return false;
			}
		}
		add(time, satisfaction) {
			this.total_time+=time;
			this.total_satisfaction+=satisfaction;
			this.count += 1;
			
			if(time>this.max_time) {
				this.max_time = time;
			}
			if(time<this.min_time) {
				this.min_time = time;
			}
			if(satisfaction>this.max_satisfaction) {
				this.max_satisfaction = satisfaction;
			}
			if(satisfaction<this.min_satisfaction) {
				this.min_satisfaction = satisfaction;
			}
		}
	}

	function exists_team_name(teamname) {
		for(team of teams) {
			if(team.check_name(teamname)) {
				return team;
			}
		}
		return null;
	}

	for(ticket of ticket_data) {
		if(exists_team_name(ticket["assigned_team"])) {
			let team=exists_team_name(ticket["assigned_team"]);
			team.add(parseInt(ticket["time_to_resolve"]),
				parseInt(ticket["customer_satisfaction_rating"]));
		}
		else {
			teams.push(new Team(ticket["assigned_team"],parseInt(ticket["time_to_resolve"]),
				parseInt(ticket["customer_satisfaction_rating"])));
		}
	}

	let out_table = "<html><head>"
	out_table += "<style>"
	out_table += "table, th, td { border: 1px solid black; border-collapse: collapse; text-align: left; padding: 5px;}"
	out_table += "</style>"

	out_table += "</head><body><h1>Summary</h1>"
	out_table += "<table><tr><th>Team</th>"
	out_table += "<th>Tickets Completed</th><th>Average Time</th><th>Best Time</th>"
	out_table += "<th>Worst Time</th><th>Average Satisfaction</th></tr>"
	for(team of teams) {
		out_table += "<tr>"
		let average_time = team.total_time/team.count;
		let average_sat = team.total_satisfaction/team.count;
		out_table += "<td>" + team.team_name + "</td>"
		out_table += "<td>" + team.count + "</td>"
		out_table += "<td>" + average_time.toFixed(2) + "</td>"
		out_table += "<td>" + team.min_time + "</td>"
		out_table += "<td>" + team.max_time + "</td>"
		out_table += "<td>" + average_sat.toFixed(2) + "</td>"
		out_table += "</tr>"
	// For debugging	
	//	console.log(team.team_name + " team handled " + team.count + " tickets.");
	//	console.log("The fastest ticket was completed in " + team.min_time +
	//		" and the slowest took " + team.max_time + ".");
	//	console.log("Average time: " + average_time.toFixed(2) +
	//		" with an average satisfaction of " + average_sat.toFixed(2) + ".\n");
	}

	out_table+="</table></body></html>"

	const email_message = {
		"Messages" :[{
			"From": {Email: "stats@example.com", Name: "Performance Stats Department"},
			"To": {Email: "manager@example.com", Name: "Team Management"},
			"Subject": "Ticket performance stats",
			"TextPart": out_table
		}]
	}

	console.log(JSON.stringify(email_message))
}

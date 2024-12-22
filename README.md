This is my submission for the assessment test for REQ-165792 ITSM System Developer

<p>
  <h2>Requirements as provided:</h2>

  Exercise 1: JavaScript Email Metric Summary

 

Using the attached file (TypeScript_Source_Data.json), create a script in TypeScript (preferred) or JavaScript that:

*  Ingests the data (however you prefer)
*  Aggregate the data into a summary for each assigned team (you have complete creative license as to what metrics or information to summarize)
*  Returns a JavaScript object for an email message (subject, body, etc) that will display each team’s summary in a stylized table in HTML format

 

Exercise 2: PowerShell API Workflow

 

Using PowerShell, create a script that:

 *  Pulls the current staff member list from the Oregon State Legislature (link: https://api.oregonlegislature.gov/odata/odataservice.svc/CommitteeStaffMembers)
 *  Merges the data using the Legislative Session Key from the following source (link: https://api.oregonlegislature.gov/odata/odataservice.svc/LegislativeSessions)
 *  Outputs a CSV containing the individual, the associated legislative session name, the beginning and end times ordered by session begin date/time.
 *  *** Clarification received: for cases where there are multiple entries in the staff member list, "combine the apparent duplicates into a single record"
</p>
<p>
  <h2>Notes on my solutions</h2>

  <h3>For exercise 1</h3>
  I developed my solution on a linux workstation that allowed the execution of the javascript from the command line:
        js email_list.js

  I have three solutions for this:
  1.  email_list.js: I simply copy-pasted the data file into the top of the script, and wrote the processing code below it. Simple and straight-forware
  2.  read_from_file.js: This leverages the fs library from node.js to allow the external data file to be accessed directly. This make for a much smaller script code, implements a separation of concerns (data from the processing), and is a step along the way toward being reusable.
  3.  Typescript_solution directory: I have never actually used Typescript before, and this seemed a good time to expose myself to it (if that phrase made you giggle a little bit, there's a good chance we can be friends). I'm not sure I have the syntax 100% correct, but the typescript compiler did produce a valid JS (in the build sub-directory), which appears to be producing good result.  The code is based off email_list.js above.

  <h3>For exercise 2</h3>
  I have used Powershell for work in the past, I'm far from being a specialist. While my solution produces the required result (output.csv in the folder), I am not convinced it's particularly efficient. Any pointers toward making it more efficient are appreciated.
</p>

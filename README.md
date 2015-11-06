# nirt
Netcat Incident Response Toolkit
 ~ created by Jay Weston

Purpose

This is a comprehensive incident response toolkit that uses trusted utilities via the terminal/cmd.  It is available for both Windows and Linux machines.  This tool is an integrated package using instances of Netcat to allow for a quicker, more simplified and user-friendly incident response.

By piping all the output of commands through Netcat, the impact on the victim machine is minimal in following with best practices. NIRT is unique because it solves the problem of having to open up a new session of netcat for each command run. NIRT handles the sessions for you, and keeps track of the results and the checksums so that you can focus on the investigation quickly and accurately.


How to Use

Written in Perl and therefore Perl needs to be running on your forensic workstation.
Download both the server and client to your forensic workstation into a place that is easy to navigate to.
Send the client over to your victim machine (using a CD is best but downloading it would be fine).
The server will run on your forensic machine, the client will run on your victim machine.
Start the server first by navigating to the location of the downloaded files (cd command) and then type in ‘perl nert_server.pl’ which will start the server.
After the server is started, you can start your client.  Do this by navigating (on your victim machine) to the location of the files and typing in ‘perl nirt_client.pl’ to start the client and open up a Netcat session with the server.
Change the hostname of the file by typing in your name.  This creates a folder that your results will go into.
You can now type commands in that will be sent over the Netcat session and saved in the created folder (in the same directory as the downloaded NIRT files).
A log is kept with that contains the tools you typed in, as well as two checksums of the resulting file.  This way, you have two checksums to check against when you complete your forensic response/report.


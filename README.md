# nirt
Netcat Incident Response Toolkit
created by Jay Weston

Goal: to provide a comprehensive incident reponse tool that uses trusted utilities in an integrated package with instances of netcat to allow for simplified, quicker, user-friendly indcident response.  

By piping all the output of commands through netcat, you can be sure that the impact on the victim machine is minimal in following with best practices.  Nirt is unique because it solves the problem of having to open up a new session of netcat for each command run.  Nirt handles the sessions for you so that you can focus on the investigation and not waste time messing around with your tools.



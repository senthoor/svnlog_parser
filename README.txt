This script scans the SVN log and creates a summery report. The report has Revision numbers, Bug IDs, Person Checked in and SVN Comments. Svn Comments have certain words marked in Bold, like merge, merging and 5 digit numbers.

How to use
----------
Needs ruby Language (http://www.ruby-lang.org/en/downloads/)

Running
-------
svnchgreport.rb "svn log command" outputfile

example:
svnchgreport.rb "svn log -r18911:18920 http://svn.valista.com/project/verizon/vasip/branches/2.1_02_stabilization" outputfile.html

Output
------
svn_history.html or the given outputfile name will have the summery

Change Log
----------
Output file contains the check in person name
An output file can be specified in the command line
The svn log statement is now a command line paramater
Bug fixed with checkin related to 3 bugs
Bug fix as to duplicate bugs shown in the output file

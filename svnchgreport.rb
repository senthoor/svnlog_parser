require 'net/http'
require 'Revision'
require 'SvnRevHistory'

#change the SVN COMMAND here
svn_command=ARGV[0].sub('svn','').sub('log','') #-r18911:HEAD http://svn.valista.com/project/verizon/vasip/branches/2.1_02_stabilization'
puts "SVN COMMAND : svn log " + svn_command.strip
result = %x[svn log #{svn_command}]

if ($?!=0)
	puts "\nplease double check your svn log command:" + ARGV[0]
	exit 1
end

revRegEx = /^r(\d{5,5}) \| ([\w_.]*) \|/
noOfCommentRegEx=/(\d*) (line|lines)$/
bugRegEx = [/[Bb]ug[s#]{0,1} *(\d{5,5})/,/[Bb]ug *(\d{5,5}) *(\d{5,5})/,/[Bb]ug *(\d{5,5}) *(\d{5,5}) *(\d{5,5})/,/[Bb]ug *(\d{5,5}) *(\d{5,5}) *(\d{5,5}) *(\d{5,5})/,/[Bb]ug *(\d{5,5}) *(\d{5,5}) *(\d{5,5}) *(\d{5,5}) *(\d{5,5})/]

#writing the result to a file
File.open("svn.log","w") do |file|
	 file.write(result)
end
svnRevHistory = SvnRevHistory.new(svn_command)
File.open("svn.log","r") do |file|
	#get hold of a block
	svn_revision = {}
	revisionObj = nil
	file.readline # reading line ------
	while line = file.gets
	        matchObj = revRegEx.match(line)
		revision =matchObj[1]
		revisionObj = Revision.new(revision)
		revisionObj.developer= matchObj[2]

		noOfCommentLines = noOfCommentRegEx.match(line)[1]
		file.readline # reading empty line
		for num in (1..noOfCommentLines.to_i) 
			svnComment = file.readline
			puts svnComment
			revisionObj.svnComment=revisionObj.svnComment + '<br/>' + svnComment.strip
			for bugRegCount in (0..bugRegEx.length-1)
				bugMatchData = bugRegEx[bugRegCount].match(svnComment)
				if (bugMatchData)
					for bugLength in (1.. bugMatchData.length-1)
						puts bugMatchData[bugLength]
						revisionObj.bugId=bugMatchData[bugLength]
						revisionObj.areBugsFixed=true
					end
				end
			end
		end
		svnRevHistory.addRevision(revisionObj)
		file.readline # reading line ------
		puts "---------------------------------------------------------"
	end
end

filename = ARGV[1]

if (filename == nil)
	File.new("svn_history.html","w").write(svnRevHistory.to_s)
else
	File.new(filename,"w").write(svnRevHistory.to_s)
end

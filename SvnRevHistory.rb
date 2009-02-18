class SvnRevHistory
	
	def initialize(command)
		@command=command
		@svnHistory={}
	end
	def addRevision(revisionObj)
		@svnHistory[revisionObj.revision]=revisionObj
	end
	def getRevision(revisionNum)
		@svnHistory[revisionNum]
	end
	def to_s()
		globalTemplate= "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">
		<html>
		<head>
		<title>Svn History - [COMMAND]</title>
		</head>
		<body>
			<font size=\"2\" color=\"#000000\" face=\"Arial\">
			<div>
			<table width=\"1280\" bgcolor=\"#FFFFFF\" cellpadding=\"1\" bordercolor=\"#000000\" cellspacing=\"3\">
			<tr valign=\"top\" bgcolor=\"#4096EE\">
				<td width=\"100\"><b>REVISION</b></td>
				<td width=\"200\"><b>BUG ID</b></td>
				<td width=\"200\"><b>CHECK IN BY</b></td>
				<td><b>SVN COMMENT</b></td>
			</tr>
			[ROW_TEMPLATE]
			</table>
			</div>
			</font>

		</body>
		</html>"
		results = ''
		@svnHistory.keys.sort.each do |revision|
			if ( @svnHistory[revision].areBugsFixed)
		   		results = results + @svnHistory[revision].to_s
			end
		end
		globalTemplate.sub('[COMMAND]',@command).sub('[ROW_TEMPLATE]',results)
		@svnHistory.keys.sort.each do |revision|
			if (! @svnHistory[revision].areBugsFixed)
		   		results = results + @svnHistory[revision].to_s
			end
		end
		globalTemplate.sub('[COMMAND]',@command).sub('[ROW_TEMPLATE]',results)		
	end
end

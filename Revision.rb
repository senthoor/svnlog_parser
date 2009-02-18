class Revision
	attr_reader :revision, :bugId, :svnComment, :areBugsFixed, :developer
	def initialize(revision)
		@revision=revision
		@bugId=[]
		@svnComment=''
		@areBugsFixed=false
	end
	def revision=(revision)
		@revision=revision
	end
	def bugId=(bugId)
		@bugId[@bugId.length+1]=[bugId]
		@areBugsFixed=true
	end
	def svnComment=(svnComment)
		@svnComment=svnComment
	end
	def areBugsFixed=(areBugsFixed)
		@areBugsFixed=areBugsFixed
	end
	def developer=(developer)
		@developer=developer
	end
	def to_s()
		bug_url='<a href="http://bugzilla.valista.com/show_bug.cgi?id=[BUGURL]">[BUGURL]</a>'
		svn_revision_change_url='<a href="http://viewsvn.valista.com/viewsvn?view=rev&rev=[revision]">[revision]</a>'
	
		row_template="<tr valign=\"top\" bgcolor=\"#C3D9FF\">
		<td width=\"100\">[REVISION]</td>
		<td width=\"200\">[BUGID]</td>
		<td width=\"200\">[DEV]</td>
		<td>[SVNCOMMENT]</td>
		</tr>"
		results = row_template.sub('[REVISION]',svn_revision_change_url.gsub('[revision]',@revision))
		results = results.sub('[DEV]',@developer)
		bugList = ''
		@bugId = @bugId & @bugId
		for bugCount in (0..@bugId.length-1)
			bugList = bugList +bug_url.gsub('[BUGURL]',@bugId[bugCount].to_s) + "    "
		end
		results = results.sub('[BUGID]',bugList)
		results.sub('[SVNCOMMENT]',@svnComment.sub('merge','<b>merge</b>').sub('merged','<b>merged</b>').sub('Merged','<b>Merged</b>').sub('merging','<b>merging</b>').gsub(/(\d{5,5})[ $]*/,' <b>\1</b> '))
	end
end

<!-----------------------------------------------------------------------********************************************************************************Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corpwww.coldbox.org | www.luismajano.com | www.ortussolutions.com********************************************************************************Author 	 :	Luis MajanoDate     :	September 23, 2005Description :	This is a utilities library that are file related, most of them.Modification History:-----------------------------------------------------------------------><cfcomponent hint="This is a File Utilities CFC"       		 output="false"       		 cache="true"><!------------------------------------------- CONSTRUCTOR ------------------------------------------->	<cffunction name="init" access="public" returntype="FileUtils" output="false">		<cfscript>						setpluginName("File Utilities Plugin");			setpluginVersion("1.0");			setpluginDescription("This plugin provides various file utilities");			setpluginAuthor("Luis Majano, Sana Ullah");			setpluginAuthorURL("http://www.coldbox.org");						return this;		</cfscript>	</cffunction><!------------------------------------------- CFFILE FACADES ------------------------------------------->	<!--- upload File --->	<cffunction name="uploadFile" access="public" hint="Facade to upload to a file, returns the cffile variable." returntype="any" output="false">		<!--- ************************************************************* --->		<cfargument name="FileField"         type="string" 	required="yes" 		hint="The name of the form field used to select the file">		<cfargument name="Destination"       type="string" 	required="yes"      hint="The absolute path to the destination.">		<cfargument name="NameConflict"      type="string"  required="false" default="makeunique" hint="Action to take if filename is the same as that of a file in the directory.">		<cfargument name="Accept"            type="string"  required="false" default="" hint="Limits the MIME types to accept. Comma-delimited list.">		<cfargument name="Attributes"  		 type="string"  required="false" default="Normal" hint="Comma-delimitted list of window file attributes">		<cfargument name="Mode" 			 type="string"  required="false" default="755" 	  hint="The mode of the file for Unix systems, the default is 755">		<!--- *************************************** --->				<cfset var results = "">				<cffile action="upload" 				filefield="#arguments.FileField#" 				destination="#arguments.Destination#" 				nameconflict="#arguments.NameConflict#" 				accept="#arguments.Accept#"				mode="#arguments.Mode#"				Attributes="#arguments.Attributes#"				result="results">				<cfreturn results>	</cffunction>   	<!--- readFile --->	<cffunction name="readFile" access="public" hint="Facade to Read a file's content" returntype="Any" output="false">		<!--- ************************************************************* --->		<cfargument name="FileToRead"	 		type="String"  required="yes" 	 hint="The absolute path to the file.">		<cfargument name="ReadInBinaryFlag" 	type="boolean" required="false" default="false" hint="Read in binary flag.">		<cfargument name="CharSet"				type="string"  required="false" default="" hint="CF File CharSet Encoding to use.">		<cfargument name="CheckCharSetFlag" 	type="boolean" required="false" default="false" hint="Check the charset.">		<!--- ************************************************************* --->		<cfset var FileContents = "">		<!--- Verify File Encoding to use --->		<cfif arguments.CheckCharSetFlag><cfset arguments.charset = checkCharSet(arguments.CharSet)></cfif>		<!--- Binary Test --->		<cfif ReadInBinaryFlag>			<cffile action="readbinary" file="#arguments.FileToRead#" variable="FileContents">		<cfelse>			<cfif arguments.charset neq "">				<cffile action="read" file="#arguments.FileToRead#" variable="FileContents" charset="#arguments.charset#">			<cfelse>				<cffile action="read" file="#arguments.FileToRead#" variable="FileContents">			</cfif>		</cfif>		<cfreturn FileContents>	</cffunction>	<!--- Save File --->	<cffunction name="saveFile" access="public" hint="Facade to save a file's content" returntype="void" output="false">		<!--- ************************************************************* --->		<cfargument name="FileToSave"	 	type="any"  	required="yes" 	 hint="The absolute path to the file.">		<cfargument name="FileContents" 	type="any"  	required="yes"   hint="The file contents">		<cfargument name="CharSet"			type="string"  	required="false" default="utf-8" hint="CF File CharSet Encoding to use.">		<cfargument name="CheckCharSetFlag" type="boolean"	required="false" default="false" hint="Check the charset.">		<!--- ************************************************************* --->		<!--- Verify File Encoding to use --->		<cfif arguments.CheckCharSetFlag><cfset arguments.charset = checkCharSet(arguments.CharSet)></cfif>		<cffile action="write" file="#arguments.FileToSave#" output="#arguments.FileContents#" charset="#arguments.charset#">	</cffunction>	<!--- appendFile --->	<cffunction name="appendFile" access="public" hint="Facade to append to a file's content" returntype="void" output="false">		<!--- ************************************************************* --->		<cfargument name="FileToSave"	 	type="any"  	required="yes" 	 hint="The absolute path to the file.">		<cfargument name="FileContents" 	type="any"  	required="yes"   hint="The file contents">		<cfargument name="CharSet"			type="string"	required="false" default="utf-8" hint="CF File CharSet Encoding to use.">		<cfargument name="CheckCharSetFlag" type="boolean"	required="false" default="false" hint="Check the charset.">		<!--- ************************************************************* --->		<!--- Verify File Encoding to use --->		<cfif arguments.CheckCharSetFlag><cfset arguments.charset = checkCharSet(arguments.CharSet)></cfif>		<cffile action="append" file="#arguments.FileToSave#" output="#arguments.FileContents#" charset="#arguments.charset#">	</cffunction>	<!--- sendFile --->	<cffunction name="sendFile" output="false" access="public" returntype="void" hint="Send a file to the browser">		<!--- ************************************************************* --->		<cfargument name="file"	 		type="any"  	required="false" 	default="" hint="The absolute path to the file or a binary file">		<cfargument name="name" 		type="string"  	required="false" 	default="" hint="The name to send the file to the browser. If not sent in, it will use the name of the file or a UUID for a binary file"/>		<cfargument name="mimeType" 	type="string"  	required="false" 	default="" hint="A valid mime type to use. If not sent in, we will try to use a default one according to file extension"/>		<cfargument name="disposition"  type="string" 	required="false" 	default="attachment" hint="The browser content disposition (attachment/inline)"/>		<cfargument name="abortAtEnd" 	type="boolean" 	required="false" 	default="false" hint="Do an abort after content sending"/>		<cfargument name="extension" 	type="string" 	required="false" 	default="" hint="Only used if file is binary. e.g. jpg or gif"/>		<cfargument name="deleteFile"   type="string"   required="false"    default="false" hint="Delete the file after sending. Only used if file is not binary"/>		<!--- ************************************************************* --->		<!--- Binary File? --->		<cfif isBinary(arguments.file)>			<!--- Create unique ID? --->			<cfif len(trim(arguments.name)) eq 0>				<cfset arguments.name = CreateUUID()>			</cfif>					<!--- No Extension in arguments? --->			<cfif TRIM(arguments.extension) eq ''>				<cfthrow message="Extension for binary file missing" detail="Please provide the extension argument when using a binary file" type="Utilities.ArgumentMissingException">			</cfif>					<cfelseif fileExists(arguments.file)>		<!--- File with absolute path --->						<!--- File name? --->			<cfif len(trim(arguments.name)) eq 0>				<cfset arguments.name = ripExtension(getFileFromPath(arguments.file))>			</cfif>						<!--- Set extension --->			<cfset arguments.extension = listLast(arguments.file,".")>				<cfelse>			<!--- No binary file and no file found using absolute path --->			<cfthrow message="File not found" detail="The file '#arguments.file#' cannot be located. Argument FILE requires an absolute file path or a binary file." type="Utilities.FileNotFoundException">		</cfif>				<!--- Lookup mime type for Extension? --->		<cfif len(trim(arguments.mimetype)) eq 0>			<cfset arguments.mimetype = getFileMimeType(extension)>		</cfif>				<!--- Set content header --->		<cfheader name="content-disposition" value='#arguments.disposition#; filename="#arguments.name#.#extension#"'>		<!--- Send file --->		<cfif isBinary(arguments.file)>			<cfcontent type="#arguments.mimetype#" variable="#arguments.file#"/>				<cfelse>			<cfcontent type="#arguments.mimetype#" file="#arguments.file#" deletefile="#arguments.deleteFile#">		</cfif>				<!--- Abort further processing? --->		<cfif arguments.abortAtEnd><cfabort></cfif>	</cffunction>		<!--- getFileMimeType --->	<cffunction name="getFileMimeType" output="false" access="public" returntype="string" hint="Get's the file mime type for a given file extension">		<cfargument name="extension" type="string" required="true" hint="e.g. jpg or gif" />				<cfset var fileMimeType = ''>				<cfswitch expression="#LCASE(arguments.extension)#">			<cfcase value="txt,js,css,cfm,cfc,html,htm,jsp">				<cfset fileMimeType = 'text/plain'>			</cfcase>			<cfcase value="gif">				<cfset fileMimeType = 'image/gif'>			</cfcase>			<cfcase value="jpg">				<cfset fileMimeType = 'image/jpg'>			</cfcase>			<cfcase value="png">				<cfset fileMimeType = 'image/png'>			</cfcase>			<cfcase value="wav">				<cfset fileMimeType = 'audio/wav'>			</cfcase>			<cfcase value="mp3">				<cfset fileMimeType = 'audio/mpeg3'>			</cfcase>			<cfcase value="pdf">				<cfset fileMimeType = 'application/pdf'>			</cfcase>			<cfcase value="zip">				<cfset fileMimeType = 'application/zip'>			</cfcase>			<cfcase value="ppt">				<cfset fileMimeType = 'application/vnd.ms-powerpoint'>			</cfcase>			<cfcase value="doc">				<cfset fileMimeType = 'application/msword'>			</cfcase>			<cfcase value="xls">				<cfset fileMimeType = 'application/vnd.ms-excel'>			</cfcase>			<cfdefaultcase>				<cfset fileMimeType = 'application/octet-stream'>			</cfdefaultcase>		</cfswitch>		 <!--- More mimeTypes: http://www.iana.org/assignments/media-types/application/ --->		 		 <cfreturn fileMimeType>	</cffunction>	<!--- fileLastModified --->	<cffunction name="fileLastModified" access="public" returntype="string" output="false" hint="Get the last modified date of a file">		<!--- ************************************************************* --->		<cfargument name="filename" type="string" required="yes">		<!--- ************************************************************* --->		<cfscript>		var objFile =  createObject("java","java.io.File").init(JavaCast("string",arguments.filename));		// Calculate adjustments fot timezone and daylightsavindtime		var Offset = ((GetTimeZoneInfo().utcHourOffset)+1)*-3600;		// Date is returned as number of seconds since 1-1-1970		return DateAdd('s', (Round(objFile.lastModified()/1000))+Offset, CreateDateTime(1970, 1, 1, 0, 0, 0));		</cfscript>	</cffunction>	<!--- fileSize --->	<cffunction name="fileSize" access="public" returntype="string" output="false" hint="Get the filesize of a file.">		<!--- ************************************************************* --->		<cfargument name="filename"   type="string" required="yes">		<cfargument name="sizeFormat" type="string" required="no" default="bytes" hint="Available formats: [bytes][kbytes][mbytes][gbytes]">		<!--- ************************************************************* --->		<cfscript>		var objFile =  createObject("java","java.io.File");		objFile.init(JavaCast("string", filename));		if ( arguments.sizeFormat eq "bytes" )			return objFile.length();		if ( arguments.sizeFormat eq "kbytes" )			return (objFile.length()/1024);		if ( arguments.sizeFormat eq "mbytes" )			return (objFile.length()/(1048576));		if ( arguments.sizeFormat eq "gbytes" )			return (objFile.length()/1073741824);		</cfscript>	</cffunction>	<!--- removeFile --->	<cffunction name="removeFile" access="public" hint="Remove a file using java.io.File" returntype="boolean" output="false">		<!--- ************************************************************* --->		<cfargument name="filename"	 	type="string"  required="yes" 	 hint="The absolute path to the file.">		<!--- ************************************************************* --->		<cfscript>		var fileObj = createObject("java","java.io.File").init(JavaCast("string",arguments.filename));		return fileObj.delete();		</cfscript>	</cffunction>	<!--- createFile --->	<cffunction name="createFile" access="public" hint="Create a new empty fileusing java.io.File." returntype="void" output="false">		<!--- ************************************************************* --->		<cfargument name="filename"	 	type="String"  required="yes" 	 hint="The absolute path of the file to create.">		<!--- ************************************************************* --->		<cfscript>		var fileObj = createObject("java","java.io.File").init(JavaCast("string",arguments.filename));		fileObj.createNewFile();		</cfscript>	</cffunction>	<!--- fileCanWrite --->	<cffunction name="fileCanWrite" access="public" hint="Check wether you can write to a file" returntype="boolean" output="false">		<!--- ************************************************************* --->		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">		<!--- ************************************************************* --->		<cfscript>		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));		return FileObj.canWrite();		</cfscript>	</cffunction>	<!--- fileCanRead --->	<cffunction name="fileCanRead" access="public" hint="Check wether you can read a file" returntype="boolean" output="false">		<!--- ************************************************************* --->		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">		<!--- ************************************************************* --->		<cfscript>		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));		return FileObj.canRead();		</cfscript>	</cffunction>	<!--- isFile --->	<cffunction name="isFile" access="public" hint="Checks whether the filename argument is a file or not." returntype="boolean" output="false">		<!--- ************************************************************* --->		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">		<!--- ************************************************************* --->		<cfscript>		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));		return FileObj.isFile();		</cfscript>	</cffunction>	<!--- isDirectory --->	<cffunction name="isDirectory" access="public" hint="Check wether the filename argument is a directory or not" returntype="boolean" output="false">		<!--- ************************************************************* --->		<cfargument name="Filename"	 type="String"  required="yes" 	 hint="The absolute path of the file to check.">		<!--- ************************************************************* --->		<cfscript>		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.Filename));		return FileObj.isDirectory();		</cfscript>	</cffunction>	<!--- getAbsolutePath --->	<cffunction name="getAbsolutePath" access="public" output="false" returntype="string" hint="Turn any system path, either relative or absolute, into a fully qualified one">		<!--- ************************************************************* --->		<cfargument name="path" type="string" required="true" hint="Abstract pathname">		<!--- ************************************************************* --->		<cfscript>		var FileObj = CreateObject("java","java.io.File").init(JavaCast("String",arguments.path));		if(FileObj.isAbsolute()){			return arguments.path;		}		else{			return ExpandPath(arguments.path);		}		</cfscript>	</cffunction>	<!--- checkCharSet --->	<cffunction name="checkCharSet" access="public" output="false" returntype="string" hint="Check a charset with valid CF char sets, if invalid, it returns the framework's default character set">		<!--- ************************************************************* --->		<cfargument name="charset" type="string" required="true" hint="Charset to check">		<!--- ************************************************************* --->		<cfscript>		if ( listFindNoCase(getController().getSetting("AvailableCFCharacterSets",1),lcase(arguments.charset)) )			return getController().getSetting("DefaultFileCharacterSet",1);		else			return arguments.charset;		</cfscript>	</cffunction>	<!--- ripExtension --->	<cffunction name="ripExtension" access="public" returntype="string" output="false" hint="Rip the extension of a filename.">		<cfargument name="filename" type="string" required="true">		<cfreturn reReplace(arguments.filename,"\.[^.]*$","")>	</cffunction>	<!---	Copies a directory.		@param source      Source directory. (Required)	@param destination      Destination directory. (Required)	@param nameConflict      What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)	@return Returns nothing. 	@author Joe Rinehart (joe.rinehart@gmail.com), mod by Luis Majano 2010	@version 2, February 4, 2010 	--->	<cffunction name="directoryCopy" output="true" hint="Copies an entire source directory to a destination directory" returntype="void">	    <cfargument name="source" 		required="true" type="string">	    <cfargument name="destination" 	required="true" type="string">	    <cfargument name="nameconflict" required="true" default="overwrite">		    <cfset var contents = "" />	    	    <cfif not(directoryExists(arguments.destination))>	        <cfdirectory action="create" directory="#arguments.destination#">	    </cfif>	    	    <cfdirectory action="list" directory="#arguments.source#" name="contents">	    	    <cfloop query="contents">	        <cfif contents.type eq "file">	            <cffile action="copy" source="#arguments.source#/#name#" destination="#arguments.destination#/#name#" nameconflict="#arguments.nameConflict#">	        <cfelseif contents.type eq "dir">	            <cfset directoryCopy(arguments.source & "/" & name, arguments.destination & "/" & name, arguments.nameconflict) />	        </cfif>	    </cfloop>	</cffunction></cfcomponent>
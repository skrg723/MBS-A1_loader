#pragma rtGlobals=3		// Use modern global access method and strict wave access.

//ver1.0
//21th Oct. 2019, Sakuragi

Menu "Macros"
	"MBS-A1: load folder", load_folder()
	"MBS-A1: load file", load_file()
End

Function load_file()
	String cdf=GetDataFolder(1)
	NewPath/O/Q/M="Select data folder" path
 	if (V_flag != 0) 
		return -1; 
 	endif
 	pathinfo path
 	String name; Variable i
 	Prompt name, "select file", popup, IndexedFile(path, -1, ".txt")
	DoPrompt "file loader", name
	If(V_flag)
		abort
	Endif
	string fileID
	NewDataFolder/O/S root:MBS_loader
	SetDatafolder root:MBS_loader
	String str=hoge(name, fileID, i); str=ReplaceString(";", str, "")
	name=ReplaceString(".txt", name, ""); name=ReplaceString("-", name, "")
	scale_and_note()
	Rename loadMat0 $name
	KillDataFolder $str
	cd cdf
End

Function load_folder()
	String cdf=GetDataFolder(1)
	NewPath/O/Q/M="Select data folder" path
 	if (V_flag != 0) 
		return -1; // User cancelled. 
 	endif
 	pathinfo path
 	String list = IndexedFile(path, -1, ".txt"); list = SortList(list, ";", 16)
	Variable num=ItemsInList(list), i
	String fileID
	NewDataFolder/O/S root:MBS_loader
	SetDatafolder root:MBS_loader
	If(WaveExists($"file_name")==0)
		Make/O/T/N=(0) file_name; Wave/T wvname=file_name 
	Else
		Wave/T wvname=file_name 
	Endif
	killwaves file_name
	For(i=0; i<num; i+=1)
		String name=StringFromList(i, list); name=ReplaceString(".txt", name, ""); name=ReplaceString("-", name, "")
		Variable n=check_name(name, wvname)
		If(n!=0)
			String str=hoge(list, fileID, i); str=ReplaceString(";", str, "")
			name=ReplaceString(".txt", name, ""); name=ReplaceString("-", name, "")
			scale_and_note()
			Rename loadMat0 $name
			//Variable p=DimSize(wvname, 0)
			//Redimension/N=(p+1) wvname; wvname[p]=name
			KillDataFolder $str
		Endif
	Endfor
	cd cdf
End


Function/S hoge(list, fileID, i)
	string fileID 
	Variable i 
	string list
	wave loadnote, loadInfo, loadMat
	String name=StringFromList(i,list), indent
	Loadwave/j/q/F={1,50,-2}/k=2/n=loadnote /P=path name
	loadwave/j/q/k=1/n=loadInfo /P=path name
	LoadWave/G/M/D/Q/N=loadMat/L={0,0,0,1,0} /P=path name
End


Function scale_and_note()
	wave loadInfo0, loadMat0, loadInfo1
	wave/T loadnote0
	variable j 
	SetScale/P x, loadInfo1[10], loadInfo1[11], loadMat0
	SetScale/P y, loadInfo1[54], loadInfo1[52], loadMat0
	Redimension /N=56 loadnote0
	for(j=0; j<56; j+=1)
		Note loadMat0, loadnote0[j]
	endfor
	Killwaves loadnote0, loadinfo0 loadinfo1
End

Function/D check_name(name, wvname)
	String name; Wave/T wvname
	Variable num=DimSize(wvname, 0), i, c=1
	For(i=0; i<num; i+=1)
		String str=wvname[i]
		If(cmpstr(name, str)==0)
			c=0*c
		Endif
	Endfor
	return c
End
	

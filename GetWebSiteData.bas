#include once "windows.bi"
#include once "win\ole2.bi"
#include once "win\oleauto.bi"

Type CLSID_XMLHTTPREQUEST_inline
	b(3) As ULong
End Type

Type IID_IXmlHttpRequest_inline
	b(3) As ULong
End Type

Function GetXmlHttpRequest()As IXMLHttpRequest Ptr
	
	Dim clsidXML As CLSID_XMLHTTPREQUEST_inline = Any
	clsidXML.b(0) = &hED8C108E
	clsidXML.b(1) = &h11D24349
	clsidXML.b(2) = &hC000A491
	clsidXML.b(3) = &hE869794F
	
	Dim iidXml As IID_IXmlHttpRequest_inline = Any
	iidXml.b(0) = &hED8C108D
	iidXml.b(1) = &h11D24349
	iidXml.b(2) = &hC000A491
	iidXml.b(3) = &hE869794F
	
	Dim pRequest As IXMLHttpRequest Ptr = Any
	Dim hrCreateInstance As HRESULT = CoCreateInstance( _
		Cast(REFCLSID, @clsidXML), _
		NULL, _
		CLSCTX_INPROC, _
		Cast(REFIID, @iidXml), _
		@pRequest _
	)
	
	/'
	Dim hrCreateInstance As HRESULT = CoCreateInstance( _
		@CLSID_XMLHTTPREQUEST, _
		NULL, _
		CLSCTX_INPROC, _
		@IID_IXmlHttpRequest, _
		@pRequest _
	)
	'/
	
	If FAILED(hrCreateInstance) Then
		Return NULL
	End If
	
	Return pRequest

End Function

Function GetBody( _
		ByVal pRequest As IXMLHttpRequest Ptr, _
		byVal bstrUrl As BSTR, _
		ByVal varBody As VARIANT Ptr _
	)As HRESULT
	
	Dim varFalse As VARIANT = Any
	With varFalse
		.vt = VT_BOOL
		.boolVal = VARIANT_FALSE
	End With
	
	Dim varEmptyBSTR As VARIANT = Any
	With varEmptyBSTR
		.vt = VT_BSTR
		.bstrVal = NULL
	End With
	
	Dim hrRetValue As HRESULT = Any
	
	Dim bstrMethod As BSTR = SysAllocString(WStr("GET"))
	Dim hrOpen As HRESULT = IXMLHttpRequest_Open( _
		pRequest, _
		bstrMethod, _
		bstrUrl, _
		varFalse, _
		varEmptyBSTR, _
		varEmptyBSTR _
	)
	If FAILED(hrOpen) Then
		hrRetValue = hrOpen
	Else
		Dim hrSend As HRESULT = IXMLHttpRequest_Send( _
			pRequest, _
			varEmptyBSTR _
		)
		If FAILED(hrSend) Then
			hrRetValue = hrSend
		Else
			Dim hrResponseBody As HRESULT = IXMLHttpRequest_get_responseBody( _
				pRequest, _
				varBody _
			)
			If FAILED(hrResponseBody) Then
				hrRetValue = hrResponseBody
			Else
				hrRetValue = S_OK
			End If
		End If
	End If
	
	Return hrRetValue
	
End Function

Function DownloadFile( _
		ByVal bstrUrl As BSTR, _
		ByVal hOut As HANDLE _
	)As HRESULT
	
	Dim hrRetValue As HRESULT = Any
	
	Dim pRequest As IXMLHttpRequest Ptr = GetXmlHttpRequest()
	If pRequest = NULL Then
		hrRetValue = E_OUTOFMEMORY
	Else
		Dim varBody As VARIANT = Any
		Dim hrResponseBody As HRESULT = GetBody( _
			pRequest, _
			bstrUrl, _
			@varBody _
		)
		If FAILED(hrResponseBody) Then
			hrRetValue = hrResponseBody
		Else
			
			Dim pArray As UByte Ptr = Any
			Dim hrAccessData As HRESULT = SafeArrayAccessData( _
				varBody.parray, _
				@pArray _
			)
			If FAILED(hrAccessData) Then
				hrRetValue = hrAccessData
			Else
				Dim ArrayLength As Integer = varBody.parray->rgsabound(0).cElements
				Dim NumberOfCharsWritten As DWORD = Any
				WriteFile( _
					hOut, _
					pArray, _
					Cast(DWORD, ArrayLength), _
					@NumberOfCharsWritten, _
					NULL _
				)
				SafeArrayUnaccessData(varBody.parray)
				
				hrRetValue = S_OK
			End If
		End If
		
	End If
	
	Return hrRetValue
	
End Function

Function GetFirstParam( _
		ByVal cmdLine As WString Ptr _
	)As WString Ptr
	
	Dim pSpace As WString Ptr = cmdLine
	
	Do
		pSpace += 1
		
		If pSpace[0] = 32 Then
			Exit Do
		End If
		
		If pSpace[0] = 0 Then
			Return 0
		End If
	Loop
	
	pSpace += 1
	
	Return pSpace
	
End Function

Sub EntryPoint()
	
	CoInitialize(0)
	
	Dim RetValue As Integer = Any
	
	Dim cmdLine As WString Ptr = GetCommandLineW()
	Dim Param As WString Ptr = GetFirstParam(cmdLine)
	
	Dim bstrUrl As BSTR = SysAllocString(Param)
	Dim hOut As HANDLE = GetStdHandle(STD_OUTPUT_HANDLE)
	
	Dim hrDowLoad As HRESULT = DownloadFile(bstrUrl, hOut)
	If FAILED(hrDowLoad) Then
		RetValue = 1
	Else
		RetValue = 0
	End If
	
	ExitProcess(RetValue)
	
End Sub

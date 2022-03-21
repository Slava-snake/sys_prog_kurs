;	��� ���
;	������� ���
;	
;	�������� ������
;		
;	��������� ����������������
;
;	�������� ���-120�
;	��������� �.�.
;
;	������������� 
;	��������� ��������� �.�.
;

include c:\masm64\include64\masm64rt.inc

IDD_DLG1	EQU 1000
IDD_DLG2	EQU 1001
IDD_DLG3	EQU 1002
IDD_DLG4	EQU 1003
IDD_DLG5	EQU 1004
IDD_DLG6	EQU 1005

IDI_ICON	EQU 1100
IDI_PING	EQU 1101
IDI_STAR	EQU 1102
IDI_UKR		EQU 1103
IDI_ME		EQU 1104
IDI_RUK		EQU 1105

IDC_IMG1	EQU 100
IDC_IMG2	EQU 101
IDC_IMG3	EQU 102
IDC_IMG4	EQU 103

IDB_TRI		EQU	200
IDB_BANK	EQU	201
IDB_MAKO	EQU 202

IDC_TXT1	EQU 1030

IDC_AIM		EQU 1020
IDC_BTN1	EQU 1021
IDC_BTN2	EQU 1022
IDC_EXEC	EQU 1023
IDC_LEAD	EQU 1024
IDC_NEXT	EQU 1025
IDC_BACK	EQU 1026
IDC_NXT		EQU 1027
IDC_BCK		EQU 1028
IDC_BANK	EQU 1029
StepStar	EQU 16		;��� ����� ��� �������������� ������
StepBagel	EQU 32		;��� ������� ��� ��������
BlackBoardColor	EQU 0074795Ch	;���� �����
COLOR_BANK5	EQU 00FFFFFFh	;���������� ���� 5 ����
MAKO_MASK	EQU 00F0F0F0h	;����� ��� BMP ������� 6 ����

MINMAXINFO STRUCT
	ptReserved		POINT	<>
	ptMaxSize		POINT	<>
	ptMaxPosition	POINT	<>
	ptMinTrackSize	POINT	<>
	ptMaxTrackSize	POINT	<>
MINMAXINFO ENDS

MSGBOXPARAMS STRUCT QWORD
	cbSize				dd ?
	hwndOwner			dq ?
	hInstance			dq ?
	lpszText			dq ?
	lpszCaption			dq ?
	dwStyle				dd ?
	lpszIcon			dq ?
	dwContextHelpId		dq ?
	lpfnMsgBoxCallback	dq ?
	dwLanguageId		dd ?
MSGBOXPARAMS ENDS

.const
	wClassName		db	'MainWindowClass', 0
	wWindowTitle	db	'�������� ������ �������� ���-120� ��������� �.�.',0
	wFontName		db	'Times New Roman', 0
	BigImage		db	'big.bmp',0
	exename			db	'lemniskata.exe',0
	inf_txt1		db	'��������� �.�. ���-120�',0
	inf_len1		equ	($-inf_txt1)/type inf_txt1
	inf_txt2		db	'������� ���    ��� ���',0
	inf_len2		equ	($-inf_txt2)/type inf_txt2
	ruk_title		db	'���������� � ������������',0
	ruk_text		db	'��������� ��������� ����������.',10,
						'������� 22.09.1957.',10,
						'�������� � ��� ���Ȕ � 2006 �.',10,
						'�� ��������� ����. ������� ���ϔ � 2013 �.',10,
						'��������� ��� ��� � 2015 �. ������� ���',0
	author_title	db	'���������� �� �����������',0
	author_text		db	'��������� ��������� ������������.',10,
						'������� 13.08.2003.',10,
						'������ � ��� ���Ȕ � 2020 �.',10,
						'�� ������������ ���.',10,
						'������� ��� ��� � 2020 �. ������� ���',0

.data
	hInstance	dq	0
	hBig		dq	0
	hMe			dq	0
	hR3			dq	0
	hPing		dq	0	
	hIcon		dq	0
	hStar		dq	0
	hUkr		dq	0
	hBMP3		dq	0
	hBank		dq	0
	hMako		dq	0
	hBit		dq	0
	hBitIcon	dq	0
	hText		dq	0
	hBaim		dq	0
	hBbank		dq	0
	hBnxt		dq	0
	hBbck		dq	0
	hSolid		dq	0
	hPurple		dq	0
	scrX		dq	0
	scrY		dq	0
	bitmap	BITMAP	<>
	mbp_ruk	MSGBOXPARAMS	<>
	mbp_me	MSGBOXPARAMS	<>

.code

	entry_point proc
		invoke GetModuleHandle, 0	;�������� handle
		mov hInstance, rax			;��������� ���
		invoke DialogBoxParam, hInstance, IDD_DLG1, HWND_DESKTOP, ADDR Dialog1Proc, 0
		invoke ExitProcess, 0		;���������� ���������
	entry_point endp

 ;__________________________________________________________________________________________
	Dialog1Proc proc hWNDdlg1:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
		local rect		: RECT
		local hdc		: HDC
		local ps		: PAINTSTRUCT ;
		local BMP		: BITMAP
		local hBut1		: QWORD
		local hBut2		: QWORD
		.switch uMsg
			.case WM_CLOSE	;�������� ���� handle-��
				invoke DeleteObject, hBig
				invoke DeleteObject, hMe
				invoke DeleteObject, hIcon
				invoke DeleteObject, hBitIcon
				invoke DeleteObject, hBMP3
				invoke DeleteObject, hPing
				invoke EndDialog, hWNDdlg1, 0
			.case WM_COMMAND
				.switch wParam
					.case IDC_BTN1	;������� ����� �� �������
						invoke WinExec, ADDR exename,SW_SHOW	;������ ����������
					.case IDC_BTN2	;������� ������ � ���������
						invoke DialogBoxParam, hInstance, IDD_DLG2, hWNDdlg1, ADDR Dialog2Proc, 0	;������ ���� � ��������
				.endsw
			.case WM_SIZE	;��������� ������ ����
				invoke GetClientRect, hWNDdlg1, ADDR rect
				invoke SetWindowPos, hBit, HWND_BOTTOM,0,0, rect.right, rect.bottom,0
				invoke SendMessage, hBit, STM_SETIMAGE, IMAGE_BITMAP, hBig;	
			.case WM_GETMINMAXINFO	;������� ������������ ������� ����
				mov rax,lParam
				add rax,MINMAXINFO.ptMinTrackSize
				mov [rax+POINT.x],266	;�� �����������
				mov [rax+POINT.y],290	;�� ���������
				xor rax,rax
			.case WM_INITDIALOG
				invoke LoadImage, hInstance, IDI_PING, IMAGE_ICON, 128, 128, LR_DEFAULTCOLOR	;�������� ������ ��������
				mov hPing,rax	;���������
				invoke LoadIcon, hInstance, IDI_STAR	;�������� ������ ������
				mov hStar,rax	;���������
				invoke LoadImage, hInstance, IDI_ME, IMAGE_ICON, 256, 256, LR_DEFAULTCOLOR	;�������� ������ ����
				mov hMe,rax	;���������
				invoke LoadIcon, hInstance, IDI_UKR	;�������� ������ �����
				mov hUkr,rax	;���������
				invoke LoadImage, hInstance, IDI_ICON, IMAGE_ICON, 256, 256, LR_DEFAULTCOLOR	;�������� ������ ���� � �����
				mov hIcon,rax	;���������
				invoke SendMessage, hWNDdlg1,WM_SETICON, ICON_SMALL, rax	;����� ������ ���� �� ����
				invoke SendMessage, hWNDdlg1,WM_SETICON, ICON_BIG, hIcon	;...������ �����
				invoke GetDlgItem, hWNDdlg1, IDC_IMG1	;��������� ����
				mov hBit,rax	;���������
				invoke GetDlgItem, hWNDdlg1, IDC_BTN1	;��������� ������ ������� �����������
				mov hBut1,rax	;���������
				invoke SendMessage, rax, BM_SETIMAGE, IMAGE_ICON, hStar		;����� ������ ������ �� ������ 
				invoke GetDlgItem, hWNDdlg1, IDC_BTN2	;����� ������ �������� �� ������
				mov hBut2,rax	;���������
				invoke SendMessage, rax, BM_SETIMAGE, IMAGE_ICON, hPing;	;���������� ������ �� ������
				invoke LoadImage, hInstance, ADDR BigImage, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE	;��� �������� ����
				mov hBig,rax	;���������
				;��������� ���� � ��� ������� (��������������, � ����)
				invoke GetObject,rax,type BITMAP, ADDR BMP
				add BMP.bmWidth,16
				add BMP.bmHeight,38
				invoke SetWindowPos, hWNDdlg1, HWND_BOTTOM, 20,10, BMP.bmWidth,BMP.bmHeight, SWP_NOZORDER
			.default
				xor rax,rax
		.endsw
		ret
	Dialog1Proc endp

	Dialog2Proc proc hWNDdlg2:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
		.switch uMsg
			.case WM_CLOSE	;��������
				invoke EndDialog, hWNDdlg2, 0
			.case WM_COMMAND
				.switch wParam
					.case IDC_EXEC
						invoke MessageBoxIndirect, ADDR mbp_me	;����� ���� � �����������  ��� ���
					.case IDC_LEAD
						invoke MessageBoxIndirect, ADDR mbp_ruk	;����� ���� � �����������  � ������������ ��������� �������
					.case IDC_BACK 
						invoke SendMessage, hWNDdlg2,WM_CLOSE, 0	;�����
					.case IDC_NEXT
						invoke DialogBoxParam, hInstance, IDD_DLG3 , hWNDdlg2, ADDR Dialog3Proc, 0
						cmp rax,4	;��� ��������
						jne _ret	;���� ������ "����������", �� ����� 4, ��������� ������� ���� � ��������� ���������
						invoke DialogBoxParam, hInstance, IDD_DLG4 , hWNDdlg2, ADDR Dialog4Proc, 0
						cmp rax,5
						jne _ret
						invoke DialogBoxParam, hInstance, IDD_DLG5 , hWNDdlg2, ADDR Dialog5Proc, 0								
						cmp rax,6
						jne _ret
						invoke DialogBoxParam, hInstance, IDD_DLG6 ,0, ADDR Dialog6Proc, 0								
				.endsw
			.case  WM_INITDIALOG
				invoke SendMessage, hWNDdlg2,WM_SETICON, ICON_SMALL, hUkr	;����� ������ ���� �� ����
				invoke SendMessage, hWNDdlg2,WM_SETICON, ICON_BIG, hUkr		;...�� ������ �����
				invoke LoadBitmap, hInstance, IDB_TRI	;�������� ��������
				mov hBMP3, rax	;���������
				;����� ��������
				invoke GetDlgItem, hWNDdlg2, IDC_IMG2
				invoke SendMessage, rax, STM_SETIMAGE, IMAGE_BITMAP, hBMP3
				;����� ����
				invoke GetDlgItem, hWNDdlg2, IDC_IMG4
				invoke SendMessage, rax, STM_SETIMAGE, IMAGE_ICON, hMe
				mov rax,hInstance
				mov mbp_me.hInstance,rax				;������ handle � ���������
				mov mbp_ruk.hInstance,rax				;������ handle � ���������
				mov rax,hWNDdlg2
				mov mbp_me.hwndOwner,rax				;������ handle � ���������
				mov mbp_ruk.hwndOwner,rax				;������ handle � ���������
				mov mbp_ruk.cbSize, SIZEOF MSGBOXPARAMS	;�������� ������ ���������
				mov mbp_ruk.dwStyle, MB_USERICON		;���������� ����� ����������� ����
				mov mbp_ruk.lpszIcon, IDI_RUK			;���������� ������
				mov mbp_ruk.dwContextHelpId, 0			;������ � ���������
				mov mbp_ruk.lpfnMsgBoxCallback,0		;������ � ���������
				mov mbp_ruk.dwLanguageId, LANG_NEUTRAL	;���� �� ���������
				lea rax, ruk_text						;��������� ��������� �� ����� ���������
				mov mbp_ruk.lpszText,rax				;�������� � ���������
				lea rax, ruk_title						;��������� ��������� �� ����� ���������
				mov mbp_ruk.lpszCaption,rax				;�������� � ���������
				mov mbp_me.cbSize, SIZEOF MSGBOXPARAMS	;�������� ������ ���������
				mov mbp_me.dwStyle, MB_USERICON			;���������� ����� ����������� ����
				mov mbp_me.lpszIcon, IDI_ME				;���������� ������
				mov mbp_me.dwContextHelpId, 0			;������ � ���������
				mov mbp_me.lpfnMsgBoxCallback,0			;������ � ���������
				mov mbp_me.dwLanguageId, LANG_NEUTRAL	;���� �� ���������
				lea rax, author_text					;��������� ��������� �� ����� ���������
				mov mbp_me.lpszText,rax					;�������� � ���������
				lea rax, author_title					;��������� ��������� �� ����� ���������
				mov mbp_me.lpszCaption,rax				;�������� � ���������
			.default
				xor rax,rax
		.endsw
	  _ret:	
		ret
	Dialog2Proc endp

	Dialog3Proc proc hWNDdlg3:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
		local rect		: RECT
		local wrect		: RECT
		local hdc		: HDC
		local ps		: PAINTSTRUCT ;
		local centerX	: QWORD
		local centerY	: QWORD
		local raylen	: QWORD
		local X1		: QWORD
		local Y1		: QWORD
		local X2		: QWORD
		local Y2		: QWORD
		local N			: QWORD	
		.switch uMsg
			.case WM_INITDIALOG
				invoke SendMessage, hWNDdlg3,WM_SETICON, ICON_SMALL, hStar	;����� ������ ���� �� ����
				invoke SendMessage, hWNDdlg3,WM_SETICON, ICON_BIG, hIcon	;...�� ������ �����
				;������� handle-� �������� � ������ � ���������� ��
				invoke GetDlgItem, hWNDdlg3,IDC_NXT
				mov hBnxt,rax
				invoke SetFocus,rax
				invoke GetDlgItem, hWNDdlg3,IDC_BCK
				mov hBbck,rax
				invoke GetDlgItem, hWNDdlg3,IDC_IMG3
				mov hBitIcon,rax
				invoke GetDlgItem, hWNDdlg3,IDC_IMG3
				mov hBitIcon,rax
				invoke GetDlgItem, hWNDdlg3,IDC_TXT1
				mov hText,rax
				invoke CreateSolidBrush, BlackBoardColor	;������� ����� ����� �����
				mov hSolid,rax
			.case WM_CLOSE	;�������� header-��
				invoke DeleteObject, hSolid
				invoke EndDialog, hWNDdlg3, 0
			.case WM_COMMAND
				.switch wParam
					.case IDC_NXT	;� ����. ����
						invoke DeleteObject, hSolid
						invoke EndDialog, hWNDdlg3, 4
					.case IDC_BCK 	;� �����������
						invoke SendMessage, hWNDdlg3,WM_CLOSE, 0
					.case BN_CLICKED shl 16 + IDCANCEL	;ESC
						invoke SendMessage, hWNDdlg3,WM_CLOSE, 0
				.endsw
			.case WM_PAINT
				invoke BeginPaint, hWNDdlg3, ADDR ps
				mov hdc,rax
				invoke GetClientRect, hWNDdlg3, ADDR rect	;�������� ������� ������� ����
				invoke FillRect, hdc, ADDR rect, hSolid		;���������
				mov eax,rect.right
				shr rax,1	;�������� �� 2
				mov centerX,rax	;���������� ������ X
				mov eax,rect.bottom
				shr rax,1
				mov centerY,rax	;���������� ������ Y
				mov Y1,rax		;start Y1
				mov Y2,rax		;start Y2
				cmp rax,centerX
				jbe @f	;���� ������ ��� ����� - �������
				mov rax,centerX
			  @@:
				mov rcx,StepStar	;��� ����� ��� �������������� ������
				xor rdx,rdx	;��������� �������� rdx ����� ��������
				div rcx	;���������� ������� �����
				test rax,rax	;�������� �� 0
				jz end_draw
				mov N,rax	;���������� �������
				mul rcx		;����������
				mov raylen,rax	;���������� ����� �����
				mov eax,rect.right	;������ ����
				shr rax,1	;����� �� 2
				mov centerX,rax	;��������� �����
				mov rcx,rax		;��� ���������
				add rcx,raylen	;start X2
				mov X2,rcx
				sub rax,raylen	;�������� �����
				mov X1,rax		;start X1
				inc N	;��������� �������
			  draw_4_lines:	;������
				invoke MoveToEx, hdc,centerX,Y1,0
				invoke LineTo, hdc,X1,centerY
				invoke LineTo, hdc,centerX,Y2
				invoke LineTo, hdc,X2,centerY
				invoke LineTo, hdc,centerX,Y1
				;�������� �� ������� �����������
				sub Y1,StepStar
				add Y2,StepStar
				add X1,StepStar
				sub X2,StepStar
				dec N	;������, ���� �� 0
				jnz draw_4_lines
			  end_draw:	;����������� �������� � ����� � ������ ������� ����
				invoke SetBkColor, hdc, BlackBoardColor
				mov eax,rect.right
				sub eax,180
				mov X1,rax
				invoke TextOut, hdc, rax, 0, ADDR inf_txt1, inf_len1
				invoke TextOut, hdc, X1, 16, ADDR inf_txt2, inf_len2
				invoke EndPaint, hWNDdlg3, ADDR ps
			.case WM_GETMINMAXINFO		;�������� �������� ����
				mov rax,lParam
				add rax,MINMAXINFO.ptMinTrackSize
				mov [rax+POINT.x],646	;�� �����������
				mov [rax+POINT.y],736	;�� ���������
				xor rax,rax
			.case WM_SIZE	;��������� ������ ����
				invoke GetClientRect, hWNDdlg3, ADDR wrect
				invoke GetClientRect, hBbck, ADDR rect
				mov eax,wrect.bottom
				sub rax,8
				sub eax,rect.bottom
				mov Y1,rax
				invoke MoveWindow, hBbck, 8 , Y1, rect.right, rect.bottom ,FALSE	;����������� ����� ������
				mov eax,wrect.right
				sub rax,8
				sub eax,rect.right
				mov X1,rax
				invoke MoveWindow, hBnxt, X1, Y1, rect.right,rect.bottom ,FALSE	;����������� ������ ������
				invoke SendMessage, hBitIcon, STM_SETIMAGE, IMAGE_ICON, hIcon	;������������ ����
				invoke InvalidateRect, hWNDdlg3,0,FALSE	;��������� � �������������� ������� �������
			.default
			    _default:
				xor rax,rax
		.endsw
		ret	
	Dialog3Proc endp

	Dialog4Proc proc hWNDdlg4:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
		local hdc		: HDC
		local ps		: PAINTSTRUCT ;
		local rect		: RECT
		local regMain	: QWORD
		local reg0		: QWORD
		local N			: QWORD
		local wrect		: RECT
		local MaskRgn	: DWORD
		.switch uMsg
			.case WM_CLOSE
				invoke DeleteObject, hPurple		;������� �����
				invoke EndDialog, hWNDdlg4,	0		;������� ������
			.case WM_COMMAND
				.switch wParam
					.case BN_CLICKED shl 16 + IDCANCEL				;������ ESC
						invoke SendMessage, hWNDdlg4,WM_CLOSE, 0	;�������� � ��������
					.case IDC_AIM
						invoke DeleteObject, hPurple	;������� �����
						invoke EndDialog, hWNDdlg4, 5	;������� ������ ��� �������� � ���� ����
				.endsw	
			.case WM_LBUTTONDOWN						;������ �����
				invoke ReleaseCapture
				invoke SendMessage, hWNDdlg4, WM_SYSCOMMAND, SC_MOVE+MOUSE_EVENT, 0
			.case WM_PAINT
				invoke BeginPaint, hWNDdlg4, ADDR ps		;������ ��������	
				mov hdc,rax									;��������� handle ���������
				invoke GetClientRect, hWNDdlg4, ADDR rect	;������������� ������� �������
				invoke FillRect, hdc, ADDR rect, hPurple	;������ ������� ����� ������
				invoke EndPaint,hWNDdlg4					;��������� ��������
			.case  WM_INITDIALOG
				invoke CreateSolidBrush, 0F800CCh			;������� �������� �����
				mov hPurple,rax								;��������� handle
				invoke  GetSystemMetrics,SM_CYSCREEN		;�������� ������� ������ �� ���������
				shr rax,1									;��������� �� 2
				mov scrY,rax								;���������
				sub rax,40									;���� ���������
				mov N,rax									;�������� ������ 
				invoke  GetSystemMetrics,SM_CXSCREEN		;�������� ������� ������ �� �����������
				shr rax,1									;��������� �� 2
				mov scrX,rax								;���������
				sub rax,N									;�� ������ �����
				mov wrect.left,eax							;��������
				mov wrect.top,40							;���� ���������
				mov rax,scrY								;�� ������
				add rax,N									;�� ������ ���� 
				mov wrect.bottom,eax						;��������
				mov rax,scrX								;�� ������		
				add rax,N									;������
				mov wrect.right,eax							;��������
				invoke SetWindowPos,hWNDdlg4,HWND_TOP, \	;���������� ������� ���� �� ������ � ���������� ����������
						wrect.left, wrect.top, wrect.right, wrect.bottom,0
				mov eax,wrect.left							;�������� ����� ����������
				sub wrect.right,eax							;������� �� ������ - ������
				mov eax,wrect.top							;�������� ������� ����������
				sub wrect.bottom,eax						;������� �� ������ - ������
				mov wrect.left,0							;���������� ����� ���������� � 0
				mov wrect.top,0								;���������� �������� ���������� � 0
				invoke CreateEllipticRgn,wrect.left,wrect.top,wrect.right, wrect.bottom	;������� ������� ������ � ��������� �������������� 
				mov regMain,rax								;��������� handle
				mov rax, N									;��������� ������ �������
				mov rcx,StepBagel							;��������� ��� �������
				xor rdx,rdx									;�������� ����� ��������
				div rcx										;���������� ������
				sub rax,2									;������� ���������, ��� ����������� ����
				mov N,rax									;��������� ��� ����������
				mov MaskRgn,RGN_AND							;������� ����� �������������� ��������
			  new_round:
				add wrect.left,StepBagel					;�������� ����� ����
				sub wrect.right,StepBagel					;�������� ������ ����
				add wrect.top,StepBagel						;�������� ������� ����
				sub wrect.bottom,StepBagel					;�������� ������ ����
				invoke CreateEllipticRgn,wrect.left,wrect.top,wrect.right, wrect.bottom	;������� ������� ������ ������ �����������
				mov reg0,rax								;��������� handle
				invoke CombineRgn, regMain, regMain, reg0, MaskRgn	;������������� � ���� �������� (��������/��������)
				invoke DeleteObject, reg0					;���������� ������
				shr MaskRgn,1								;���� �����
				cmp MaskRgn,1								;��� �� ��
				ja @f										;��� ���, �������
				mov MaskRgn, RGN_DIFF						;���������� ���������
			  @@:
				dec N										;��������� ������� ������
				jnz new_round								;������� � ������ �����
				invoke SetWindowRgn, hWNDdlg4, regMain, FALSE	;���������� ���������� ������ ��� ����
			.default
				xor rax,rax									;��������� ��������� �� ����������
		.endsw
		ret
	Dialog4Proc endp

	Dialog5Proc proc hWNDdlg6:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
		local hdc		: HDC
		local hMemDC	: HDC
		local ps		: PAINTSTRUCT ;
		local rect		: RECT
		local hRMain	: QWORD
		local reg0		: QWORD
		local Y			: QWORD
		local linesize	: QWORD
		.switch uMsg
			.case WM_CLOSE
				invoke DeleteObject,hBank		;���������� ������ �� BMP-�����
				invoke EndDialog, hWNDdlg6, 0	;������� ������
			.case WM_COMMAND
				.switch wParam
					.case BN_CLICKED shl 16 + IDCANCEL			;������ ESC
						invoke SendMessage, hWNDdlg6,WM_CLOSE, 0	;�������� � ��������
					.case IDC_BANK
						invoke DeleteObject,hBank		;���������� ������ �� BMP-�����
						invoke EndDialog, hWNDdlg6, 6	;������� ������
				.endsw
			.case WM_LBUTTONDOWN					;������ �����
				invoke ReleaseCapture					
				invoke SendMessage, hWNDdlg6, WM_SYSCOMMAND, SC_MOVE+MOUSE_EVENT, 0
			.case WM_PAINT
				invoke BeginPaint,hWNDdlg6, addr ps ;������ ��������	
				mov hdc,rax 						;��������� handle ���������
				invoke CreateCompatibleDC,hdc; 		;������� �������� ���������� � ������
				mov hMemDC,rax						;��������� handle ���������
				invoke SelectObject,hMemDC,hBank	;������� �����������
				invoke BitBlt,hdc,0,0,bitmap.bmWidth,bitmap.bmHeight,hMemDC,0,0,SRCCOPY	;����������� ����������� � ������ ���������
				invoke DeleteDC,hMemDC				;���������� �������� ���������� � ������
				invoke EndPaint,hWNDdlg6,addr ps 	;��������� ��������
			.case  WM_INITDIALOG
				invoke GetDlgItem, hInstance, IDC_BANK	;�������� handle ������
				mov hBbank,rax							;��������� ���
				invoke LoadBitmap,hInstance,IDB_BANK	;��������� Bitmap �����������
				mov hBank,rax							;��������� ��� 
				invoke GetObject,hBank,type BITMAP, ADDR bitmap	;�������� ���������� �� �����������
				invoke SetWindowPos, hWNDdlg6, HWND_TOP,500,100,\	;���������� ���� �������
						 bitmap.bmWidth,bitmap.bmHeight, SWP_NOZORDER;
				invoke GetClientRect, hWNDdlg6, ADDR rect	;�������� ������������� ������� �������
				invoke  CreateRectRgn,0,0,rect.right,rect.bottom	; C������ ������� ������ ��� ����
				mov hRMain,rax
				invoke FindResource, hInstance, IDB_BANK, RT_BITMAP	; ����� � �������� �������� � ������
				invoke  LoadResource, hInstance, rax				; ��������� �������� � ������
				invoke  LockResource,rax							; �������� ��������� �� ������ � ���������
				mov r10,rax											; ��������� ���������
				push rdi											; ��������� �������
				push rsi											; ��������� �������
				push rbx											; ��������� �������
				; �������� ��� ����������� ������ �������� �� ��������� �������
				mov eax,[rax]
				add rax,r10
				mov rsi,rax
				cmp WORD ptr [r10+14],24			;������ 24-������ ��������
				jne finish_mask						;����� �����
				; ���������� ��������� ����������
				mov eax,bitmap.bmWidth				;������ �������
				mov edx,3							;3 ����� �� �������
				mul edx								;������� ���� �������� 1 �����
				test rax,11b						;�������� ������������ �� 4
				jz @f								;��� ��
				and rax,0FFFFFFFFFFFFFFFCh			;���� ���������
				add rax,4
			  @@:
				mov linesize,rax					;������ ������, ���������� 1 ������
				mov edx,bitmap.bmHeight				;������ ��������
				dec edx								;������ ������ �����
				mul rdx								;�� ������� ���������
				add rsi,rax 						;RSI ������ ����� ������ �����
				mov Y,0								;����� �����
			  loop_y:
				xor rbx,rbx							;RBX - ���������� �
				mov rdi,0							;RDI-�������� ������������ ������ �����
				mov r10,0							;���������� � - ������ ����������� �������
				mov r11,0							;������� ����������� �������
			  loop_x:
				mov eax, DWORD ptr [rsi+rdi]		;��� ����� ������� � ������� � [31:24]
				and rax,0FFFFFFh					;������ ��� ����� �������
				cmp eax,COLOR_BANK5					;��������� � ���������� ������
				jnz   chk_pixel						;���, �������
				; ����� ����������
				cmp r11,1							;������ ������� ������������
				je next_pixel						;��, � ���� �������
				mov r10,rbx							;�������� ������ ������� ������������
				mov r11,1							;���������� ������� ����������� �������
				jmp next_pixel						; � ���� �������
			  chk_pixel:
				cmp r11,1							; ���� ����� ������������ � ���� �� ����������
				jne     next_pixel					;�� � ���� �������
				mov     rax,Y						
				inc     rax							
				; �������� ���������� ���� �� �������� �������
				invoke CreateRectRgn,r10,rax,rbx,Y	;������� ������ �������� ����� ������������
				push rax							;��������� handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;�������� ������ �� ��������� 
				invoke DeleteObject					; ���������� ������ �������
				mov r11,0							; �������� ���� 
			  next_pixel:
				add	rdi,3							;���������� �� 3 ����� (1 �������)
				inc rbx								;�������� ���������� �
				cmp ebx,bitmap.bmWidth				;����� �� �������
				jb loop_x							;���, ���� �������
				cmp r11,1							;������ � ���������� �������
				jne @f								;���, ���� ������
				mov rax,Y							;����� ������������ - �������� ������
				inc rax
				; �������� ���������� ���� �� �������� �������
				invoke CreateRectRgn,r10,rax,rbx,Y	;������� ������ �������� ����� ������������
				push rax							;��������� handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;�������� ������ �� ��������� 
				invoke DeleteObject					; ���������� ������ �������
			  @@:
				sub rsi,linesize					;���������� �� ���� �����
				inc Y								;�������� ���������� Y
				mov rax,Y
				cmp eax,bitmap.bmHeight				;����������� �����
				jb loop_y							;���, ������� � ���������
				invoke  SetWindowRgn,hWNDdlg6,hRMain,TRUE	; ���������� ������ ��� ���� � ��� ������������
			  finish_mask:
				invoke  DeleteObject,hRMain			; ���������� ������ �������
				pop rbx								;������������ �������
				pop rsi								;������������ �������
				pop rdi								;������������ �������
			.default
				xor rax,rax							;��������� ��������� �� ����������
		.endsw
		ret
	Dialog5Proc endp

	Dialog6Proc proc hWNDdlg6:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
		local hdc		: HDC
		local hMemDC	: HDC
		local ps		: PAINTSTRUCT ;
		local rect		: RECT
		local hRMain	: QWORD
		local reg0		: QWORD
		local Y 		: QWORD
		local linesize	: QWORD
		.switch uMsg
			.case WM_CLOSE
				invoke DeleteObject,hBank		;���������� ������ �� BMP-�����
				invoke EndDialog, hWNDdlg6, 0	;������� ������
			.case WM_COMMAND
				.switch wParam
					.case BN_CLICKED shl 16 + IDCANCEL			;������ ESC
						invoke SendMessage, hWNDdlg6,WM_CLOSE, 0	;�������� � ��������
					.case IDC_BANK
						invoke DeleteObject,hBank		;���������� ������ �� BMP-�����
						invoke EndDialog, hWNDdlg6, 6	;������� ������
				.endsw
			.case WM_LBUTTONDOWN					;������ �����
				invoke ReleaseCapture					
				invoke SendMessage, hWNDdlg6, WM_SYSCOMMAND, SC_MOVE+MOUSE_EVENT, 0
			.case WM_PAINT
				invoke BeginPaint,hWNDdlg6, addr ps 		;������ ��������	
				mov hdc,rax 						;��������� handle ���������
				invoke CreateCompatibleDC,hdc; 			;������� �������� ���������� � ������
				mov hMemDC,rax						;��������� handle ���������
				invoke SelectObject,hMemDC,hMako ; 		;������� �����������
				invoke BitBlt,hdc,0,0,bitmap.bmWidth,bitmap.bmHeight,hMemDC,0,0,SRCCOPY	;����������� ����������� � ������ ���������
				invoke DeleteDC,hMemDC				;���������� �������� ���������� � ������
				invoke EndPaint,hWNDdlg6,addr ps 			;��������� ��������
			.case  WM_INITDIALOG
				invoke LoadBitmap,hInstance,IDB_MAKO		;��������� Bitmap �����������
				mov hMako,rax						;��������� ��� 
				invoke GetObject,hMako,type BITMAP, ADDR bitmap	;�������� ���������� �� �����������
				invoke SetWindowPos, hWNDdlg6, HWND_TOP,450,70,\	;���������� ���� �������
						 bitmap.bmWidth,bitmap.bmHeight, SWP_NOZORDER;
				invoke GetClientRect, hWNDdlg6, ADDR rect	;�������� ������������� ������� �������
				invoke  CreateRectRgn,0,0,rect.right,rect.bottom	; C������ ������� ������ ��� ����
				mov hRMain,rax
				invoke FindResource, hInstance, IDB_MAKO, RT_BITMAP	; ����� � �������� �������� � ������
				invoke  LoadResource, hInstance, rax				; ��������� �������� � ������
				invoke  LockResource,rax							; �������� ��������� �� ������ � ���������
				mov r10,rax											; ��������� ���������
				push rdi											; ��������� �������
				push rsi											; ��������� �������
				push rbx											; ��������� �������
				; �������� ��� ����������� ������ �������� �� ��������� �������
				mov eax,[rax]
				add rax,r10
				mov rsi,rax
				cmp WORD ptr [r10+14],24			;������ 24-������ ��������
				jne finish_mask						;����� �����
				; ���������� ��������� ����������
				mov eax,bitmap.bmWidth				;������ �������
				mov edx,3							;3 ����� �� �������
				mul edx								;������� ���� �������� 1 �����
				test rax,11b						;�������� ������������ �� 4
				jz @f								;��� ��
				and rax,0FFFFFFFFFFFFFFFCh			;���� ���������
				add rax,4
			  @@:
				mov linesize,rax					;������ ������, ���������� 1 ������
				mov edx,bitmap.bmHeight				;������ ��������
				dec edx								;������ ������ �����
				mul rdx								;�� ������� ���������
				add rsi,rax 						;RSI ������ ����� ������ �����
				mov Y,0								;����� �����
			  loop_y:
				xor rbx,rbx							;RBX - ���������� �
				mov rdi,0							;RDI-�������� ������������ ������ �����
				mov r10,0							;���������� � - ������ ����������� �������
				mov r11,0							;������� ����������� �������
			  loop_x:
				mov eax, DWORD ptr [rsi+rdi]		;��� ����� ������� � ������� � [31:24]
				test rax, MAKO_MASK					;�������� ����� ����� - ������ ������� ������ �������
				jnz chk_pixel						;���, �������
				; ����� ����������
				cmp r11,1							;������ ������� ������������
				je next_pixel						;��, � ���� �������
				mov r10,rbx							;�������� ������ ������� ������������
				mov r11,1							;���������� ������� ����������� �������
				jmp next_pixel						; � ���� �������
			  chk_pixel:
				cmp r11,1							; ���� ����� ������������ � ���� �� ����������
				jne     next_pixel					;�� � ���� �������
				mov     rax,Y						
				inc     rax							
				; �������� ���������� ���� �� �������� �������
				invoke CreateRectRgn,r10,rax,rbx,Y	;������� ������ �������� ����� ������������
				push rax							;��������� handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;�������� ������ �� ��������� 
				invoke DeleteObject					; ���������� ������ �������
				mov r11,0							; �������� ���� 
			  next_pixel:
				add	rdi,3							;���������� �� 3 ����� (1 �������)
				inc rbx								;�������� ���������� �
				cmp ebx,bitmap.bmWidth				;����� �� �������
				jb loop_x							;���, ���� �������
				cmp r11,1							;������ � ���������� �������
				jne @f								;���, ���� ������
				mov rax,Y							;����� ������������ - �������� ������
				inc rax
				; �������� ���������� ���� �� �������� �������
				invoke CreateRectRgn,r10,rax,rbx,Y	;������� ������ �������� ����� ������������
				push rax							;��������� handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;�������� ������ �� ��������� 
				invoke DeleteObject					; ���������� ������ �������
			  @@:
				sub rsi,linesize					;���������� �� ���� �����
				inc Y								;�������� ���������� Y
				mov rax,Y
				cmp eax,bitmap.bmHeight				;����������� �����
				jb loop_y							;���, ������� � ���������
				invoke  SetWindowRgn,hWNDdlg6,hRMain,TRUE	; ���������� ������ ��� ���� � ��� ������������
			  finish_mask:
				invoke  DeleteObject,hRMain			; ���������� ������ �������
				pop rbx								;������������ �������
				pop rsi								;������������ �������
				pop rdi								;������������ �������
			.default
				xor rax,rax							;��������� ��������� �� ����������
		.endsw
		ret
	Dialog6Proc endp

END

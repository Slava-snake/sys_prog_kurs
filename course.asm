include c:\masm64\include64\masm64rt.inc

  IDD_DLG0		equ 1000
  IDD_DLG1		equ 1001
  IDD_DLG2		equ 1002
  IDD_DLG3		equ 1003
  IDD_DLG4		equ 1004

  IDC_IMG0		equ 100
  IDC_IMG1		equ 101
  IDC_IMG2		equ 102
  IDC_IMG3		equ 103

  IDB_0			equ 1300
  IDB_1			equ 1301
  IDB_2			equ 1302
  IDB_3			equ 1303
  IDB_4			equ 1304

  IDC_EXE		equ 1200
  IDC_EXEC		equ 1201
  IDC_LEAD		equ 1202
  IDC_BTN1x		equ 1210
  IDC_BTN1o		equ 1211
  IDC_BTN1s		equ 1212
  IDC_BTN2x		equ 1220
  IDC_BTN2o		equ 1221

  IDC_TXT0		equ 1030
  IDC_TXT1		equ 1031
  IDC_TXT2		equ 1032

  IDI_ICON0		equ 1100
  IDI_ICON1		equ 1101
  IDI_ICON2		equ 1102
  IDI_ICON3		equ 1103
  IDI_ICON4		equ 3333

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
	exename		db	'Cardioida.exe',0
	inf_txt1	db	'��������� �.�. ���-120�',0
	inf_txt2	db	'������� ���    ��� ���',0
	ruk_title	db	'���������� � ������������',0
	ruk_text	db	'��������� ��������� ����������.',10,
					'��������� "��������� ����������������"',10,
					'��������� ������� ���ϔ',10,
					'��� ���. ������� ���.',0
	auth_title	db	'���������� �� �����������',0
	auth_text	db	'��������� ���� ���������.',10,
					'������ ���-120�',10,
					'������� ���',10,
			'��������� "������������ � �������������� ����������"',10,
					'��� ���',0

.data
	hInstance	dq	0
	hPhoto0		dq	0
	hIcon0		dq	0
	hPhoto1		dq	0
	hIcon1		dq	0
	hPhoto2		dq	0
	hIcon2		dq	0
	hUA			dq	0
	hBomb		dq	0
	lin			dq	0
	bitmap	BITMAP	<>
	mbp_lead	MSGBOXPARAMS	<>
	mbp_exec	MSGBOXPARAMS	<>

.code

entry_point proc
	invoke GetModuleHandle, 0	;�������� handle
	mov hInstance, rax			;��������� ���
	invoke DialogBoxParam, hInstance,IDD_DLG0,\
		HWND_DESKTOP, ADDR Dialog0Proc,0	;������� 1 ������ ����
	invoke ExitProcess, 0		;���������� ���������
entry_point endp


Dialog0Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	.switch uMsg
		.case WM_CLOSE	;�������� ���� handle-��
			invoke DeleteObject, hPhoto0	;������� BMP-����
			invoke EndDialog, hWNDdlg, 0	;������ ������
		.case WM_COMMAND
			.switch wParam
				.case IDC_EXE	;������� ����� EXE(������������ �������)
					invoke WinExec,ADDR exename,SW_SHOW;������ ����������
				.case IDC_EXEC	;������� ������ �����������
					invoke DialogBoxParam, hInstance, IDD_DLG1, 0, \
						ADDR Dialog1Proc, 0	;������ ���� 2
				.case IDC_LEAD	;������� ������ ������������
					invoke DialogBoxParam, hInstance, IDD_DLG2, 0,\
						ADDR Dialog2Proc, 0	;������ ���� 3
			.endsw
		.case WM_INITDIALOG
			invoke LoadImage, hInstance, IDB_0, IMAGE_BITMAP,\
					0, 0, LR_DEFAULTSIZE	;���� ����
			mov hPhoto0,rax					;���������
			invoke LoadIcon,hInstance,IDI_ICON0;�������� ������ ����
			mov hIcon0,rax					;���������
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_SMALL, rax	;����� ������ ���� �� ����
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_BIG, hIcon0	;...������ �����
			invoke GetDlgItem, hWNDdlg, IDC_IMG0	;handle �������
			invoke SendMessage, rax, STM_SETIMAGE,\
					IMAGE_BITMAP, hPhoto0	;��������� ����
		.default
			xor rax,rax	;��������� ��������� �� ����������
	.endsw
	ret
Dialog0Proc endp

Dialog1Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	.switch uMsg
		.case WM_CLOSE	;�������� ���� handle-��
			invoke DeleteObject, hPhoto1	;������� BMP-����
			invoke EndDialog, hWNDdlg, 0	;������ ������
		.case WM_COMMAND
			.switch wParam
				.case IDC_BTN1x	;������� ����� �������
					invoke SendMessage,hWNDdlg,WM_CLOSE,0;������� ����
				.case IDC_BTN1o	;������� ������ �������
					invoke MessageBoxIndirect, ADDR mbp_exec;����� �������
				.case IDC_BTN1s	;������� ������ ����?
					invoke DialogBoxParam, hInstance, IDD_DLG3,0,\
							ADDR Dialog3Proc, 0	;������ ���� 4
			.endsw
		.case WM_INITDIALOG
			invoke LoadImage,hInstance,IDB_1,IMAGE_BITMAP,0,0,\
						LR_DEFAULTSIZE	;���� ����
			mov hPhoto1,rax				;���������
			invoke LoadIcon,hInstance,IDI_ICON1	;�������� ������ ����
			mov hIcon1,rax				;���������
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_SMALL, rax		;����� ������ ���� �� ����
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_BIG, hIcon1	;...������ �����
			invoke GetDlgItem, hWNDdlg, IDC_IMG1;handle �������
			invoke SendMessage, rax, STM_SETIMAGE, IMAGE_BITMAP,\
						hPhoto1				;��������� ����
			mov rax,hInstance				;handle ���������
			mov mbp_exec.hInstance,rax		;������ handle � ���������
			mov rax,hWNDdlg					;handle ����
			mov mbp_exec.hwndOwner,rax		;������ handle � ���������
			mov mbp_exec.cbSize,SIZEOF MSGBOXPARAMS;�������� ������ ���������
			mov mbp_exec.dwStyle, MB_USERICON;���������� ����� ����������� ����
			mov mbp_exec.lpszIcon, IDI_ICON1;���������� ������
			mov mbp_exec.dwContextHelpId, 0	;������ � ���������
			mov mbp_exec.lpfnMsgBoxCallback,0;������ � ���������
			mov mbp_exec.dwLanguageId, LANG_NEUTRAL	;���� �� ���������
			lea rax, auth_text			;��������� ��������� �� ����� ���������
			mov mbp_exec.lpszText,rax		;�������� � ���������
			lea rax, auth_title			;��������� ��������� �� ����� ���������
			mov mbp_exec.lpszCaption,rax	;�������� � ���������
		.default
			xor rax,rax
	.endsw
	ret
Dialog1Proc endp

Dialog2Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	.switch uMsg
		.case WM_CLOSE	;�������� ���� handle-��
			invoke DeleteObject, hPhoto2	;������� BMP-����
			invoke EndDialog, hWNDdlg, 0	;������ ������
		.case WM_COMMAND
			.switch wParam
				.case IDC_BTN2x	;������� ����� �������
					invoke SendMessage,hWNDdlg,WM_CLOSE,0;������� ����
				.case IDC_BTN2o	;������� ������ �������
					invoke MessageBoxIndirect, ADDR mbp_lead;����� ������
			.endsw
		.case WM_INITDIALOG
			invoke LoadImage,hInstance,IDB_2,IMAGE_BITMAP,0,0,\
						LR_DEFAULTSIZE	;���� ����
			mov hPhoto2,rax				;���������
			invoke LoadIcon,hInstance,IDI_ICON2	;�������� ������ ����
			mov hIcon2,rax						;���������
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_SMALL, rax	;����� ������ ���� �� ����
			invoke SendMessage, hWNDdlg,WM_SETICON, \
					ICON_BIG, hIcon2	;...������ �����
			invoke GetDlgItem, hWNDdlg, IDC_IMG2	;handle �������
			invoke SendMessage, rax, STM_SETIMAGE, IMAGE_BITMAP,\
					hPhoto2				;��������� ����
			mov rax,hInstance				;handle ���������
			mov mbp_lead.hInstance,rax		;������ handle � ���������
			mov rax,hWNDdlg					;handle ����
			mov mbp_lead.hwndOwner,rax				;������ handle � ���������
			mov mbp_lead.cbSize,SIZEOF MSGBOXPARAMS	;�������� ������ ���������
			mov mbp_lead.dwStyle, MB_USERICON		;���������� ����� ������ ����
			mov mbp_lead.lpszIcon, IDI_ICON2		;���������� ������
			mov mbp_lead.dwContextHelpId, 0			;������ � ���������
			mov mbp_lead.lpfnMsgBoxCallback,0		;������ � ���������
			mov mbp_lead.dwLanguageId, LANG_NEUTRAL	;���� �� ���������
			lea rax, ruk_text						;��������� �� ����� ���������
			mov mbp_lead.lpszText,rax				;�������� � ���������
			lea rax, ruk_title						;��������� �� ����� ���������
			mov mbp_lead.lpszCaption,rax			;�������� � ���������
		.default
			xor rax,rax		;��������� ��������� �� ����������
	.endsw
	ret
Dialog2Proc endp

Dialog3Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	local rect		: RECT
	.switch uMsg
		.case WM_CLOSE
			invoke DeleteObject, hUA		;������� BMP-����
			invoke EndDialog, hWNDdlg,0		;������� ������
		.case WM_COMMAND
			.switch wParam
				.case BN_CLICKED shl 16 + IDCANCEL			;������ ESC
					invoke SendMessage,hWNDdlg,WM_CLOSE,0	;�������� ����
			.endsw	
		.case WM_LBUTTONDOWN				;������ �����
				invoke ReleaseCapture		
				invoke SendMessage,hWNDdlg,WM_SYSCOMMAND,SC_MOVE+MOUSE_EVENT,0
		.case WM_RBUTTONDOWN	;���� ������ ������ ����
			mov rax,lParam		;����������� ���������� �����
			shr rax,16			;���������� Y
			cmp rax,lin			;�������� ������������ ���������� �� ���� ������
			ja @f
			invoke SendMessage, hWNDdlg,WM_CLOSE, 0	;�������� � ��������
			jmp end_msg
		 @@:invoke DialogBoxParam,hInstance,IDD_DLG4,0,\
					ADDR Dialog4Proc,0	;������ ���� 5
		.case  WM_INITDIALOG
			invoke LoadImage,hInstance,IDB_3,IMAGE_BITMAP,0,0,\
					LR_DEFAULTSIZE	;���� ����
			mov hUA,rax				;���������
			invoke GetDlgItem,hWNDdlg,IDC_IMG3	;handle �������
			invoke SendMessage, rax, STM_SETIMAGE,\
					IMAGE_BITMAP, hUA	;���������� ��������
			invoke LoadIcon,hInstance,IDI_ICON3	;�������� ������ ���������������
			invoke SendMessage,hWNDdlg,WM_SETICON,\
					ICON_BIG, rax		;���������� ������
			invoke GetClientRect,hWNDdlg,ADDR rect	;������������� ��� �������
			mov eax,rect.bottom			;������
			shr rax,1					;��������� �� 2
			mov lin,rax					;��������� ���������� �����
			;������� ������� ������ � ��������� �������������� 
			invoke CreateEllipticRgn,rect.left,rect.top,rect.right,rect.bottom
			;���������� ���������� ������ ��� ����
			invoke SetWindowRgn, hWNDdlg, rax, TRUE
		.default
			xor rax,rax		;��������� ��������� �� ����������
	.endsw
	end_msg:
	ret
Dialog3Proc endp

Dialog4Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	local hdc		: HDC
	local hMemDC	: HDC
	local ps		: PAINTSTRUCT ;
	local rect		: RECT
	local hRMain	: QWORD
	local reg0		: QWORD
	local Y			: QWORD
	local linesize	: QWORD
	local pallette	: QWORD
	local index		: BYTE
	.switch uMsg
		.case WM_CLOSE
			invoke DeleteObject,hBomb	;���������� ������ �� BMP-�����
			invoke EndDialog, hWNDdlg, 0;������� ������
		.case WM_COMMAND
			.switch wParam
				.case BN_CLICKED shl 16 + IDCANCEL		;������ ESC
					invoke SendMessage,hWNDdlg,WM_CLOSE,0;�������� � ��������
			.endsw
		.case WM_LBUTTONDOWN					;������ �����
			invoke ReleaseCapture					
			invoke SendMessage,hWNDdlg,WM_SYSCOMMAND,SC_MOVE+MOUSE_EVENT,0
		.case WM_PAINT
			invoke BeginPaint,hWNDdlg, addr ps	;������ ��������
			mov hdc,rax 						;��������� handle ���������
			invoke CreateCompatibleDC,hdc;	;������� �������� ���������� � ������
			mov hMemDC,rax					;��������� handle ���������
			invoke SelectObject,hMemDC,hBomb;������� �����������
			invoke BitBlt,hdc,0,0,bitmap.bmWidth,bitmap.bmHeight,\
					hMemDC,0,0,SRCCOPY	;����������� ����������� � ������ ���������
			invoke DeleteDC,hMemDC		;���������� �������� ���������� � ������
			invoke EndPaint,hWNDdlg,addr ps	;��������� ��������
		.case  WM_INITDIALOG
			invoke LoadIcon,hInstance,IDI_ICON4	;�������� ������ ���������������
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_BIG, rax		;���������� ������
			invoke LoadBitmap,hInstance,IDB_4;��������� Bitmap �����������
			mov hBomb,rax					;��������� ��� 
			invoke GetObject,hBomb,type BITMAP,\
					ADDR bitmap	;�������� ���������� �� �����������
			invoke SetWindowPos, hWNDdlg, HWND_TOP,500,500,\;���������� ���� �������
					 bitmap.bmWidth,bitmap.bmHeight, SWP_NOZORDER;
			;�������� ������������� ������� �������
			invoke GetClientRect, hWNDdlg, ADDR rect
			; C������ ������� ������ ��� ����
			invoke  CreateRectRgn,0,0,rect.right,rect.bottom
			mov hRMain,rax		;�������� handle
			; ����� � �������� �������� � ������
			invoke FindResource,hInstance,IDB_4,RT_BITMAP
			; ��������� �������� � ������
			invoke  LoadResource, hInstance, rax
			; �������� ��������� �� ������ � ���������
			invoke  LockResource,rax; �������� ��������� �� ������ � ���������
			mov r10,rax		; ��������� ���������
			push rdi		; ��������� �������
			push rsi		; ��������� �������
			push rbx		; ��������� �������
			; �������� ��� ����������� ������ �������� �� ��������� �������
			mov eax,[rax]		;������ ���������
			add rax,r10			;��������
			mov pallette,rax	;����� �������
			add rax,1024		;������ �������
			mov rsi,rax			;����� ������ �����������
			; ���������� ��������� ����������
			mov eax,bitmap.bmWidth	;������ �������
			test rax,11b			;�������� ������������ �� 4
			jz @f					;��� ��
			and rax,0FFFFFFFFFFFFFFFCh	;���� ���������
			add rax,4				;�� 4
		 @@:mov linesize,rax		;������ ������, ���������� 1 ������
			mov edx,bitmap.bmHeight	;������ ��������
			dec edx					;������ ������ �����
			mul rdx					;�� ������� ��������
			add rsi,rax 			;RSI ������ ����� ������ ����� 0
			mov Y,0					;����� �����
			mov al, BYTE ptr [rsi]	;������ ����������� ����� (0,0)
			mov index,al			;��������� ������
		  loop_y:
			xor rbx,rbx		;RBX - ���������� �
			mov rdi,0		;RDI-�������� ������������ ������ �����
			mov r10,0		;���������� � - ������ ����������� �������
			mov r11,0		;������� ����������� �������
		  loop_x:
			mov al,BYTE ptr[rsi+rdi];������ ����� ������� 
			cmp al, index	;��������� � ���������� ������
			jnz chk_pixel	;���, �������
			; ����� ����������
			cmp r11,1		;������ ������� ������������
			je next_pixel	;��, � ���� �������
			mov r10,rbx		;�������� ������ ������� ������������
			mov r11,1		;���������� ������� ����������� �������
			jmp next_pixel	; � ���� �������
		  chk_pixel:
			cmp r11,1		; ���� ����� ������������ � ���� �� ����������
			jne next_pixel	;�� � ���� �������
			mov rax,Y		;������ ������� ���������� �������
			inc rax			
		; �������� ���������� ���� �� �������� �������
			;������� ������ �������� ����� ������������
			invoke CreateRectRgn,r10,rax,rbx,Y
			push rax		;��������� handle
			;�������� ������ �� ��������� 
			invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF
			invoke DeleteObject	; ���������� ������ �������
			mov r11,0			; �������� ���� 
		  next_pixel:
			inc	rdi					;���������� �� 1 ���� (1 �������)
			inc rbx					;�������� ���������� �
			cmp ebx,bitmap.bmWidth	;����� �� �������
			jb loop_x				;���, ���� �������
			cmp r11,1				;������ � ���������� �������
			jne @f					;���, ���� ������
			mov rax,Y				;����� ������������ - �������� ������
			inc rax
		; �������� ���������� ���� �� �������� �������
			;������� ������ �������� ����� ������������
			invoke CreateRectRgn,r10,rax,rbx,Y
			push rax		;��������� handle
			;�������� ������ �� ��������� 
			invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF
			invoke DeleteObject	; ���������� ������ �������
		  @@:
			sub rsi,linesize		;���������� �� ���� �����
			inc Y					;�������� ���������� Y
			mov rax,Y				;��������� ����������
			cmp eax,bitmap.bmHeight	;����������� �����
			jb loop_y				;���, ������� � ���������
		; ���������� ������ ��� ���� � ��� ������������
			invoke  SetWindowRgn,hWNDdlg,hRMain,TRUE
		  finish_mask:
			invoke  DeleteObject,hRMain	; ���������� ������ �������
			pop rbx						;������������ �������
			pop rsi						;������������ �������
			pop rdi						;������������ �������
		.default
			xor rax,rax		;��������� ��������� �� ����������
	.endsw
	ret
Dialog4Proc endp

END

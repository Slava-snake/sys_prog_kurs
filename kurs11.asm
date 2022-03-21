;	НТУ ХПИ
;	Кафедра ВТП
;	
;	КУРСОВОЙ ПРОЕКТ
;		
;	СИСТЕМНОЕ ПРОГРАММИРОВАНИЕ
;
;	студента КИТ-120в
;	Лазуренко В.В.
;
;	Преподаватель 
;	профессор Рысованый А.Н.
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
StepStar	EQU 16		;шаг линий для геометрической звезды
StepBagel	EQU 32		;шаг вырезов для бубликов
BlackBoardColor	EQU 0074795Ch	;цвет доски
COLOR_BANK5	EQU 00FFFFFFh	;прозрачный цвет 5 окна
MAKO_MASK	EQU 00F0F0F0h	;маска для BMP картики 6 окна

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
	wWindowTitle	db	'Курсовой проект студента КИТ-120в Лазуренко В.В.',0
	wFontName		db	'Times New Roman', 0
	BigImage		db	'big.bmp',0
	exename			db	'lemniskata.exe',0
	inf_txt1		db	'Лазуренко В.В. КИТ-120в',0
	inf_len1		equ	($-inf_txt1)/type inf_txt1
	inf_txt2		db	'Кафедра ВТП    НТУ ХПИ',0
	inf_len2		equ	($-inf_txt2)/type inf_txt2
	ruk_title		db	'Информация о руководителе',0
	ruk_text		db	'РЫСОВАНЫЙ Александр Николаевич.',10,
						'Родился 22.09.1957.',10,
						'Работает в НТУ “ХПИ” с 2006 г.',10,
						'На должности проф. кафедры “ВТП” с 2013 г.',10,
						'Профессор НТУ ХПИ с 2015 г. Кафедра ВТП',0
	author_title	db	'Информация об исполнителе',0
	author_text		db	'Лазуренко Владислав Вячеславович.',10,
						'Родился 13.08.2003.',10,
						'Учится в НТУ “ХПИ” с 2020 г.',10,
						'На программиста игр.',10,
						'Студент НТУ ХПИ с 2020 г. Кафедра ВТП',0

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
		invoke GetModuleHandle, 0	;получить handle
		mov hInstance, rax			;запомнить его
		invoke DialogBoxParam, hInstance, IDD_DLG1, HWND_DESKTOP, ADDR Dialog1Proc, 0
		invoke ExitProcess, 0		;завершение программы
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
			.case WM_CLOSE	;закрытие всех handle-ов
				invoke DeleteObject, hBig
				invoke DeleteObject, hMe
				invoke DeleteObject, hIcon
				invoke DeleteObject, hBitIcon
				invoke DeleteObject, hBMP3
				invoke DeleteObject, hPing
				invoke EndDialog, hWNDdlg1, 0
			.case WM_COMMAND
				.switch wParam
					.case IDC_BTN1	;нажатие копки со звездой
						invoke WinExec, ADDR exename,SW_SHOW	;запуск приложения
					.case IDC_BTN2	;нажатие кнопки с пингвином
						invoke DialogBoxParam, hInstance, IDD_DLG2, hWNDdlg1, ADDR Dialog2Proc, 0	;запуск окна с кнопками
				.endsw
			.case WM_SIZE	;изменился размер окна
				invoke GetClientRect, hWNDdlg1, ADDR rect
				invoke SetWindowPos, hBit, HWND_BOTTOM,0,0, rect.right, rect.bottom,0
				invoke SendMessage, hBit, STM_SETIMAGE, IMAGE_BITMAP, hBig;	
			.case WM_GETMINMAXINFO	;задание минимального размера окна
				mov rax,lParam
				add rax,MINMAXINFO.ptMinTrackSize
				mov [rax+POINT.x],266	;по горизонтали
				mov [rax+POINT.y],290	;по вертикали
				xor rax,rax
			.case WM_INITDIALOG
				invoke LoadImage, hInstance, IDI_PING, IMAGE_ICON, 128, 128, LR_DEFAULTCOLOR	;загрузка иконки пингвина
				mov hPing,rax	;запомнить
				invoke LoadIcon, hInstance, IDI_STAR	;загрузка иконки звезды
				mov hStar,rax	;запомнить
				invoke LoadImage, hInstance, IDI_ME, IMAGE_ICON, 256, 256, LR_DEFAULTCOLOR	;загрузка иконки меня
				mov hMe,rax	;запомнить
				invoke LoadIcon, hInstance, IDI_UKR	;загрузка иконки герба
				mov hUkr,rax	;запомнить
				invoke LoadImage, hInstance, IDI_ICON, IMAGE_ICON, 256, 256, LR_DEFAULTCOLOR	;загрузка иконки меня в шляпе
				mov hIcon,rax	;запомнить
				invoke SendMessage, hWNDdlg1,WM_SETICON, ICON_SMALL, rax	;вывод иконки окна на окне
				invoke SendMessage, hWNDdlg1,WM_SETICON, ICON_BIG, hIcon	;...панели задач
				invoke GetDlgItem, hWNDdlg1, IDC_IMG1	;установка фона
				mov hBit,rax	;запомнить
				invoke GetDlgItem, hWNDdlg1, IDC_BTN1	;установка кнопки запуска лемнискатты
				mov hBut1,rax	;запомнить
				invoke SendMessage, rax, BM_SETIMAGE, IMAGE_ICON, hStar		;вывод иконки звезды на кнопку 
				invoke GetDlgItem, hWNDdlg1, IDC_BTN2	;вывод иконки пингвина на кнопку
				mov hBut2,rax	;запомнить
				invoke SendMessage, rax, BM_SETIMAGE, IMAGE_ICON, hPing;	;установить иконку на кнопку
				invoke LoadImage, hInstance, ADDR BigImage, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE	;фон главного окна
				mov hBig,rax	;запомнить
				;установка фона и его размера (соответственно, и окна)
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
			.case WM_CLOSE	;закрытие
				invoke EndDialog, hWNDdlg2, 0
			.case WM_COMMAND
				.switch wParam
					.case IDC_EXEC
						invoke MessageBoxIndirect, ADDR mbp_me	;вызов окна с информацией  обо мне
					.case IDC_LEAD
						invoke MessageBoxIndirect, ADDR mbp_ruk	;вызов окна с информацией  о руководителе курсового проекта
					.case IDC_BACK 
						invoke SendMessage, hWNDdlg2,WM_CLOSE, 0	;назад
					.case IDC_NEXT
						invoke DialogBoxParam, hInstance, IDD_DLG3 , hWNDdlg2, ADDR Dialog3Proc, 0
						cmp rax,4	;код возврата
						jne _ret	;если нажали "Интереснее", то вернёт 4, закроется текущее окно и откроется следующее
						invoke DialogBoxParam, hInstance, IDD_DLG4 , hWNDdlg2, ADDR Dialog4Proc, 0
						cmp rax,5
						jne _ret
						invoke DialogBoxParam, hInstance, IDD_DLG5 , hWNDdlg2, ADDR Dialog5Proc, 0								
						cmp rax,6
						jne _ret
						invoke DialogBoxParam, hInstance, IDD_DLG6 ,0, ADDR Dialog6Proc, 0								
				.endsw
			.case  WM_INITDIALOG
				invoke SendMessage, hWNDdlg2,WM_SETICON, ICON_SMALL, hUkr	;вывод иконки окна на окне
				invoke SendMessage, hWNDdlg2,WM_SETICON, ICON_BIG, hUkr		;...на панели задач
				invoke LoadBitmap, hInstance, IDB_TRI	;загрузка тризубца
				mov hBMP3, rax	;запомнить
				;вывод тризубца
				invoke GetDlgItem, hWNDdlg2, IDC_IMG2
				invoke SendMessage, rax, STM_SETIMAGE, IMAGE_BITMAP, hBMP3
				;вывод меня
				invoke GetDlgItem, hWNDdlg2, IDC_IMG4
				invoke SendMessage, rax, STM_SETIMAGE, IMAGE_ICON, hMe
				mov rax,hInstance
				mov mbp_me.hInstance,rax				;запись handle в структуру
				mov mbp_ruk.hInstance,rax				;запись handle в структуру
				mov rax,hWNDdlg2
				mov mbp_me.hwndOwner,rax				;запись handle в структуру
				mov mbp_ruk.hwndOwner,rax				;запись handle в структуру
				mov mbp_ruk.cbSize, SIZEOF MSGBOXPARAMS	;записать размер структуры
				mov mbp_ruk.dwStyle, MB_USERICON		;установить стиль диалогового окна
				mov mbp_ruk.lpszIcon, IDI_RUK			;установить иконку
				mov mbp_ruk.dwContextHelpId, 0			;запись в структуру
				mov mbp_ruk.lpfnMsgBoxCallback,0		;запись в структуру
				mov mbp_ruk.dwLanguageId, LANG_NEUTRAL	;язык по умолчанию
				lea rax, ruk_text						;загрузить указатель на текст сообщения
				mov mbp_ruk.lpszText,rax				;записать в структуру
				lea rax, ruk_title						;загрузить указатель на текст заголовка
				mov mbp_ruk.lpszCaption,rax				;записать в структуру
				mov mbp_me.cbSize, SIZEOF MSGBOXPARAMS	;записать размер структуры
				mov mbp_me.dwStyle, MB_USERICON			;установить стиль диалогового окна
				mov mbp_me.lpszIcon, IDI_ME				;установить иконку
				mov mbp_me.dwContextHelpId, 0			;запись в структуру
				mov mbp_me.lpfnMsgBoxCallback,0			;запись в структуру
				mov mbp_me.dwLanguageId, LANG_NEUTRAL	;язык по умолчанию
				lea rax, author_text					;загрузить указатель на текст сообщения
				mov mbp_me.lpszText,rax					;записать в структуру
				lea rax, author_title					;загрузить указатель на текст заголовка
				mov mbp_me.lpszCaption,rax				;записать в структуру
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
				invoke SendMessage, hWNDdlg3,WM_SETICON, ICON_SMALL, hStar	;вывод иконки окна на окне
				invoke SendMessage, hWNDdlg3,WM_SETICON, ICON_BIG, hIcon	;...на панели задач
				;получем handle-ы картинок и кнопок и запоминаем их
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
				invoke CreateSolidBrush, BlackBoardColor	;создать кисть цвета доски
				mov hSolid,rax
			.case WM_CLOSE	;закрытие header-ов
				invoke DeleteObject, hSolid
				invoke EndDialog, hWNDdlg3, 0
			.case WM_COMMAND
				.switch wParam
					.case IDC_NXT	;к след. окну
						invoke DeleteObject, hSolid
						invoke EndDialog, hWNDdlg3, 4
					.case IDC_BCK 	;к предыдущему
						invoke SendMessage, hWNDdlg3,WM_CLOSE, 0
					.case BN_CLICKED shl 16 + IDCANCEL	;ESC
						invoke SendMessage, hWNDdlg3,WM_CLOSE, 0
				.endsw
			.case WM_PAINT
				invoke BeginPaint, hWNDdlg3, ADDR ps
				mov hdc,rax
				invoke GetClientRect, hWNDdlg3, ADDR rect	;получить рабочую область окна
				invoke FillRect, hdc, ADDR rect, hSolid		;заполнять
				mov eax,rect.right
				shr rax,1	;поделить на 2
				mov centerX,rax	;координаты центра X
				mov eax,rect.bottom
				shr rax,1
				mov centerY,rax	;координаты центра Y
				mov Y1,rax		;start Y1
				mov Y2,rax		;start Y2
				cmp rax,centerX
				jbe @f	;если меньше или равно - прыгать
				mov rax,centerX
			  @@:
				mov rcx,StepStar	;шаг линий для геометрической звезды
				xor rdx,rdx	;обнуление регистра rdx перед делением
				div rcx	;количество узловых точек
				test rax,rax	;проверка на 0
				jz end_draw
				mov N,rax	;установить счётчик
				mul rcx		;количество
				mov raylen,rax	;установить длину линии
				mov eax,rect.right	;правый край
				shr rax,1	;делим на 2
				mov centerX,rax	;запомнили центр
				mov rcx,rax		;для рассчётов
				add rcx,raylen	;start X2
				mov X2,rcx
				sub rax,raylen	;смещение влево
				mov X1,rax		;start X1
				inc N	;увеличить счетчик
			  draw_4_lines:	;рисуем
				invoke MoveToEx, hdc,centerX,Y1,0
				invoke LineTo, hdc,X1,centerY
				invoke LineTo, hdc,centerX,Y2
				invoke LineTo, hdc,X2,centerY
				invoke LineTo, hdc,centerX,Y1
				;смещения по узловым координатам
				sub Y1,StepStar
				add Y2,StepStar
				add X1,StepStar
				sub X2,StepStar
				dec N	;рисуем, пока не 0
				jnz draw_4_lines
			  end_draw:	;заканчиваем рисовать и пишем в правом верхнем углу
				invoke SetBkColor, hdc, BlackBoardColor
				mov eax,rect.right
				sub eax,180
				mov X1,rax
				invoke TextOut, hdc, rax, 0, ADDR inf_txt1, inf_len1
				invoke TextOut, hdc, X1, 16, ADDR inf_txt2, inf_len2
				invoke EndPaint, hWNDdlg3, ADDR ps
			.case WM_GETMINMAXINFO		;контроль размеров окна
				mov rax,lParam
				add rax,MINMAXINFO.ptMinTrackSize
				mov [rax+POINT.x],646	;по горизонтали
				mov [rax+POINT.y],736	;по вертикали
				xor rax,rax
			.case WM_SIZE	;изменился размер окна
				invoke GetClientRect, hWNDdlg3, ADDR wrect
				invoke GetClientRect, hBbck, ADDR rect
				mov eax,wrect.bottom
				sub rax,8
				sub eax,rect.bottom
				mov Y1,rax
				invoke MoveWindow, hBbck, 8 , Y1, rect.right, rect.bottom ,FALSE	;переместить левую кнопку
				mov eax,wrect.right
				sub rax,8
				sub eax,rect.right
				mov X1,rax
				invoke MoveWindow, hBnxt, X1, Y1, rect.right,rect.bottom ,FALSE	;переместить правую кнопку
				invoke SendMessage, hBitIcon, STM_SETIMAGE, IMAGE_ICON, hIcon	;восстановить фото
				invoke InvalidateRect, hWNDdlg3,0,FALSE	;сообщение о несоответствии рабочей области
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
				invoke DeleteObject, hPurple		;удалить кисть
				invoke EndDialog, hWNDdlg4,	0		;закрыть диалог
			.case WM_COMMAND
				.switch wParam
					.case BN_CLICKED shl 16 + IDCANCEL				;нажата ESC
						invoke SendMessage, hWNDdlg4,WM_CLOSE, 0	;сообщить о закрытии
					.case IDC_AIM
						invoke DeleteObject, hPurple	;удалить кисть
						invoke EndDialog, hWNDdlg4, 5	;закрыть диалог для перехода в след окно
				.endsw	
			.case WM_LBUTTONDOWN						;захват мышью
				invoke ReleaseCapture
				invoke SendMessage, hWNDdlg4, WM_SYSCOMMAND, SC_MOVE+MOUSE_EVENT, 0
			.case WM_PAINT
				invoke BeginPaint, hWNDdlg4, ADDR ps		;начать рисовать	
				mov hdc,rax									;запомнить handle контекста
				invoke GetClientRect, hWNDdlg4, ADDR rect	;прямоугольник рабочей области
				invoke FillRect, hdc, ADDR rect, hPurple	;залить область своим цветом
				invoke EndPaint,hWNDdlg4					;закончить рисовать
			.case  WM_INITDIALOG
				invoke CreateSolidBrush, 0F800CCh			;создать сплошную кисть
				mov hPurple,rax								;сохранить handle
				invoke  GetSystemMetrics,SM_CYSCREEN		;получить размеры экрана по вертикали
				shr rax,1									;разделить на 2
				mov scrY,rax								;запомнить
				sub rax,40									;чуть уменьшить
				mov N,rax									;наружный радиус 
				invoke  GetSystemMetrics,SM_CXSCREEN		;получить размеры экрана по горизонтали
				shr rax,1									;разделить на 2
				mov scrX,rax								;запомнить
				sub rax,N									;от центра влево
				mov wrect.left,eax							;записать
				mov wrect.top,40							;чуть отступить
				mov rax,scrY								;от центра
				add rax,N									;на радиус вниз 
				mov wrect.bottom,eax						;записать
				mov rax,scrX								;от центра		
				add rax,N									;вправо
				mov wrect.right,eax							;записать
				invoke SetWindowPos,hWNDdlg4,HWND_TOP, \	;установить позицию окна по центру с расчетными габаритами
						wrect.left, wrect.top, wrect.right, wrect.bottom,0
				mov eax,wrect.left							;загузить левую координату
				sub wrect.right,eax							;вычесть из правой - ширина
				mov eax,wrect.top							;загузить верхнюю координату
				sub wrect.bottom,eax						;вычесть из нижней - высота
				mov wrect.left,0							;установить левую координату в 0
				mov wrect.top,0								;установить верхнююю координату в 0
				invoke CreateEllipticRgn,wrect.left,wrect.top,wrect.right, wrect.bottom	;создать круглый регион в выбранном прямоугольнике 
				mov regMain,rax								;запомнить handle
				mov rax, N									;загрузить радиус области
				mov rcx,StepBagel							;загрузить шаг нарезки
				xor rdx,rdx									;обнулить перед делением
				div rcx										;количество границ
				sub rax,2									;немного уменьшить, для центральной зоны
				mov N,rax									;запомнить это количество
				mov MaskRgn,RGN_AND							;выбрать маску комбинирования регионов
			  new_round:
				add wrect.left,StepBagel					;сместить левый край
				sub wrect.right,StepBagel					;сместить правый край
				add wrect.top,StepBagel						;сместить верхний край
				sub wrect.bottom,StepBagel					;сместить нижний край
				invoke CreateEllipticRgn,wrect.left,wrect.top,wrect.right, wrect.bottom	;создать круглый регион внутри предыдущего
				mov reg0,rax								;запомнить handle
				invoke CombineRgn, regMain, regMain, reg0, MaskRgn	;комбинировать с пред регионом (добавить/вырезать)
				invoke DeleteObject, reg0					;освободить регион
				shr MaskRgn,1								;след маска
				cmp MaskRgn,1								;уже не та
				ja @f										;нет еще, переход
				mov MaskRgn, RGN_DIFF						;установить вырезание
			  @@:
				dec N										;уменьшить счетчик границ
				jnz new_round								;переход к новому кругу
				invoke SetWindowRgn, hWNDdlg4, regMain, FALSE	;установить полученный регион для окна
			.default
				xor rax,rax									;остальные сообщения не обратываем
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
				invoke DeleteObject,hBank		;освободить память от BMP-файла
				invoke EndDialog, hWNDdlg6, 0	;закрыть диалог
			.case WM_COMMAND
				.switch wParam
					.case BN_CLICKED shl 16 + IDCANCEL			;нажата ESC
						invoke SendMessage, hWNDdlg6,WM_CLOSE, 0	;сообщить о закрытии
					.case IDC_BANK
						invoke DeleteObject,hBank		;освободить память от BMP-файла
						invoke EndDialog, hWNDdlg6, 6	;закрыть диалог
				.endsw
			.case WM_LBUTTONDOWN					;захват мышью
				invoke ReleaseCapture					
				invoke SendMessage, hWNDdlg6, WM_SYSCOMMAND, SC_MOVE+MOUSE_EVENT, 0
			.case WM_PAINT
				invoke BeginPaint,hWNDdlg6, addr ps ;начать рисовать	
				mov hdc,rax 						;запомнить handle контекста
				invoke CreateCompatibleDC,hdc; 		;создать контекст устройства в памяти
				mov hMemDC,rax						;запомнить handle контекста
				invoke SelectObject,hMemDC,hBank	;выбрать изображение
				invoke BitBlt,hdc,0,0,bitmap.bmWidth,bitmap.bmHeight,hMemDC,0,0,SRCCOPY	;копирование изображения в память контекста
				invoke DeleteDC,hMemDC				;освободить контекст устройства в памяти
				invoke EndPaint,hWNDdlg6,addr ps 	;закончить рисовать
			.case  WM_INITDIALOG
				invoke GetDlgItem, hInstance, IDC_BANK	;получить handle кнопки
				mov hBbank,rax							;запомнить его
				invoke LoadBitmap,hInstance,IDB_BANK	;загрузить Bitmap изображение
				mov hBank,rax							;запомнить его 
				invoke GetObject,hBank,type BITMAP, ADDR bitmap	;получить информацию об изображении
				invoke SetWindowPos, hWNDdlg6, HWND_TOP,500,100,\	;установить окно верхним
						 bitmap.bmWidth,bitmap.bmHeight, SWP_NOZORDER;
				invoke GetClientRect, hWNDdlg6, ADDR rect	;получить прямоугольник рабочей области
				invoke  CreateRectRgn,0,0,rect.right,rect.bottom	; Cоздать главный регион для окна
				mov hRMain,rax
				invoke FindResource, hInstance, IDB_BANK, RT_BITMAP	; Найти в ресурсах картинку с маской
				invoke  LoadResource, hInstance, rax				; Загрузить картинку с маской
				invoke  LockResource,rax							; Получить указатель на память с картинкой
				mov r10,rax											; Сохранить указатель
				push rdi											; сохранить регистр
				push rsi											; сохранить регистр
				push rbx											; сохранить регистр
				; Получить все необходимые данные напрямую из ресурсной области
				mov eax,[rax]
				add rax,r10
				mov rsi,rax
				cmp WORD ptr [r10+14],24			;только 24-битная картинка
				jne finish_mask						;иначе отбой
				; Установить начальные координаты
				mov eax,bitmap.bmWidth				;ширина картики
				mov edx,3							;3 байта на пиксель
				mul edx								;столько байт занимает 1 линия
				test rax,11b						;проверка выровнивания на 4
				jz @f								;все ок
				and rax,0FFFFFFFFFFFFFFFCh			;надо выровнять
				add rax,4
			  @@:
				mov linesize,rax					;размер памяти, занимаемый 1 линией
				mov edx,bitmap.bmHeight				;высота картинки
				dec edx								;индекс послед линии
				mul rdx								;на столько смещаемся
				add rsi,rax 						;RSI хранит адрес начала линии
				mov Y,0								;номер линии
			  loop_y:
				xor rbx,rbx							;RBX - координата Х
				mov rdi,0							;RDI-смещение относительно начала линии
				mov r10,0							;координата Х - начало прозрачного участка
				mov r11,0							;признак прозрачного участка
			  loop_x:
				mov eax, DWORD ptr [rsi+rdi]		;код цвета пикселя с мусором в [31:24]
				and rax,0FFFFFFh					;чистый код цвета пикселя
				cmp eax,COLOR_BANK5					;сравнение с прозрачным цветом
				jnz   chk_pixel						;нет, цветная
				; Точка прозрачная
				cmp r11,1							;сейчас область прозрачности
				je next_pixel						;да, к след пикселю
				mov r10,rbx							;запонить начало области прозрачности
				mov r11,1							;установить признак прозрачного участка
				jmp next_pixel						; к след пикселю
			  chk_pixel:
				cmp r11,1							; Если точка непрозрачная и флаг не установлен
				jne     next_pixel					;то к след пикселю
				mov     rax,Y						
				inc     rax							
				; Вырезать прозрачный блок из главного региона
				invoke CreateRectRgn,r10,rax,rbx,Y	;создать регион расченой линии прозрачности
				push rax							;сохранить handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;вырезать регион из основного 
				invoke DeleteObject					; Освободить память региона
				mov r11,0							; Сбросить флаг 
			  next_pixel:
				add	rdi,3							;сместиться на 3 байта (1 пиксель)
				inc rbx								;изменить координату Х
				cmp ebx,bitmap.bmWidth				;вышли за границу
				jb loop_x							;нет, след пиксель
				cmp r11,1							;сейчас в прозрачной области
				jne @f								;нет, идем дальше
				mov rax,Y							;линия закончиласть - вырезать регион
				inc rax
				; Вырезать прозрачный блок из главного региона
				invoke CreateRectRgn,r10,rax,rbx,Y	;создать регион расченой линии прозрачности
				push rax							;сохранить handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;вырезать регион из основного 
				invoke DeleteObject					; Освободить память региона
			  @@:
				sub rsi,linesize					;сместиться на след линию
				inc Y								;изменить координату Y
				mov rax,Y
				cmp eax,bitmap.bmHeight				;закончились линии
				jb loop_y							;нет, переход к следующей
				invoke  SetWindowRgn,hWNDdlg6,hRMain,TRUE	; Установить регион для окна с его перерисовкой
			  finish_mask:
				invoke  DeleteObject,hRMain			; Освободить память региона
				pop rbx								;восстановить регистр
				pop rsi								;восстановить регистр
				pop rdi								;восстановить регистр
			.default
				xor rax,rax							;остальные сообщения не обратываем
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
				invoke DeleteObject,hBank		;освободить память от BMP-файла
				invoke EndDialog, hWNDdlg6, 0	;закрыть диалог
			.case WM_COMMAND
				.switch wParam
					.case BN_CLICKED shl 16 + IDCANCEL			;нажата ESC
						invoke SendMessage, hWNDdlg6,WM_CLOSE, 0	;сообщить о закрытии
					.case IDC_BANK
						invoke DeleteObject,hBank		;освободить память от BMP-файла
						invoke EndDialog, hWNDdlg6, 6	;закрыть диалог
				.endsw
			.case WM_LBUTTONDOWN					;захват мышью
				invoke ReleaseCapture					
				invoke SendMessage, hWNDdlg6, WM_SYSCOMMAND, SC_MOVE+MOUSE_EVENT, 0
			.case WM_PAINT
				invoke BeginPaint,hWNDdlg6, addr ps 		;начать рисовать	
				mov hdc,rax 						;запомнить handle контекста
				invoke CreateCompatibleDC,hdc; 			;создать контекст устройства в памяти
				mov hMemDC,rax						;запомнить handle контекста
				invoke SelectObject,hMemDC,hMako ; 		;выбрать изображение
				invoke BitBlt,hdc,0,0,bitmap.bmWidth,bitmap.bmHeight,hMemDC,0,0,SRCCOPY	;копирование изображения в память контекста
				invoke DeleteDC,hMemDC				;освободить контекст устройства в памяти
				invoke EndPaint,hWNDdlg6,addr ps 			;закончить рисовать
			.case  WM_INITDIALOG
				invoke LoadBitmap,hInstance,IDB_MAKO		;загрузить Bitmap изображение
				mov hMako,rax						;запомнить его 
				invoke GetObject,hMako,type BITMAP, ADDR bitmap	;получить информацию об изображении
				invoke SetWindowPos, hWNDdlg6, HWND_TOP,450,70,\	;установить окно верхним
						 bitmap.bmWidth,bitmap.bmHeight, SWP_NOZORDER;
				invoke GetClientRect, hWNDdlg6, ADDR rect	;получить прямоугольник рабочей области
				invoke  CreateRectRgn,0,0,rect.right,rect.bottom	; Cоздать главный регион для окна
				mov hRMain,rax
				invoke FindResource, hInstance, IDB_MAKO, RT_BITMAP	; Найти в ресурсах картинку с маской
				invoke  LoadResource, hInstance, rax				; Загрузить картинку с маской
				invoke  LockResource,rax							; Получить указатель на память с картинкой
				mov r10,rax											; Сохранить указатель
				push rdi											; сохранить регистр
				push rsi											; сохранить регистр
				push rbx											; сохранить регистр
				; Получить все необходимые данные напрямую из ресурсной области
				mov eax,[rax]
				add rax,r10
				mov rsi,rax
				cmp WORD ptr [r10+14],24			;только 24-битная картинка
				jne finish_mask						;иначе отбой
				; Установить начальные координаты
				mov eax,bitmap.bmWidth				;ширина картики
				mov edx,3							;3 байта на пиксель
				mul edx								;столько байт занимает 1 линия
				test rax,11b						;проверка выровнивания на 4
				jz @f								;все ок
				and rax,0FFFFFFFFFFFFFFFCh			;надо выровнять
				add rax,4
			  @@:
				mov linesize,rax					;размер памяти, занимаемый 1 линией
				mov edx,bitmap.bmHeight				;высота картинки
				dec edx								;индекс послед линии
				mul rdx								;на столько смещаемся
				add rsi,rax 						;RSI хранит адрес начала линии
				mov Y,0								;номер линии
			  loop_y:
				xor rbx,rbx							;RBX - координата Х
				mov rdi,0							;RDI-смещение относительно начала линии
				mov r10,0							;координата Х - начало прозрачного участка
				mov r11,0							;признак прозрачного участка
			  loop_x:
				mov eax, DWORD ptr [rsi+rdi]		;код цвета пикселя с мусором в [31:24]
				test rax, MAKO_MASK					;наложить маску цвета - хорошо удалять темные области
				jnz chk_pixel						;нет, цветная
				; Точка прозрачная
				cmp r11,1							;сейчас область прозрачности
				je next_pixel						;да, к след пикселю
				mov r10,rbx							;запонить начало области прозрачности
				mov r11,1							;установить признак прозрачного участка
				jmp next_pixel						; к след пикселю
			  chk_pixel:
				cmp r11,1							; Если точка непрозрачная и флаг не установлен
				jne     next_pixel					;то к след пикселю
				mov     rax,Y						
				inc     rax							
				; Вырезать прозрачный блок из главного региона
				invoke CreateRectRgn,r10,rax,rbx,Y	;создать регион расченой линии прозрачности
				push rax							;сохранить handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;вырезать регион из основного 
				invoke DeleteObject					; Освободить память региона
				mov r11,0							; Сбросить флаг 
			  next_pixel:
				add	rdi,3							;сместиться на 3 байта (1 пиксель)
				inc rbx								;изменить координату Х
				cmp ebx,bitmap.bmWidth				;вышли за границу
				jb loop_x							;нет, след пиксель
				cmp r11,1							;сейчас в прозрачной области
				jne @f								;нет, идем дальше
				mov rax,Y							;линия закончиласть - вырезать регион
				inc rax
				; Вырезать прозрачный блок из главного региона
				invoke CreateRectRgn,r10,rax,rbx,Y	;создать регион расченой линии прозрачности
				push rax							;сохранить handle
				invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF	;вырезать регион из основного 
				invoke DeleteObject					; Освободить память региона
			  @@:
				sub rsi,linesize					;сместиться на след линию
				inc Y								;изменить координату Y
				mov rax,Y
				cmp eax,bitmap.bmHeight				;закончились линии
				jb loop_y							;нет, переход к следующей
				invoke  SetWindowRgn,hWNDdlg6,hRMain,TRUE	; Установить регион для окна с его перерисовкой
			  finish_mask:
				invoke  DeleteObject,hRMain			; Освободить память региона
				pop rbx								;восстановить регистр
				pop rsi								;восстановить регистр
				pop rdi								;восстановить регистр
			.default
				xor rax,rax							;остальные сообщения не обратываем
		.endsw
		ret
	Dialog6Proc endp

END

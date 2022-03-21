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
	inf_txt1	db	'Середенко О.С. КИТ-120в',0
	inf_txt2	db	'Кафедра ВТП    НТУ ХПИ',0
	ruk_title	db	'Информация о руководителе',0
	ruk_text	db	'РЫСОВАНЫЙ Александр Николаевич.',10,
					'Преподает "Системное программирование"',10,
					'Профессор кафедры “ВТП”',10,
					'НТУ ХПИ. Кафедра ВТП.',0
	auth_title	db	'Информация об исполнителе',0
	auth_text	db	'Середенко Олег Сергеевич.',10,
					'группа КИТ-120в',10,
					'Кафедра ВТП',10,
			'факультет "Компьютерные и информационные технологии"',10,
					'НТУ ХПИ',0

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
	invoke GetModuleHandle, 0	;получить handle
	mov hInstance, rax			;запомнить его
	invoke DialogBoxParam, hInstance,IDD_DLG0,\
		HWND_DESKTOP, ADDR Dialog0Proc,0	;вызвать 1 диалог окно
	invoke ExitProcess, 0		;завершение программы
entry_point endp


Dialog0Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	.switch uMsg
		.case WM_CLOSE	;закрытие всех handle-ов
			invoke DeleteObject, hPhoto0	;удалить BMP-файл
			invoke EndDialog, hWNDdlg, 0	;закыть диалог
		.case WM_COMMAND
			.switch wParam
				.case IDC_EXE	;нажатие копки EXE(графического задания)
					invoke WinExec,ADDR exename,SW_SHOW;запуск приложения
				.case IDC_EXEC	;нажатие кнопки ИСПОЛНИТЕЛЬ
					invoke DialogBoxParam, hInstance, IDD_DLG1, 0, \
						ADDR Dialog1Proc, 0	;запуск окна 2
				.case IDC_LEAD	;нажатие кнопки РУКОВОДИТЕЛЬ
					invoke DialogBoxParam, hInstance, IDD_DLG2, 0,\
						ADDR Dialog2Proc, 0	;запуск окна 3
			.endsw
		.case WM_INITDIALOG
			invoke LoadImage, hInstance, IDB_0, IMAGE_BITMAP,\
					0, 0, LR_DEFAULTSIZE	;фото себя
			mov hPhoto0,rax					;запомнить
			invoke LoadIcon,hInstance,IDI_ICON0;загрузка иконки себя
			mov hIcon0,rax					;запомнить
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_SMALL, rax	;вывод иконки окна на окне
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_BIG, hIcon0	;...панели задач
			invoke GetDlgItem, hWNDdlg, IDC_IMG0	;handle объекта
			invoke SendMessage, rax, STM_SETIMAGE,\
					IMAGE_BITMAP, hPhoto0	;установка фото
		.default
			xor rax,rax	;остальные сообщения не обратывать
	.endsw
	ret
Dialog0Proc endp

Dialog1Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	.switch uMsg
		.case WM_CLOSE	;закрытие всех handle-ов
			invoke DeleteObject, hPhoto1	;удалить BMP-файл
			invoke EndDialog, hWNDdlg, 0	;закыть диалог
		.case WM_COMMAND
			.switch wParam
				.case IDC_BTN1x	;нажатие копки ЗАКРЫТЬ
					invoke SendMessage,hWNDdlg,WM_CLOSE,0;закрыть окно
				.case IDC_BTN1o	;нажатие кнопки СПРАВКА
					invoke MessageBoxIndirect, ADDR mbp_exec;вывод справки
				.case IDC_BTN1s	;нажатие кнопки ОКНО?
					invoke DialogBoxParam, hInstance, IDD_DLG3,0,\
							ADDR Dialog3Proc, 0	;запуск окна 4
			.endsw
		.case WM_INITDIALOG
			invoke LoadImage,hInstance,IDB_1,IMAGE_BITMAP,0,0,\
						LR_DEFAULTSIZE	;фото себя
			mov hPhoto1,rax				;запомнить
			invoke LoadIcon,hInstance,IDI_ICON1	;загрузка иконки себя
			mov hIcon1,rax				;запомнить
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_SMALL, rax		;вывод иконки окна на окне
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_BIG, hIcon1	;...панели задач
			invoke GetDlgItem, hWNDdlg, IDC_IMG1;handle объекта
			invoke SendMessage, rax, STM_SETIMAGE, IMAGE_BITMAP,\
						hPhoto1				;установка фото
			mov rax,hInstance				;handle программы
			mov mbp_exec.hInstance,rax		;запись handle в структуру
			mov rax,hWNDdlg					;handle окна
			mov mbp_exec.hwndOwner,rax		;запись handle в структуру
			mov mbp_exec.cbSize,SIZEOF MSGBOXPARAMS;записать размер структуры
			mov mbp_exec.dwStyle, MB_USERICON;установить стиль диалогового окна
			mov mbp_exec.lpszIcon, IDI_ICON1;установить иконку
			mov mbp_exec.dwContextHelpId, 0	;запись в структуру
			mov mbp_exec.lpfnMsgBoxCallback,0;запись в структуру
			mov mbp_exec.dwLanguageId, LANG_NEUTRAL	;язык по умолчанию
			lea rax, auth_text			;загрузить указатель на текст сообщения
			mov mbp_exec.lpszText,rax		;записать в структуру
			lea rax, auth_title			;загрузить указатель на текст заголовка
			mov mbp_exec.lpszCaption,rax	;записать в структуру
		.default
			xor rax,rax
	.endsw
	ret
Dialog1Proc endp

Dialog2Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	.switch uMsg
		.case WM_CLOSE	;закрытие всех handle-ов
			invoke DeleteObject, hPhoto2	;удалить BMP-файл
			invoke EndDialog, hWNDdlg, 0	;закыть диалог
		.case WM_COMMAND
			.switch wParam
				.case IDC_BTN2x	;нажатие копки ЗАКРЫТЬ
					invoke SendMessage,hWNDdlg,WM_CLOSE,0;закрыть окно
				.case IDC_BTN2o	;нажатие кнопки СПРАВКА
					invoke MessageBoxIndirect, ADDR mbp_lead;вывод спрвки
			.endsw
		.case WM_INITDIALOG
			invoke LoadImage,hInstance,IDB_2,IMAGE_BITMAP,0,0,\
						LR_DEFAULTSIZE	;фото себя
			mov hPhoto2,rax				;запомнить
			invoke LoadIcon,hInstance,IDI_ICON2	;загрузка иконки себя
			mov hIcon2,rax						;запомнить
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_SMALL, rax	;вывод иконки окна на окне
			invoke SendMessage, hWNDdlg,WM_SETICON, \
					ICON_BIG, hIcon2	;...панели задач
			invoke GetDlgItem, hWNDdlg, IDC_IMG2	;handle объекта
			invoke SendMessage, rax, STM_SETIMAGE, IMAGE_BITMAP,\
					hPhoto2				;установка фото
			mov rax,hInstance				;handle программы
			mov mbp_lead.hInstance,rax		;запись handle в структуру
			mov rax,hWNDdlg					;handle окна
			mov mbp_lead.hwndOwner,rax				;запись handle в структуру
			mov mbp_lead.cbSize,SIZEOF MSGBOXPARAMS	;записать размер структуры
			mov mbp_lead.dwStyle, MB_USERICON		;установить стиль диалог окна
			mov mbp_lead.lpszIcon, IDI_ICON2		;установить иконку
			mov mbp_lead.dwContextHelpId, 0			;запись в структуру
			mov mbp_lead.lpfnMsgBoxCallback,0		;запись в структуру
			mov mbp_lead.dwLanguageId, LANG_NEUTRAL	;язык по умолчанию
			lea rax, ruk_text						;указатель на текст сообщения
			mov mbp_lead.lpszText,rax				;записать в структуру
			lea rax, ruk_title						;указатель на текст заголовка
			mov mbp_lead.lpszCaption,rax			;записать в структуру
		.default
			xor rax,rax		;остальные сообщения не обратывать
	.endsw
	ret
Dialog2Proc endp

Dialog3Proc proc hWNDdlg:QWORD, uMsg:QWORD, wParam:QWORD, lParam:QWORD
	local rect		: RECT
	.switch uMsg
		.case WM_CLOSE
			invoke DeleteObject, hUA		;удалить BMP-файл
			invoke EndDialog, hWNDdlg,0		;закрыть диалог
		.case WM_COMMAND
			.switch wParam
				.case BN_CLICKED shl 16 + IDCANCEL			;нажата ESC
					invoke SendMessage,hWNDdlg,WM_CLOSE,0	;закрытие окна
			.endsw	
		.case WM_LBUTTONDOWN				;захват мышью
				invoke ReleaseCapture		
				invoke SendMessage,hWNDdlg,WM_SYSCOMMAND,SC_MOVE+MOUSE_EVENT,0
		.case WM_RBUTTONDOWN	;клик правой кнопки мыши
			mov rax,lParam		;упакованные координаты клика
			shr rax,16			;координата Y
			cmp rax,lin			;сравнить вертикальную координату со сред линией
			ja @f
			invoke SendMessage, hWNDdlg,WM_CLOSE, 0	;сообщить о закрытии
			jmp end_msg
		 @@:invoke DialogBoxParam,hInstance,IDD_DLG4,0,\
					ADDR Dialog4Proc,0	;запуск окна 5
		.case  WM_INITDIALOG
			invoke LoadImage,hInstance,IDB_3,IMAGE_BITMAP,0,0,\
					LR_DEFAULTSIZE	;фото себя
			mov hUA,rax				;запомнить
			invoke GetDlgItem,hWNDdlg,IDC_IMG3	;handle объекта
			invoke SendMessage, rax, STM_SETIMAGE,\
					IMAGE_BITMAP, hUA	;установить картинку
			invoke LoadIcon,hInstance,IDI_ICON3	;загрузка иконки соответствующей
			invoke SendMessage,hWNDdlg,WM_SETICON,\
					ICON_BIG, rax		;установить иконку
			invoke GetClientRect,hWNDdlg,ADDR rect	;прямоугольник раб области
			mov eax,rect.bottom			;высота
			shr rax,1					;разделить на 2
			mov lin,rax					;запомнить серединную линию
			;создать круглый регион в выбранном прямоугольнике 
			invoke CreateEllipticRgn,rect.left,rect.top,rect.right,rect.bottom
			;установить полученный регион для окна
			invoke SetWindowRgn, hWNDdlg, rax, TRUE
		.default
			xor rax,rax		;остальные сообщения не обратывать
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
			invoke DeleteObject,hBomb	;освободить память от BMP-файла
			invoke EndDialog, hWNDdlg, 0;закрыть диалог
		.case WM_COMMAND
			.switch wParam
				.case BN_CLICKED shl 16 + IDCANCEL		;нажата ESC
					invoke SendMessage,hWNDdlg,WM_CLOSE,0;сообщить о закрытии
			.endsw
		.case WM_LBUTTONDOWN					;захват мышью
			invoke ReleaseCapture					
			invoke SendMessage,hWNDdlg,WM_SYSCOMMAND,SC_MOVE+MOUSE_EVENT,0
		.case WM_PAINT
			invoke BeginPaint,hWNDdlg, addr ps	;начать рисовать
			mov hdc,rax 						;запомнить handle контекста
			invoke CreateCompatibleDC,hdc;	;создать контекст устройства в памяти
			mov hMemDC,rax					;запомнить handle контекста
			invoke SelectObject,hMemDC,hBomb;выбрать изображение
			invoke BitBlt,hdc,0,0,bitmap.bmWidth,bitmap.bmHeight,\
					hMemDC,0,0,SRCCOPY	;копирование изображения в память контекста
			invoke DeleteDC,hMemDC		;освободить контекст устройства в памяти
			invoke EndPaint,hWNDdlg,addr ps	;закончить рисовать
		.case  WM_INITDIALOG
			invoke LoadIcon,hInstance,IDI_ICON4	;загрузка иконки соответствующей
			invoke SendMessage, hWNDdlg,WM_SETICON,\
					ICON_BIG, rax		;установить иконку
			invoke LoadBitmap,hInstance,IDB_4;загрузить Bitmap изображение
			mov hBomb,rax					;запомнить его 
			invoke GetObject,hBomb,type BITMAP,\
					ADDR bitmap	;получить информацию об изображении
			invoke SetWindowPos, hWNDdlg, HWND_TOP,500,500,\;установить окно верхним
					 bitmap.bmWidth,bitmap.bmHeight, SWP_NOZORDER;
			;получить прямоугольник рабочей области
			invoke GetClientRect, hWNDdlg, ADDR rect
			; Cоздать главный регион для окна
			invoke  CreateRectRgn,0,0,rect.right,rect.bottom
			mov hRMain,rax		;запонить handle
			; Найти в ресурсах картинку с маской
			invoke FindResource,hInstance,IDB_4,RT_BITMAP
			; Загрузить картинку с маской
			invoke  LoadResource, hInstance, rax
			; Получить указатель на память с картинкой
			invoke  LockResource,rax; Получить указатель на память с картинкой
			mov r10,rax		; Сохранить указатель
			push rdi		; сохранить регистр
			push rsi		; сохранить регистр
			push rbx		; сохранить регистр
			; Получить все необходимые данные напрямую из ресурсной области
			mov eax,[rax]		;размер заголовка
			add rax,r10			;сместить
			mov pallette,rax	;адрес палитры
			add rax,1024		;размер палитры
			mov rsi,rax			;адрес начала изображения
			; Установить начальные координаты
			mov eax,bitmap.bmWidth	;ширина картики
			test rax,11b			;проверка выровнивания на 4
			jz @f					;все ок
			and rax,0FFFFFFFFFFFFFFFCh	;надо выровнять
			add rax,4				;на 4
		 @@:mov linesize,rax		;размер памяти, занимаемый 1 линией
			mov edx,bitmap.bmHeight	;высота картинки
			dec edx					;индекс послед линии
			mul rdx					;на столько сместить
			add rsi,rax 			;RSI хранит адрес начала линии 0
			mov Y,0					;номер линии
			mov al, BYTE ptr [rsi]	;индекс прозрачного цвета (0,0)
			mov index,al			;запомнить индекс
		  loop_y:
			xor rbx,rbx		;RBX - координата Х
			mov rdi,0		;RDI-смещение относительно начала линии
			mov r10,0		;координата Х - начало прозрачного участка
			mov r11,0		;признак прозрачного участка
		  loop_x:
			mov al,BYTE ptr[rsi+rdi];индекс цвета пикселя 
			cmp al, index	;сравнение с прозрачным цветом
			jnz chk_pixel	;нет, цветная
			; Точка прозрачная
			cmp r11,1		;сейчас область прозрачности
			je next_pixel	;да, к след пикселю
			mov r10,rbx		;запонить начало области прозрачности
			mov r11,1		;установить признак прозрачного участка
			jmp next_pixel	; к след пикселю
		  chk_pixel:
			cmp r11,1		; Если точка непрозрачная и флаг не установлен
			jne next_pixel	;то к след пикселю
			mov rax,Y		;нижняя граница прозрачной области
			inc rax			
		; Вырезать прозрачный блок из главного региона
			;создать регион расченой линии прозрачности
			invoke CreateRectRgn,r10,rax,rbx,Y
			push rax		;сохранить handle
			;вырезать регион из основного 
			invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF
			invoke DeleteObject	; Освободить память региона
			mov r11,0			; Сбросить флаг 
		  next_pixel:
			inc	rdi					;сместиться на 1 байт (1 пиксель)
			inc rbx					;изменить координату Х
			cmp ebx,bitmap.bmWidth	;вышли за границу
			jb loop_x				;нет, след пиксель
			cmp r11,1				;сейчас в прозрачной области
			jne @f					;нет, идем дальше
			mov rax,Y				;линия закончиласть - вырезать регион
			inc rax
		; Вырезать прозрачный блок из главного региона
			;создать регион расченой линии прозрачности
			invoke CreateRectRgn,r10,rax,rbx,Y
			push rax		;сохранить handle
			;вырезать регион из основного 
			invoke CombineRgn,hRMain,hRMain,rax,RGN_DIFF
			invoke DeleteObject	; Освободить память региона
		  @@:
			sub rsi,linesize		;сместиться на след линию
			inc Y					;изменить координату Y
			mov rax,Y				;загрузить координату
			cmp eax,bitmap.bmHeight	;закончились линии
			jb loop_y				;нет, переход к следующей
		; Установить регион для окна с его перерисовкой
			invoke  SetWindowRgn,hWNDdlg,hRMain,TRUE
		  finish_mask:
			invoke  DeleteObject,hRMain	; Освободить память региона
			pop rbx						;восстановить регистр
			pop rsi						;восстановить регистр
			pop rdi						;восстановить регистр
		.default
			xor rax,rax		;остальные сообщения не обратываем
	.endsw
	ret
Dialog4Proc endp

END

MyGui := Gui(,"CS2 Cleaner")
MyGui.BackColor := "F3F3F3"
WinSetTransparent "220", MyGui
MyGui.SetFont("s12", "Comic Sans MS")

MyGui.Add("Text", "w300", LANGUAGE(1))

Create := MyGui.Add("Button", "vi_Create", LANGUAGE(2))
Create.OnEvent("Click", (*) => CREATE_DUMP_FILE())

Uninstall := MyGui.Add("Button", "vi_Uninstall", LANGUAGE(3))
Uninstall.OnEvent("Click", (*) => UNINSTALL_SHIT())

MyGui.Show()

CREATE_DUMP_FILE() {
    ;Проверяет наличие файла дампа
    if (FileExist("CS2*.csv")) {
        FileDelete("CS2*.csv")
    }

    ;Выбрать папку для создания дампа
    if (!open_folder := DirSelect("::{20d04fe0-3aea-1069-a2d8-08002b30309d}",, LANGUAGE(4))) {
        MsgBox(LANGUAGE(6))
        ExitApp()
    }

    ;Перебор всех файлов в папке с игрой
    loop files open_folder "\*.*", "R" {
    list .= A_LoopFileFullPath "`n"
    }
    FileAppend(list, "CS2 " A_DD "." A_MM "." A_YYYY ".csv")
    if (!A_LastError) {
        MsgBox(LANGUAGE(7))
    }
}
UNINSTALL_SHIT() {
    ;Выбрать папку для создания дампа
    if (!open_folder := DirSelect("::{20d04fe0-3aea-1069-a2d8-08002b30309d}",, LANGUAGE(4))) {
        MsgBox(LANGUAGE(6))
        ExitApp()
    }

    ;Выбрать файл дампа
    if (!open_file := FileSelect(1, A_ScriptDir, LANGUAGE(5), "CS2*.csv")) {
        MsgBox(LANGUAGE(8))
        ExitApp()
    }

    ;Запсывает в массив все файлы из дампа
    temp_buffer := []
    loop read open_file {
        temp_buffer.Push(A_LoopReadLine)
    }

    ;Сравнивает и удаляет лишнее и папки с игрой
    deleted_files_counter := 0
    size_deleted_files_counter := 0
    loop files open_folder "\*.*", "R" {
        found := false
        for index in temp_buffer {
            if (temp_buffer[A_Index] == A_LoopFileFullPath) {
                found := true
                break
            }
            }
        if (!found) {
            deleted_files_counter++
            size_deleted_files_counter += FileGetSize(A_LoopFileFullPath, "K")
            FileDelete(A_LoopFileFullPath)
        }
    }
    MsgBox(LANGUAGE(9) size_deleted_files_counter LANGUAGE(10))
}


LANGUAGE(INDEX)
{
    LCID := Map(
    "0019", "Russian",  ; ru
    "0819", "Russian (Moldova)",  ; ru-MD
    "0419", "Russian (Russia)",  ; ru-RU
    "0022", "Ukrainian",  ; uk
    "0422", "Ukrainian (Ukraine)",  ; uk-UA
    )
 
    if (InStr(LCID[A_Language], "Russian")) {
        lang_list := ["Этот скрипт записывает имена всех файлов игры в отдельный файл. Если игра будет перегружена разными файлами, вы легко сможете вернуться к исходному состоянию за счёт удаления файлов, которые не существовали на момент создания файла дампа.",
        "Создать файл дампа",
        "Вернуть в исходное состояние",
        "1) Найди папку: Counter-Strike 2`n2) Кликни на неё и нажми - OK.",
        "1) Найди заранее созданный файл дампа 2) Кликни на этот файл и нажми - OK.",
        "Вы не выбрали папку с игрой!",
        "Файл дампа создан!",
        "Вы не выбрали файл дампа!",
        "Удалено: ",
        " Килобайт"]
    }
    else if (InStr(LCID[A_Language], "Ukrainian")) {
        lang_list := ["Цей скрипт записує імена всіх файлів гри в окремий файл. Якщо гра буде перевантажена різними файлами, ви легко зможете повернутися до початкового стану за рахунок видалення файлів, які не існували на момент створення файлу дампа.", 
        "Створити файл дампа",
        "Повернути у початковий стан",
        "1) Знайди папку: Counter-Strike 2`n2) Клікни на неї і натисни - OK.",
        "1) Знайди заздалегідь створений файл дампа 2) Клікни на цей файл і натисни - OK.",
        "Ви не обрали папку з грою!"
        "Файл дампу створено!",
        "Ви не обрали папку з грою!",
        "Ви не обрали файл дампу!",
        "Видалено: ",
        " Кілобайт"]
    }
    else {
        lang_list := ["This script writes the names of all game files to a separate file. If the game will be overloaded with different files, you can easily return to the original state by deleting files that did not exist at the time of creating the dump file.",
        "Create dump file",
        "Return to the original state",
        "1) Find the folder: Counter-Strike 2`n2) Click on it and press - OK.",
        "1) Find the previously created dump file 2) Click on this file and press - OK.",
        "You haven't selected a game folder!"
        "The dump file has been created!",
        "You haven't selected a game folder!",
        "You haven't selected a dump file!",
        "Deleted: ",
        " Kilobytes"]
    }
    return lang_list[INDEX]
}

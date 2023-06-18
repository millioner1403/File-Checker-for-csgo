PROGRAM_LOCALIZATION()

MyGui := Gui(, "File Checker")
MyGui.Add("Text", "w215 h90", gui_info)
MyGui.Add("Button", "Default w215 h35", gui_button_1).OnEvent("Click", SCAN)
MyGui.Add("Button", "Default w215 h35", gui_button_2).OnEvent("Click", CHECK)
MyGui.Show("AutoSize Center")

SCAN(*)
{
    MyGui.Hide()
    open_folder := DirSelect("::{20d04fe0-3aea-1069-a2d8-08002b30309d}",, open_folder_text)
    if (open_folder == "")
        ExitApp()

    IniWrite(open_folder, "settings.ini", "SteamPATH", "csgo")
    FileName := "CSGO " A_DD "." A_MM "." A_YYYY ".txt"
    
    if (FileExist(FileName))
    {
        if MsgBox(overwrite_text,, "YesNo") = "Yes"
        {
            FileDelete(FileName)
            loop files open_folder "\*.*", "R"
            {
                FileAppend(A_LoopFileFullPath "`n", FileName)
            }
            MsgBox(overwritten_text)
        }
    }
    else
    {
        loop files open_folder "\*.*", "R"
        {
            FileAppend(A_LoopFileFullPath "`n", FileName)
        }
        MsgBox(created_text)
    }
}

CHECK(*)
{
    MyGui.Hide()
    temp_buffer := []
    open_file := FileSelect(1, , open_file_text, "(*.txt)")
    if (open_file == "")
        ExitApp()

    FileCorrect := InStr(open_file, "CSGO")
    if (FileCorrect < 1)
    {
        MsgBox(oops_text)
        ExitApp()
    }
        
    loop read open_file
    {
        temp_buffer.Push(A_LoopReadLine)
    }

    if (!FileExist("settings.ini"))
    {
        open_folder := DirSelect("::{20d04fe0-3aea-1069-a2d8-08002b30309d}",, open_folder_text)
        if (open_folder == "")
            ExitApp()
        IniWrite(open_folder, "settings.ini", "SteamPATH", "csgo")
    }
    
    open_folder := IniRead("settings.ini", "SteamPATH", "csgo")

    Result := MsgBox(sure_text open_folder "?",, "YesNo")
    if Result = "Yes"
    {
        deleted_files_counter := 0
        size_deleted_files_counter := 0
        loop files open_folder "\*.*", "R"
        {
            found := false
            for index in temp_buffer
            {
                if (temp_buffer[A_Index] == A_LoopFileFullPath)
                {
                    found := true
                    break
                }
            }
            if (!found)
            {
                deleted_files_counter++
                size_deleted_files_counter += FileGetSize(A_LoopFileFullPath, "K")
                FileDelete(A_LoopFileFullPath)
            }
        }
        if (deleted_files_counter)
        {
            MsgBox(trash_text open_folder successfully_removed_text deleted_files_counter size_text size_deleted_files_counter " KB")
        }
        else
        {
            MsgBox(trash_not_found_text)
        }
    }
}

PROGRAM_LOCALIZATION()
{
    global
    switch A_Language 
    {
        case 0422:
            gui_info := "Цей скрипт записує імена всіх файлів гри в окремий файл. Якщо гра буде перевантажена різними файлами, ви легко зможете повернутися до початкового стану за рахунок видалення файлів, які не існували на момент створення файлу дампа."
            gui_button_1 := "Створити файл дампа"
            gui_button_2 := "Повернути у початковий стан"
            open_folder_text := "1) Знайди папку: Counter-Strike Global Offensive`n2) Клікни на неї і натисни - OK."
            overwrite_text := "Перезаписати файл дампа?"
            overwritten_text := "Файл перезаписано!"
            created_text := "Файл створено!"
            open_file_text := "1) Знайди заздалегідь створений файл дампа 2) Клікни на цей файл і натисни - OK."
            oops_text := "Це не дамп файл..."
            sure_text := "Ти точно хочеш видалити сміття з папки: "
            trash_text := "Все сміття з папки: "
            successfully_removed_text := " був успішно вилучений!`nФайли: "
            size_text := "`nРозмір: "
            trash_not_found_text := "Нічого не знайдено. Будь ласка, завантаж більше сміття і повтори спробу😊"

        case 0419:
            gui_info := "Этот скрипт записывает имена всех файлов игры в отдельный файл. Если игра будет перегружена разными файлами, вы легко сможете вернуться к исходному состоянию за счёт удаления файлов, которые не существовали на момент создания файла дампа."
            gui_button_1 := "Создать файл дампа"
            gui_button_2 := "Вернуть в исходное состояние"
            open_folder_text := "1) Найди папку: Counter-Strike Global Offensive`n2) Кликни на неё и нажми - OK."
            overwrite_text := "Перезаписать файл дампа?"
            overwritten_text := "Файл перезаписан!"
            created_text := "Файл создан!"
            open_file_text := "1) Найди заранее созданный файл дампа 2) Кликни на этот файл и нажми - OK."
            oops_text := "Это не дамп файл..."
            sure_text := "Ты точно хочешь удалить мусор из папки: "
            trash_text := "Весь мусор из папки: "
            successfully_removed_text := " был успешно удалён!`nФайлы: "
            size_text := "`nРазмер: "
            trash_not_found_text := "Ничего не найдено. Пожалуйста, загрузи больше мусора и повтори попытку😊"

        default:
            gui_info := "This script writes the names of all game files to a separate file. If the game will be overloaded with different files, you can easily return to the original state by deleting files that did not exist at the time of creating the dump file."
            gui_button_1 := "Create dump file"
            gui_button_2 := "Return to the original state"
            open_folder_text := "1) Find the folder: Counter-Strike Global Offensive`n2) Click on it and press - OK."
            overwrite_text := "Overwrite dump file?"
            overwritten_text := "The file has been overwritten!"
            created_text := "File created!"
            open_file_text := "1) Find the previously created dump file 2) Click on this file and press - OK."
            oops_text := "This is not a dump file..."
            sure_text := "You definitely want to remove the trash from the folder: "
            trash_text := "All garbage from the folder: "
            successfully_removed_text := " has been successfully deleted!`nFiles: "
            size_text := "`nSize: "
            trash_not_found_text := "Nothing found. Please upload more junk and try again😊"
    }
}

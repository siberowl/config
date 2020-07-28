command! SaveSession execute ':mks! ~/.vim/sessions/default | echom ''Saved session!'''
command! QuitSession execute ':mks! ~/.vim/sessions/default | :qa'
command! RestoreSession execute ':source ~/.vim/sessions/default | noh | echom ''Restored session!'''

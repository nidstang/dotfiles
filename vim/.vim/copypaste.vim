" You must have installed gvim to allow you copy to clipboard (Only Linux)
map <leader>y "*y
map <leader>p "*p
map <leader>Y "+y
map <leader>P "+p

" control + c/control + v
vnoremap <C-c> "+y
map <C-v> "+P

" Pasting - indent last pasted
nnoremap gz '[=']

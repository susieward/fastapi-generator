#!/bin/bash

source ~/fastapi-generator/constants.sh
echo "   "
echo "${blue}Welcome to the FastAPI App Generator (not affiliated with FastAPI)!${reset}"
read -p "Enter a name for your new app: ${grey}(my-app)${reset} " dirname
dirname="${dirname:=my-app}"
read -p "Include Jinja2 templating + static file setup (y/n)? ${grey}(y)${reset} " templates
mkdir ~/$dirname
if [[ "$templates" == "n" ]]
then
  read -p "Include example api routes/schema (y/n)? ${grey}(y)${reset} " api_ex
  if [[ "$api_ex" == "n" ]]; then
    echo "$main_py_basic" > ~/$dirname/main.py
    cd ~/$dirname
    python3 -m venv env
    source env/bin/activate
    pip3 install fastapi[all]
    open http://127.0.0.1:8000
    uvicorn main:app --reload
  else
    echo "$main_py_api" > ~/$dirname/main.py
    cd ~/$dirname
    python3 -m venv env
    source env/bin/activate
    pip3 install fastapi[all]
    open http://127.0.0.1:8000/docs
    uvicorn main:app --reload
  fi
else
  echo "$main_py" > ~/$dirname/main.py
  mkdir ~/$dirname/static
  echo "$main_css" > ~/$dirname/static/main.css
  mkdir ~/$dirname/templates
  echo "$index_html" > ~/$dirname/templates/index.html
  cd ~/$dirname
  python3 -m venv env
  source env/bin/activate
  pip3 install fastapi[all] jinja2 aiofiles
  open http://127.0.0.1:8000
  uvicorn main:app --reload
fi

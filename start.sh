#!/bin/bash

blue=$'\e[1;34m'
reset=$'\e[0m'
text="(my-app)"
default=$'\e[2m'${text}$'\e[0m'

main_py=$(cat<<'EOF'
from fastapi import FastAPI, Request, Response, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

app = FastAPI()
app.mount('/static', StaticFiles(directory = 'static'), name = 'static')
templates = Jinja2Templates(directory = 'templates')

@app.get('/')
async def index(request: Request):
    return templates.TemplateResponse('index.html', { 'request': request })
EOF
)

main_css=$(cat<<'EOF'
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  padding: 0;
  font-family: 'Avenir', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#app {
  display: grid;
  max-width: 100vw;
  max-height: 100vh;
}

#content {
  display: grid;
  justify-content: center;
  align-content: flex-start;
  max-width: 100%;
  margin: 200px auto 0 auto;
}
EOF
)

index_html=$(cat<<'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="{{ url_for('static', path='/main.css') }}">
    <title>My FastAPI App</title>
  </head>
  <body>
    <div id="app">
      <div id="content">
        <h2>Hello, I am an app!</h2>
      </div>
    </div>
  </body>
</html>
EOF
)

echo "${blue}Welcome to the FastAPI Web App Generator (not affiliated with FastAPI)!${reset}"
read -p "Enter a name for your new web app: ${default} " dirname
dirname="${dirname:=my-app}"
mkdir ~/$dirname
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

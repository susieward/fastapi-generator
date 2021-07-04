#!/bin/bash

blue=$'\e[1;34m'
reset=$'\e[0m'
text="(my-app)"
grey=$'\e[2m'
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

main_py_basic=$(cat<<'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get('/')
async def read_root():
    return {'Hello': 'World'}
EOF
)

main_py_api=$(cat<<'EOF'
from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

# example api functionality
class Item(BaseModel):
    name: str
    price: float
    is_offer: Optional[bool] = None

@app.get('/')
async def read_root():
    return {'Hello': 'World'}

@app.get('/items/{item_id}')
async def read_item(item_id: int, q: Optional[str] = None):
    return {'item_id': item_id, 'q': q}

@app.put('/items/{item_id}')
async def update_item(item_id: int, item: Item):
    return {'item_name': item.name, 'item_id': item_id}
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

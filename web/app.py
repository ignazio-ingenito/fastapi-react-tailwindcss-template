import os
import uvicorn
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

base_path = os.path.dirname(__file__)
static_path = os.path.join(base_path, "static")
templates_path = os.path.join(base_path, "templates")
images_path = os.path.join(static_path, "images")

app = FastAPI()
app.mount("/static", StaticFiles(directory=static_path), name="static")
templates = Jinja2Templates(directory="web/templates")


@app.get("/", response_class=HTMLResponse)
async def home(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


@app.get('/favicon.ico')
def favicon():
    return FileResponse(os.path.join(images_path, 'favicon.png'))


if __name__ == "__main__":
    # use this if you need to debug through vscode
    # uvicorn.run(app,
    #             host="127.0.0.1",
    #             port=8080,
    #             log_level="info")

    # use this if you need to reload the app at every change
    uvicorn.run("app:app",
                host="127.0.0.1",
                port=8080,
                log_level="info",
                reload=True,
                workers=1)

from fastapi import FastAPI, Request

app = FastAPI()

@app.get("/")
async def get_client_ip(request: Request):
    client_ip = request.client.host
    # Split the IP, revers it and join back the reversed IP
    reversed_ip = '.'.join(client_ip.split('.')[::-1])
    return {"Reversed_IP": reversed_ip}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

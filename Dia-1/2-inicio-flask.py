from flask import Flask , request
from flask_cors import CORS


app = Flask(__name__)

CORS(app=app , origins=["http://127.0.0.1:5500"],methods=["GET" , "POST"])

usuarios = [
    {
    "nombre": "Eduardo" ,
    "apellido": "Juarez"
    },
    {
    "nombre": "Juana",
    "apellido": "Rodriguez"
    },
    {
    "nombre": "Roberto",
    "apellido": "Castillo"
    }

]

@app.route("/")

def inicio():
  return "Hola desde mi servidor de Flask"

@app.route("/mostrar-hora" , methods=["GET" , "POST"])
def mostrarHora():
  print(request.method)
  if request.method == "GET":
    return{
      "content": "Me hiciste GET"
    }

  elif request.method == "POST":
      return{
        "content": "Me hiciste POST"
      }
  return {
    "content": "22:50:15"
  }





@app.route("/usuarios" , methods = ["GET" , "POST"])

def gestionUsuario():
  if request.method == "GET":
    return {
      "mensaje": "Los usuarios son",
      "content": usuarios
    }
  elif request.method == "POST":
    print(request.get_json())
    data = request.get_json()


    usuarios.append(data)

    return{
      "mensaje": "Usuario agregado exitosamente"
    }


app.run(debug=True)
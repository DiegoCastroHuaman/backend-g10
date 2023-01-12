from flask import Flask , request
from flask_mysqldb import MySQL
#Devuelve todas las variables de entorno de este dispositivo
from os import environ
#print (environ)
#load_dotenv > cargamos todas las variables definidas en el archivo .env como si fuera variables de entorno
from dotenv import load_dotenv
load_dotenv()


app=Flask(__name__)

#CONFIGURACION PARA LA BASE DE DATOS:
#cuando tenemos un diccionario poder OBTENER el valor de una de sus llaves con el metodo .get('LLAVE'),solo es para obtener , no para asignar.

#ESTO NO SE PUEDE HACER:
#environ.get('MYSQL_HOST') = 'hola'
#environ['MYSQL_HOST'] = 'hola'
app.config['MYSQL_HOST'] = environ.get('MYSQL_HOST')
app.config['MYSQL_USER'] = environ.get('MYSQL_USER')
app.config['MYSQL_PASSWORD'] = environ.get('MYSQL_PASSWORD')
app.config['MYSQL_DB'] = environ.get('MYSQL_DB')
app.config['MYSQL_PORT'] = int(environ.get('MYSQL_PORT'))

#Cuando a una variable se le asigna una clase se llama INSTANCIA
#como inicializar mi BASE DE DATOS
mysql = MySQL(app)

@app.route('/productos', methods=['GET' , 'POST'])
def gestion_productos():
  if request.method == 'GET':
    #crea una conexion a la base de datos mediasnte un cursor
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM productos")
    productos = cursor.fetchall() #LIMIT infinito
    # cursor.fetchone() LIMIT 1
    print(productos)
    #Cerrar nuestra conexion
    cursor.close()
    resultado = []
    for producto in productos:
      
      producto_dic = {
            'id' : producto[0],
            'nombre' : producto[1],
            'imagen' : producto[2],
            'fecha_vencimiento' : producto[3].strftime('%Y-%m-%d'), #.strftime('%Y-%m-%d') > formato para q me muestre de forma ordenada para las fechas
            'precio' : producto[4],
            'disponible' : producto[5],
            'categoria_id' : producto[6]
      }

      resultado.append(producto_dic)
      print(producto_dic)
    return {
      'message' : 'Los productos son',
      'content' : resultado
    }



  elif request.method == 'POST':
    cursor = mysql.connection.cursor()
    informacion = request.get_json()
    # %s > convierte el contenido a un string
    # %f > convierte el contenido a un numero flotante
    # %d > convierte el contenido a un numero entero
    cursor.execute("INSERT INTO productos (id, nombre, imagen, fecha_vencimiento, precio, disponible, categoria_id) VALUES (DEFAULT, '%s', '%s', '%s', %f, %s, %d)" % (
    informacion.get('nombre'),
    informacion.get('imagen'),
    informacion.get('fecha_vencimiento'),
    informacion.get('precio'),
    informacion.get('disponible'),
    informacion.get('categoria_id')
    ))
#indicamos que el guardado sea permanente en la base de datos
  mysql.connection.commit()
  cursor.close()
    
  return {
      'message' : 'Producto creado exitosamente'
    }

def validar_producto(id):
  #creamos la conexion
  conexion = mysql.connection.cursor()
  #ejecutamos el select con la clausura del id
  conexion.execute("SELECT * FROM productos WHERE id =" + str(id))
  #forma covertir el cotenido de la variable en string
  #conexion.execute("SELECT * FROM productos WHERE id ="+ str(id))
  #conexion.execute("SELECT * FROM productos WHERE id = {}" .format(id))
  #conexion.execute(f"SELECT * FROM productos WHERE id = {id}")
  resultado = conexion.fetchone()
  print(resultado)
  return resultado
  conexion.close()


@app.route("/producto/<int:id>" , methods = ['GET' , 'PUT' , 'DELETE'])

def gestion_un_producto(id):
  if request.method == 'GET':
    resultado = validar_producto(id)
    if resultado is None:
      return {
        'message' :  'Producto no encontrado'
      }
      
    else:
      producto = {
      'id' : resultado[0],
      'nombre' : resultado[1],
      'imagen' : resultado[2],
      'fecha_vencimiento' : resultado[3].strftime('%Y-%m-%d'),
      'precio' : resultado[4],
      'disponible' : resultado[5],
      'categoria_id' : resultado[6]
      }
      return {
        'content' : producto
        
      }

  elif request.method == 'PUT':
    resultado = validar_producto(id)
    if resultado is None:
      return {
        'message':'Producto no existe'
      }
    
    else:
      data = request.get_json()
      print(data)
      conexion = mysql.connection.cursor()
      conexion.execute("UPDATE productos SET nombre=%s, precio=%s, fecha_vencimiento=%s, disponible=%s, imagen=%s, categoria_id=%s WHERE id =%s", [
        data.get('nombre'),
        data.get('precio'),
        data.get('fecha_vencimiento'),
        data.get('disponible'),
        data.get('imagen'),
        data.get('categoria_id'),
        resultado[0] #esto da el id del producto

      ])
      mysql.connection.commit()
      conexion.close()

      return {
        'message' : 'Producto actualizado exitosamente'
      }

  elif request.method == 'DELETE':
    resultado = validar_producto(id)
    if resultado is None:
      return {
        'message':'Producto no existe'
      }

    else:

      conexion = mysql.connection.cursor()
      #primero eliminar ese producto en los almacenes
      conexion.execute("DELETE FROM productos WHERE id = %s ", [id])
      mysql.connection.commit()
      conexion.close()

      return {
        'message':'Producto eliminado exitosamente'
      }
        

app.run(debug=True)
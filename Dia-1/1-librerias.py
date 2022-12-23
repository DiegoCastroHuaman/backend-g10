from camelcase import CamelCase

instancia = CamelCase()

texto = "hola yo deberia esta camelciando"

resultado = instancia.hump(texto)

print(resultado)
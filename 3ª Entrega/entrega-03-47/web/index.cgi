#!/usr/bin/python3

## Flask modules
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request

## Db connection
import psycopg2
import psycopg2.extras

app = Flask(__name__)

app.debug = True

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="ist199326" 
DB_DATABASE=DB_USER
DB_PASSWORD= "bd123"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

# Root function that displays IVMS
@app.route('/')
def list_accounts():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM ivm;"
    cursor.execute(query)
    return render_template("index.html", cursor=cursor)
  except Exception as e:
    return str(e) #Renders a page with the error.
  finally:
    cursor.close()
    dbConn.close()

# Displays restocking events
@app.route('/repos')
def change_balance():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    num_serie = request.args.get("num_serie") 
    man = request.args.get("fabricante")
    query = "SELECT tem_categoria.nome, SUM(evento_reposicao.unidades)" \
      + "FROM tem_categoria NATURAL JOIN evento_reposicao WHERE num_serie=%s AND fabricante=%s GROUP BY(tem_categoria.nome);"
    data = (int(num_serie), man)
    cursor.execute(query,data)
    return render_template("events_ivm.html", cursor=cursor)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

# Displays retailers
@app.route('/retailers')
def list_retailers():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM retalhista;"
    cursor.execute(query)
    return render_template("retailers.html", cursor=cursor)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

# Insert new retailer menu
@app.route('/retailers_insert')
def retailer_form():
  try:
    return render_template("insert_retailer.html")
  except Exception as e:
    return str(e)

# Insert retailer in database
@app.route('/insert_retailer', methods = ["POST"])
def insert_retailer():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    tin = request.form["tin"]
    name = request.form["retailer_name"]
    query = "INSERT INTO retalhista(tin, nam) VALUES (%s, %s);"
    data = (int(tin), name)
    cursor.execute(query,data)
    back = "<a href='retailers'>Voltar</a>"
    return ("<p>Retalhista com TIN %s e nome %s adicionado</p>" + back) % (tin, name)
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

# Confirm retailer deletion
@app.route('/confirm_delete_retailer')
def confirm_delete_retailer():
  return render_template('confirm_delete_retailer.html', params = request.args)

# Delete retailer in database
@app.route('/delete_retailer', methods = ['POST'])
def delete_retailer():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    tin = request.args.get("tin")
    query_retailer = "DELETE FROM retalhista WHERE tin=%s;"
    query_retailer_cats = "DELETE FROM responsavel_por WHERE tin=%s;"
    query_rep_event = "DELETE FROM evento_reposicao WHERE tin=%s;"
    query = query_rep_event + query_retailer_cats+ query_retailer
    data = (tin,) * 3
    cursor.execute(query,data)
    back = "<a href='retailers'>Voltar</a>"
    return ("<p>Retalhista com TIN %s removido com sucesso</p>" + back) % (tin)
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()

# Displays categories
@app.route('/categories')
def list_categories():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM categoria;"
    cursor.execute(query)
    return render_template("categories.html", cursor=cursor)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

# Auxiliary function that converts list of lists with one element in a tuple
def convert(list_of_lists):
  tup = ()
  for el in list_of_lists:
    tup += (el[0],)
  return tup

# List all sub categories on every level
@app.route('/sub_cats')
def list_sub_cats():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

    name = request.args.get("nome")
    query = "SELECT categoria FROM tem_outra WHERE super_categoria= %s ;"
    data = (name,)
    cursor.execute(query, data)
    row_num = cursor.rowcount
    if row_num == 0:
      return render_template("simple_category.html", params=request.args)
    last_query_data = convert(cursor.fetchall())
    while row_num!= 0:
      row_num = 0
      query_data = ()
      for name in last_query_data:
        cursor.execute(query, (name,))
        row_num += cursor.rowcount
        if cursor.rowcount:
          data += (name,)
        query_data += convert(cursor.fetchall())
      last_query_data = query_data
    query = ""
    for i in range(len(data)):
      if i != len(data) - 1:
        query += "SELECT categoria FROM tem_outra WHERE super_categoria= %s UNION "
      else:
        query += "SELECT categoria FROM tem_outra WHERE super_categoria= %s ;"
    cursor.execute(query, data)
    return render_template("sub_categories.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

# Insert category menu
@app.route('/new_category')
def add_category():
  try:
    return render_template("insert_category.html")
  except Exception as e:
    return str(e)

# Insert category in database
@app.route('/insert_category', methods = ['POST'])
def insert_category():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    name = request.form["retailer_name"]
    query = "INSERT INTO categoria VALUES (%s);"
    data = (name,)
    cursor.execute(query, data)
    query = "INSERT INTO categoria_simples VALUES (%s);"
    cursor.execute(query, data)
    back = "<a href='categories'>Voltar</a>"
    return ("<p>Categoria %s adicionada com sucesso!</p>" + back) % (name)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.commit()
    dbConn.close()

# Confirm deletion of category
@app.route('/confirm_delete_category')
def confirm_delete_category():
  return render_template('confirm_delete_category.html', params = request.args)

# Cascade on shelf
def shelf_cascade(cursor, nmb, serial_n, man):
  query = "DELETE FROM evento_reposicao WHERE nro=%s AND num_serie=%s AND fabricante=%s;"
  query += "DELETE FROM planograma WHERE nro=%s AND num_serie=%s AND fabricante=%s;"
  data = (nmb, serial_n, man) * 2
  cursor.execute(query, data)

# Cascade on product
def product_cascade(cursor, ean, cat):
  shelf_query = "SELECT nro, num_Serie, fabricante FROM prateleira WHERE nome=%s;"
  cursor.execute(shelf_query, (cat,))
  shelf_entries = cursor.fetchall()
  for entry in shelf_entries:
    shelf_cascade(cursor, entry[0], entry[1], entry[2], ean, cat)
  query = "DELETE FROM evento_reposicao WHERE ean=%s;"
  query += "DELETE FROM planograma WHERE ean=%s;"
  query += "DELETE FROM tem_categoria WHERE ean=%s;"
  data = (ean,) * 3
  cursor.execute(query, data)

# Delete category in database
@app.route('/delete_category', methods = ['POST'])
def delete_category():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    name = request.args.get("nome")
    ean_query = "SELECT ean FROM produto WHERE cat=%s;"
    cursor.execute(ean_query, (name,))
    prod_entries = cursor.fetchall()
    for entry in prod_entries:
      product_cascade(cursor, entry[0], name)
    query = "DELETE FROM responsavel_por WHERE nome_cat=%s;"
    query += "DELETE FROM prateleira WHERE nome=%s;"
    query += "DELETE FROM tem_categoria WHERE nome=%s;"
    query += "DELETE FROM produto WHERE cat=%s;"
    query += "DELETE FROM tem_outra WHERE super_categoria=%s OR categoria=%s;"
    query += "DELETE FROM categoria_simples WHERE nome=%s;"
    query += "DELETE FROM tem_outra WHERE super_categoria=%s OR categoria=%s;"
    query += "DELETE FROM super_categoria WHERE nome=%s;"
    query += "DELETE FROM categoria WHERE nome=%s;"
    data = (name,) * 11
    cursor.execute(query, data)
    back = "<a href='categories'>Voltar</a>"
    return ("<p>Categoria %s removida com sucesso!</p>" + back) % (name)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.commit()
    dbConn.close()

# Choose sub category menu
@app.route('/add_sub_cat')
def add_sub_cat():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM categoria;"
    cursor.execute(query)
    return render_template("choose_sub_cat.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

# Insert sub category in database
@app.route('/insert_sub_cat')
def insert_sub_cat():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    super_cat = request.args.get("nome")
    sub_cat = request.args.get("sub")
    query = "INSERT INTO tem_outra VALUES (%s, %s);"
    data = (super_cat, sub_cat)
    cursor.execute(query, data)
    query = "DELETE FROM categoria_simples WHERE nome=%s"
    cursor.execute(query, (super_cat,))
    if cursor.rowcount!=0:
      query = "INSERT INTO super_categoria VALUES (%s)"
      cursor.execute(query, (super_cat,))
    back = "<a href='categories'>Voltar</a>"
    return ("<a>%s agora tem %s como sub-categoria.</a>" + back) % data
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.commit()
    dbConn.close()

# Show all relationships between super and sub categories
@app.route('/sub_cat_menu')
def sub_cat_menu():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM tem_outra;"
    cursor.execute(query)
    return render_template("sub_cat_menu.html", cursor=cursor)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

# Confirm deletion of sub category
@app.route('/confirm_delete_sub_cat')
def confirm_delete_sub_cat():
  return render_template("confirm_delete_sub_cat.html", params = request.args)

# Delete sub category in database
@app.route('/delete_sub_cat', methods = ['POST'])
def delete_sub_cat():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)   
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    sub_cat= request.args.get("nome")
    query = "DELETE FROM tem_outra WHERE categoria=%s ;"
    cursor.execute(query, (sub_cat,))
    back = "<a href='categories'>Voltar</a>"
    return "Relação apagada com sucesso"
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.commit()
    dbConn.close()

CGIHandler().run(app)

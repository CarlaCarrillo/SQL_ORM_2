var express = require('express'),
app = express(),
port = process.env.PORT || 3000;

var UsersModel = require('./api/models/Productos')

console.log('sequelize loaded');

const Sequelize = require('sequelize');

//Option 1: Passing parameters separately
var dbName = 'tablaEjercicioORM'
var dbUser = "root";
var dbPass = 'contraseña'

const sequelize = new Sequelize('tablaEjercicioORM', 'root', 'contraseña', {
    host: 'localhost',
    dialect: 'mysql'
});

var productCrud = UsersModel(sequelize);
//crearProducto();
//listarProductos();
//actualizarProducto();
//eliminar();
buscar();

app.listen(port);

/*
function crearProducto() {
    var productoNuevo = {
    Nombre: 'planta4',
    Precio:40,
    Categoría:'Categoria 3',
    Existencia:true,
    Cantidad:5,
    Descripción:'Este es el producto 4',
    }

    productCrud.create(productoNuevo).then(resp => {
        console.log('creado...');
        console.log(resp);
    });
}


function listarProductos(){
    productCrud.findAll().then(resp => {
        console.log('listando...')

        console.log(resp)
    });
}


function actualizarProducto() {
    var productoNuevo = {
    Nombre: 'planta4',
    Precio:40,
    Categoría:'Categoria 3',
    Existencia:true,
    Cantidad:5,
    Descripción:'Este es el producto 4',
}
    productCrud.update(productoNuevo, {
        where: {
            nombre:'Planta_uno'
        }
    }).then(resp => {
        console.log('actualizado');
    });
}


function eliminar() {
    productCrud.destroy({
        where: {
            nombre:'Plantauno'
        }  
    }).then(() => {
        console.log('eliminado...')
    });
    }
*/

function buscar() {
    productCrud.findAll({
        where: {
            nombre:'Plantados',
            precio: 15,
            categoría: 'categoria 1'
        }  
    }).then(resp => {
        console.log('encontrado...')
        console.log(resp)
    });
    }

   
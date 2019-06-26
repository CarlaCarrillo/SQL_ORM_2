const Sequelize =require('sequelize');

//definir nuestra clase como nuestro modelo
module.exports = (sequelize) => {
    const Products = sequelize.define('Products', {
        
        Nombre: {
            type:Sequelize.STRING,
            allowNull:false
        },
        Precio: {
            type:Sequelize.INTEGER,
            primaryKey:true
        },
        
        Categoría: {
            type:Sequelize.STRING,
            allowNull:true
        },
        Existencia: {
            type:Sequelize.BOOLEAN,
            allowNull:false
        },
        Cantidad: {
            type:Sequelize.INTEGER,
            primaryKey:true
        },
        Descripción: {
            type:Sequelize.STRING,
            allowNull:false
        },

    }, {timestamps:false,freezeTableName: true});
    return Products;
}
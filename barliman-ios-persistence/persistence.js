var persistence = {};
var Sequelize = require("sequelize");

persistence.start = function() {
    persistence.sequelize = new Sequelize('database', 'root', 'password', {
        host: 'localhost',
        dialect: 'sqlite',

        pool: {
            max: 5,
            min: 0,
            idle: 10000
        },

        // SQLite only
        storage: 'persistence.sqlite'
    });

    persistence.sequelize.authenticate()
        .then(function(err) {
            console.log('Connection has been established successfully.');
        })
        .catch(function (err) {
            console.log('Unable to connect to the database:', err);
        });

    persistence.Project = persistence.sequelize.define('project', {
        id: {
            type: Sequelize.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        deviceId: {
            type: Sequelize.STRING
        },
        codeDefinition: {
            type: Sequelize.STRING
        },
        testInput: {
            type: Sequelize.STRING
        },
        textExpectedOutput: {
            type: Sequelize.STRING
        }
    }, {
        tableName: 'projects'
    });

    persistence.Project.sync({force: true}).then(() => {});
};

module.exports = persistence;
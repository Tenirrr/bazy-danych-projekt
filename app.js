const { Sequelize, DataTypes } = require('sequelize');

const sequelize = new Sequelize('elektron_shop', 'orm', '1234567890', {
    host: 'localhost',
    port: 3307,
    dialect: 'mysql'
});

// Definicja modelu tabeli
const User = sequelize.define('user', {
    user_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
        primaryKey: true,
        autoIncrement: true
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false
    },
    firstname: {
        type: DataTypes.STRING,
        allowNull: false
    },
    lastname: {
        type: DataTypes.STRING,
        allowNull: false
    },
    otp_secret: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    timestamps: false, // Wyłączenie automatycznych kolumn createdAt i updatedAt
    primaryKey: false // Wyłączenie automatycznej kolumny user_id jako klucza głównego
});

// Synchronizacja modelu z bazą danych (tworzenie tabeli, jeśli nie istnieje)
async function syncDatabase() {
    await sequelize.sync({ force: true });
    console.log("Tabela synchronizowana z bazą danych");
}

// Dodawanie rekordu do tabeli
async function addUser(email, password, firstname, lastname, otp_secret) {
    await User.create({email, password, firstname, lastname, otp_secret});
    console.log("Użytkownik dodany do bazy danych");
}

// Pobieranie wszystkich użytkowników z tabeli
async function getAllUsers() {
    const users = await User.findAll({
        attributes: {
            exclude: ['createdAt', 'updatedAt']
        }   
    });
    console.log("Wszyscy użytkownicy:", JSON.stringify(users, null, 2));
}

getAllUsers()

//addUser("x@example.com", "sdf4325j245ji5jp2i45jt6wejorgvu45ttpoj35tpp5", "Jan", "Janmamnaimie", "qwerqwerqwefre3452rgwet25t4tg245")


syncDatabase().then(() => {
    addUser("x@example.com", "sdf4325j245ji5jp2i45jt6wejorgvu45ttpoj35tpp5", "Jan", "Janmamnaimie", "qwerqwerqwefre3452rgwet25t4tg245").then(() => {
        getAllUsers().then(() => {
            // Zakończenie połączenia z bazą danych
            sequelize.close();
        });
    });
})
const pool = require('../../BD/configuracion');

//OBTENER TODOS LOS DEPOSITOS
const getMovements = async(req, res) => {

    let id = req.query.id;
    let idBankAccount = req.query.idBankAccount;
    let movementType = req.query.movementType;

    if (id) {
        const response = await pool.query('SELECT * FROM BANK_MOVEMENT WHERE id = ?', id);

        if (response[0].length < 1) {
            const error = JSON.parse('{"id" : 0 }');
            res.status(200).json(error);
        } else {
            res.status(200).json(response[0]);
        }

    } else if (idBankAccount && movementType) {
        const response = await pool.query('SELECT * FROM BANK_MOVEMENT WHERE idBankAccount = ? AND movementType = ?', [idBankAccount, movementType]);
        if (response[0].length < 1) {
            const error = JSON.parse('{"id" : 0 }');
            res.status(200).json(error);
        } else {
            res.status(200).json(response[0]);
        }
    } else if (idBankAccount) {
        const response = await pool.query('SELECT * FROM BANK_MOVEMENT WHERE idBankAccount = ?', idBankAccount);
        if (response[0].length < 1) {
            const error = JSON.parse('{"id" : 0 }');
            res.status(200).json(error);
        } else {
            res.status(200).json(response[0]);
        }
    } else if (movementType) {
        const response = await pool.query('SELECT * FROM BANK_MOVEMENT WHERE movementType = ?', movementType);
        if (response[0].length < 1) {
            const error = JSON.parse('{"id" : 0 }');
            res.status(200).json(error);
        } else {
            res.status(200).json(response[0]);
        }
    } else {

        const response = await pool.query('SELECT * FROM BANK_MOVEMENT');
        if (response[0].length < 1) {
            const emptyAns = JSON.parse('{"count" : 0 }');
            res.status(200).json(emptyAns);
        } else {
            res.status(200).json(response[0]);
        }

    }
}

const postMovements = async(req, res) => {

    let idBankAccount = req.body.idBankAccount;
    let movementType = req.body.movementType;
    let amount = req.body.amount;

    if (idBankAccount && movementType && amount) {
        const response = await pool.query('SELECT ADD_BANK_MOVEMENT(?,?,?) as i1', [idBankAccount, movementType, amount]);
        if (response[0].length < 1) {
            const emptyAns = JSON.parse('{"count" : 0 }');
            res.status(200).json(emptyAns);
        } else {
            res.status(200).json(response[0][0]);
        }
    }

}

module.exports = {
    getMovements,
    postMovements,
}
const pool = require('../../BD/configuracion');

//OBTENER TODOS LOS DEPOSITOS
const getAccounts = async(req, res) => {

    let idBankAccount = req.query.id;

    if (idBankAccount) {
        const response = await pool.query('SELECT * FROM BANK_ACCOUNT WHERE id = ?', idBankAccount);

        if (response[0].length < 1) {
            const error = JSON.parse('{"id" : 0 }');
            res.status(200).json(error);
        } else {
            res.status(200).json(response[0][0]);
        }

    } else {

        const response = await pool.query('SELECT * FROM BANK_ACCOUNT');
        if (response[0].length < 1) {
            const emptyAns = JSON.parse('{"count" : 0 }');
            res.status(200).json(emptyAns);
        } else {
            res.status(200).json(response[0]);
        }

    }
}

const postAccounts = async(req, res) => {
    let idUserAccount = req.body.idUserAccount;
    let accountType = req.body.accountType;
    let role = req.body.role
    let id = req.body.id;

    if (idUserAccount && accountType && role) {
        const response = await pool.query('SELECT DEFAULT_CREATE_BANK_ACCOUNT(?,?,?) as id', [idUserAccount, accountType, role]);
        if (response[0].length < 1) {
            const emptyAns = JSON.parse('{"id" : 0 }');
            res.status(200).json(emptyAns);
        } else {
            res.status(200).json(response[0]);
        }
    } else if (id) {
        const response = await pool.query('SELECT stateAccount as i1 FROM BANK_ACCOUNT WHERE id = ?', [id]);
        if (response[0].length < 1) {
            const emptyAns = JSON.parse('{"id" : 0 }');
            res.status(200).json(emptyAns);
        } else {
            res.status(200).json(response[0]);
        }
    }
}

module.exports = {
    getAccounts,
    postAccounts,
}
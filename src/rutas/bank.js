const { Router } = require('express');
const router = Router();
const { getAccounts, postAccounts } = require('../controladores/Cbank');
const { getMovements, postMovements } = require('../controladores/Cbank2');

//rutas
router.get('/movements', getMovements);
router.post('/movements', postMovements);
router.get('/accounts', getAccounts);
router.post('/accounts', postAccounts);

module.exports = router;
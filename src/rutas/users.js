const {Router}=require('express');
const router=Router();
const { getAccounts, postAccounts } =require('../controladores/Cusers');


//rutas
router.get('/accounts', getAccounts);
router.post('/accounts', postAccounts);

module.exports = router;
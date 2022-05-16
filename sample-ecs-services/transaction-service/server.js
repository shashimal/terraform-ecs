'use strict';

import express from 'express';

// Constants
const PORT = 3000;
const HOST = '0.0.0.0';
const INTERNAL_ALB='service.internal'


// App
const app = express();
app.get('/health', (req, res) => {
    res.status(200).send('Ok');
});

app.get('/transaction/customer/:customerId', (req, res) => {
    let customerId = req.params['customerId']
    return res.status(200).json({
        customerId: customerId,
        accounts: [
            {
                id: 'C001',
                acNo: 'AC0001',
                type: 'Savings',
                amount: '5000'
            }, {
                id: 'C002',
                acNo: 'AC0002',
                type: 'Fixed Deposit',
                amount: '15000'
            }
        ]
    });
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
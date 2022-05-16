'use strict';
import fetch from 'node-fetch';
import express from 'express'


// Constants
const PORT = 3000;
const HOST = '0.0.0.0';
const INTERNAL_ALB='service.internal'

// App
const app = express();
app.get('/health', (req, res) => {
    res.status(200).send('Ok');
});

app.get('/customers/:customerId', (req, res) => {
    let customerId = req.params['customerId']
    let customerName = 'Nick John'
    getCustomerAccountInfo(req,res,customerId);
});

async function getCustomerAccountInfo (req, res, customerId) {
    let response;
    try {
        response = await fetch(`http://${INTERNAL_ALB}/transaction/customer/${customerId}`)  ;
        let accounts = await response.text();
        res.status(200).json({
            id: customerId,
            name: 'John',
            accounts: JSON.parse(accounts)
        });
    } catch (err) {
        console.log('Http error', err);
        return res.status(500).send();
    }

}

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
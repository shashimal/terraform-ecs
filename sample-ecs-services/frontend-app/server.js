'use strict';
import fetch from 'node-fetch';
import express from 'express'


// Constants
const PORT = 80;
const HOST = '0.0.0.0';

const INTERNAL_ALB='service.internal'
//const INTERNAL_ALB = '127.0.0.1:3000';

const app = express();
app.get('/health', (req, res) => {
    res.status(200).send('Ok');
});

app.get('/customers/:customerId', (req, res) => {
    let customerId = req.params['customerId']
    fetchCustomer(req,res,customerId);
});

async function fetchCustomer (req, res,customerId) {
    let response;
    try {
        response = await fetch(`http://${INTERNAL_ALB}/customers/${customerId}`)  ;
        let data = await response.text();
        console.log(data)
        return res.send(data);
    } catch (err) {
        console.log('Http error', err);
        return res.status(500).send();
    }
}

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
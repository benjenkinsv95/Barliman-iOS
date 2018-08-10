var express = require('express');
var router = express.Router();
var persistence = require('../persistence');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/projects/:deviceId', function(req, res, next) {
    persistence.Project.findOne({ where: {deviceId:  req.params.deviceId} }).then(project => {
        res.json(project);
    })
});

router.post('/projects/:deviceId', function(req, res, next) {
  console.log("Request to create/update device: " + req.params.deviceId);

    persistence.Project.findOne({ where: {deviceId:  req.params.deviceId} }).then(project => {
        if (project) {
            project.codeDefinition = req.body.codeDefinition;
            project.testInput = req.body.testInput;
            project.textExpectedOutput = req.body.textExpectedOutput;
            project.save().then(project => {
              console.log("Updated project successfully.");
                res.json(project);
            })
        } else {
            persistence.Project.create({
                deviceId: req.params.deviceId,
                codeDefinition: req.body.codeDefinition,
                testInput: req.body.testInput,
                textExpectedOutput: req.body.textExpectedOutput
            }).then(project => {
                console.log("Created project successfully.");
                res.json(project);
            });
        }
    });
});



module.exports = router;

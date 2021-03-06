var express = require('express'),
    app = express(),
    nodemailer = require('nodemailer'),
    helper = require('./../../helper'),
    encryption = require('./../../encryption/'),
    language = require('./../../translation'),
    srv_config = require('./../../srv_config.json');

/**
 * Function whichs validates a given mail adress
 * @param  {String} email   the mail adress to validate
 * @return {Boolean}        returns whether or not the mail adress is valid
 */
function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

/**
 * Function which sends mail to specified mail adress
 * @param  {String} mail    the mail adress from the account
 * @param  {String} lng     the specified language
 * @param  {Number} curSoC  the current state of charge, which will be attached as info within mail (with calculated range)
 * @param  {Number} consumption the consumption value to use for range calculation
 * @param  {Boolean} error  whether or not an error occured so we should inform the user
 *                          if this param is not set/false, the success notification will be sent
 */
exports.sendMail = function(mail, lng, curSoC, consumption, error) {
    curSoC = parseInt(curSoC || 0).toString(); // use string for string replacement within translation
    // decrypt and validate mail
    if(validateEmail(encryption.decrypt(mail))) {
        var mailTransporter = nodemailer.createTransport({
                service: srv_config.MAIL_SERVICE,
                auth: {
                    user: srv_config.MAIL_USER,
                    pass: srv_config.MAIL_PASSWORD
                }
            }),
            mailOptions = {
                from: srv_config.MAIL_ADRESS,
                to: encryption.decrypt(mail),
                subject: ((error)? 
                    language.translateWithData('EVNOTIFY_MAIL_ERROR_SUBJECT', lng, {SOC: curSoC}, true) : 
                    language.translateWithData('EVNOTIFY_MAIL_SUBJECT', lng, {SOC: curSoC}, true)),
                text: ((error)? 
                    language.translateWithData('EVNOTIFY_MAIL_ERROR_TEXT', lng, {SOC: curSoC}, true) : 
                    language.translateWithData('EVNOTIFY_MAIL_TEXT', lng, {SOC: curSoC, RANGE: helper.calculateEstimatedRange(parseInt(curSoC), consumption)}, true))
            };

        mailTransporter.sendMail(mailOptions, function(err, mailInfo) {
            if(err) return console.log(err);
        });
    }
};

/**
 * Sends summary of last submitted state of charge to specified mail (e.g. for cron)
 * @param {String} mail the mail where to send the message to
 * @param {String} lng the user language
 * @param {Number} curSoC the current (last submitted) state of charge
 * @param {Number} consumption the consumption of user
 * @param {Number} lastSoC timestamp of last submitted state of charge
 */
exports.sendSummary = function(mail, lng, curSoC, consumption, lastSoC) {
    curSoC = parseInt(curSoC || 0).toString(); // use string for string replacement within translation

    // decrypt and validate mail
    if(validateEmail(encryption.decrypt(mail))) {
        var mailTransporter = nodemailer.createTransport({
            service: srv_config.MAIL_SERVICE,
            auth: {
                user: srv_config.MAIL_USER,
                pass: srv_config.MAIL_PASSWORD
            }
        }),
        mailOptions = {
            from: srv_config.MAIL_ADRESS,
            to: encryption.decrypt(mail),
            subject: language.translateWithData('EVNOTIFY_MAIL_SUBJECT', lng, {SOC: curSoC}, true),
            text: language.translateWithData('TELEGRAM_SOC', lng, {SOC: curSoC, RANGE: helper.calculateEstimatedRange(parseInt(curSoC), consumption), TIME: helper.unixToTimeString(lastSoC)}, true)
        };

        mailTransporter.sendMail(mailOptions, function(err, mailInfo) {
            if(err) return console.log(err);
        });
    }
};

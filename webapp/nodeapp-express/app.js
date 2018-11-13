const express=require('express');
const path=require('path');
const expressValidator=require('express-validator');
const bodyParser=require('body-parser');
const flash=require('connect-flash');
const session = require('express-session');
const bcrypt=require('bcrypt');
const uuid=require('uuid');
const fs = require('fs')
const config = require('dotenv').config()
const AWS = require('aws-sdk')
const winston = require('winston');
AWS.config.update({region: 'us-east-1'});

var logger = new winston.Logger({
  level: 'info',
  transports: [
    new (winston.transports.Console)(),
    new (winston.transports.File)({ filename: '/var/log/customlog.log' })
  ]
});
logger.info("---Logs Initiated---");


const conn=require('./dbconn.js');
const db=new conn();
logger.log("...");
db.connect((err)=>{
  if(err){
    throw err;
  }
  db.query('CREATE DATABASE IF NOT EXISTS '+process.env.DB_NAME, function (err) {// create db if not exist
    if (err) throw err;
    db.query('USE '+process.env.DB_NAME, function (err) {
      if (err) throw err;
      db.query('create table IF NOT EXISTS user('
        + 'uuid VARBINARY(36) NOT NULL,'
        + 'username VARCHAR(255) DEFAULT NULL,'
        + 'password VARCHAR(255) DEFAULT NULL,'
        + 'PRIMARY KEY ( uuid )'
        +  ')', function (err) {
            if (err) throw err;
            logger.log("New USER Table created");
      });
      db.query('create table IF NOT EXISTS transaction('
        + 'tid varbinary(36) NOT NULL,'
        + 'description varchar(45) DEFAULT NULL,'
        + 'amount varchar(45) DEFAULT NULL,'
        + 'category varchar(45) DEFAULT NULL,'
        + 'merchant varchar(45) DEFAULT NULL,'
        + 'date varchar(45) DEFAULT NULL,'
        + 'uuid varbinary(36) NOT NULL,'
        + 'PRIMARY KEY (`tid`)'
        +  ')', function (err) {
            if (err) throw err;
            logger.log("New TRANSACTION Table created");
      });
      db.query('create table IF NOT EXISTS attachment('
        + 'aid varbinary(36) NOT NULL,'
        + 'url varchar(255) DEFAULT NULL,'
        + 'tid varbinary(36) DEFAULT NULL,'
        + 'PRIMARY KEY ( aid ),'
        + 'KEY tid_idx (tid),'
        + 'CONSTRAINT tid FOREIGN KEY (tid) REFERENCES transaction (tid)'
        +  ')', function (err) {
            if (err) throw err;
            logger.log("New ATTACHMENTS Table created");
      });      
    });
  });  
  logger.log("Mysql connected!...");
});

console.log("Enviornment : " + process.env.NODE_ENV)
console.log("Enviornment : " + process.env.DB_PASS)
console.log("Enviornment : " + process.env.DB_NAME)
console.log("Enviornment : " + process.env.DB_HOST)
console.log("Enviornment : " + process.env.DB_USER)


const app=express();

//View Engine
app.set('view engine','ejs');
app.set('views',path.join(__dirname,'views'))

//Body parser middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:false}));

//static file path
app.use(express.static(path.join(__dirname,'public')));

//Define global variables
app.use((req,res,next)=>{
  res.locals.errors=null;
  next();
});


//session
app.use(session({
  secret: 'keyboard cat',
  resave: true,
  saveUninitialized: true
}));
app.use(require('connect-flash')());
app.use((req,res,next)=>{
  res.locals.messages=require('express-messages')(req,res);
  next();
});
app.use(expressValidator());

//Index Routes
app.get('/',(req,res)=>{
  if(req.session.username)
  {
    req.flash('danger','User already logged in!');
    res.redirect('/dashboard');
    res.sendStatus(200)
  }
  else{
    res.render('index');
  }
});
app.get('/logout',(req,res)=>{
  if(req.session.username){
  req.session.username=null;
  logger.log('Logged out');
  req.flash('success','Logged Out!');
  }
  res.render('index');
});
app.get('/dashboard',(req,res)=>{
  if(req.session.username)
  {res.render('dashboard',{id:req.session.username,date:new Date()});}
  else{
    req.flash('danger','User Unauthorized!');
    res.redirect('/');}
});
app.get('/signup',(req,res)=>{
  if(req.session.username)
  {
    req.flash('danger','User already logged in!');
    res.redirect('/dashboard');
  }
  else{
    res.render('signup');
  }
});
app.post('/signup',(req,res)=>{
  if(req.session.username)
  {
    req.flash('danger','User already logged in!');
    res.redirect('/dashboard');
  }
  else{
    req.checkBody('username','Please enter Username!').notEmpty();
    req.checkBody('pass','Please enter Password!').notEmpty();
    var errors=req.validationErrors();
    if(errors){
      res.render('signup',{
        errors:errors
      });
    }
    else{
      var flag=false;
      let sql1="select username from `user` where `username`='"+req.body.username+"'";
      let query1=db.query(sql1,(err,result)=>{
        
        logger.log(result.length);
        if(result.length!=0)
        {
          flag=true;
          logger.log(flag+'--userexist'+err+'|'+result);
          req.flash('danger','User already exist!');
          res.redirect('/signup');
          return null;
        }
        else{
          if(flag===false)
          {
            logger.log(flag);
          const sess=req.session;
          let user={
            username:req.body.username.trim(),
            password:req.body.pass.trim()
          };
          var h=bcrypt.hashSync(req.body.pass,5);
          let saveuuid = uuid();
          logger.log("User ID------>" + saveuuid);
          let sql2="insert into `user` (`uuid`,`username`,`password`)values('"+saveuuid+"','"+req.body.username+"','"+h+"')";
          let query2=db.query(sql2,(err,result)=>{                       
            if(result==='undefined')
            {
              logger.log('notdone'+err);
              req.flash('danger','User not signed!');
              res.render('/signup');
            }
            else{
              logger.log('done2'+result);
              req.flash('success','User signed up! Log In now');
              res.redirect('/');
            }
          });
        }
        }
      });

    }
  }
});

app.get('/transaction',(req,res)=>{
  let q = "select * from `transaction` where `uuid`='"+req.headers.uuid+"'";
  let query2=db.query(q,(err,result)=>{
    res.status(200).send({'error':err,'result':result})    
  });

});

app.post('/transaction',(req,res)=>{   
  let description = req.body.description;
  let amount = req.body.amount;
  let merchant = req.body.merchant;
  let date = req.body.date;
  let category = req.body.category;
  let sql1="SELECT * from `user` where `uuid`='"+req.headers.uuid+"'";
  let query1=db.query(sql1,(err,result)=>{
    logger.log("------>"+result);
    if(result.length!=0){
      if(description && amount && merchant && date && category){
        let saveUuid = uuid()
        logger.log("Transaction ID------>" + saveUuid);
        let sql2="insert into `transaction` (`tid`,`description`,`amount`,`merchant`,`date`,`category`,`uuid`)values('"+saveUuid+"','"+description+"','"+amount+"','"+merchant+"','"+date+"','"+category+"','"+req.headers.uuid+"')";
        let query2=db.query(sql2,(err,result)=>{
        res.status(201).send({'error':err,'result':"Transaction successfully posted !"})
        });
      }
      else{
        res.status(400).send({'error':err,'result':"Some fields are missing or null !"})
      }
      
    }  
    else{
      res.status(401).send({'error':'User not authenticated to delete this transaction !'})
    }  
  });
  
});


app.delete('/transaction/:id',(req,res)=>{
  let sql1="SELECT * from `transaction` where `tid`='"+req.params.id+"'";
  let query1=db.query(sql1,(err,result)=>{
    if(req.params.id){    
    if(result.length!=0 & result[0].uuid == req.headers.uuid){      
      let sql2="DELETE FROM `transaction` WHERE `tid` = '"+req.params.id+"'";
      let query2=db.query(sql2,(err,result)=>{
      res.status(204).send({'error':err,'result':"Transaction successfully deleted !"})
      });
    }  
    else{
      res.status(401).send({'error':'User not authenticated to delete this transaction !'})
    }  
  }
  else{
    res.status(400).send({'error':err,'result':"ID if the transaction to delete is missing !"})
  }
  }); 
});


app.put('/transaction/:id',(req,res)=>{  
  
  logger.log(req.params.id)
  if(req.params.id){
    let sql1="SELECT * from `transaction` where `tid`='"+req.params.id+"'";
    let query1=db.query(sql1,(err,result)=>{
      logger.log("------>"+ typeof result[0].uuid);
      logger.log("------>"+typeof req.headers.uuid);
      if(result.length!=0 && result[0].uuid == req.headers.uuid){
        let sql2='UPDATE `transaction` SET `description`=?,`amount`=?,`merchant`=?,`date`=?,`category`=? where `tid`=?';
        let query2=db.query(sql2,
          [req.body.description,req.body.amount, req.body.merchant,req.body.date,req.body.category, req.params.id]
          ,(err,result)=>{
            res.status(201).send({'error':err,'result':"Transaction successfully updated !"})
        });
      }  
      else{
        res.status(401).send({'error':'User not authenticated to update this transaction !'})
      }  
    });     
  }
  else{
    res.status(400).send({'result':"Bad request !"})
  }
});

//Attachments
app.post('/transaction/:tid/attachments',(req,res)=>{   
  let url = req.body.url;  
  let sql1="SELECT * from `transaction` where `tid`='"+req.params.tid+"'";
  let query1=db.query(sql1,(err,result)=>{    
    if(result.length!=0){

      if(result[0].uuid == req.headers.uuid){
        
        if(url){
          var nameString = url; 
          
          if(process.env.NODE_ENV === "Prod"){
            logger.log("In the production enviornment")
            logger.log(process.emit.key)
            logger.log(process.env.key)
          let s3 = new AWS.S3(process.env.key);
            logger.log(s3)
              
              var filename = nameString.split("/").pop();
              fs.readFile(url, (err, data) => {
                logger.log(data)
                if (err) throw err;
                const params = {
                    Bucket: process.env.BUCKET, // pass your bucket name
                    Key: filename, // file will be saved as testBucket/contacts.csv
                    Body: data,
                    ACL: 'public-read'
                };

                s3.upload(params, function(s3Err, data) {
                    if (s3Err) throw s3Err                    
                    let saveUuid = uuid()
                    logger.log("Attachment ID------>" + saveUuid);
                    let sql2="insert into `attachment` (`aid`,`url`,`tid`)values('"+saveUuid+"','"+data.Location+"','"+req.params.tid+"')";
                    let query2=db.query(sql2,(err,result)=>{
                    res.status(201).send({'error':err,'result':"Attachment for the transaction saved successfully!"})
                    });

                });
             });            

          }
          else if(process.env.NODE_ENV === "Dev"){

            logger.log("In the development enviornment")
            var filename = 'save/'+ nameString.split("/").pop();
            fs.copyFile(url, filename, (err) => {
              if (err) throw err;
              logger.log('source.txt was copied to destination');            
            });        
            let saveUuid = uuid()
            logger.log("Attachment ID------>" + saveUuid);
            let sql2="insert into `attachment` (`aid`,`url`,`tid`)values('"+saveUuid+"','"+filename+"','"+req.params.tid+"')";
            let query2=db.query(sql2,(err,result)=>{
            res.status(201).send({'error':err,'result':"Attachment for the transaction saved successfully!"})
            });
          }else{
            logger.log("not in any enviornment")
          }         

        }
        else res.status(400).send({'error':err,'result':"Url fields are missing or null !"})
        

      }else res.status(401).send({'error':'User not authenticated to delete this transaction !'})   

    }  
    else res.status(401).send({'error':'Transaction does not exist'})     
     
  });
  
});

//Get Attachments related to this transaction
app.get('/transaction/:tid/attachments',(req,res)=>{ 
  let url = req.body.url;  
  let sql1="SELECT * from `attachment` where `tid`='"+req.params.tid+"'";
  let sql2="SELECT * from `transaction` where `tid`='"+req.params.tid+"'"; 

  let query1=db.query(sql2,(err,result)=>{    
    if(result[0].uuid == req.headers.uuid){
      let query = db.query(sql1,(err,results)=>{
        if(results.length!=0){          
          res.status(200).send({'result': results})
      
        }else res.status(401).send({'error':'No attachments for this transaction !'}) 
      })
    }  

    else res.status(401).send({'error':'User not authenticated to get the attachments !'})
      
  });
  
});

//Delete sepecific Attachment related to this transaction
app.delete('/transaction/:tid/attachments/:aid',(req,res)=>{   
  
  let sql2="SELECT * from `transaction` where `tid`='"+req.params.tid+"'"
  let query1=db.query(sql2,(err,result)=>{
    if(result.length!=0){

      if(result[0].uuid == req.headers.uuid){       
        console.log("Tushar")     
        logger.log(process.env.NODE_ENV)
        if(process.env.NODE_ENV === "Prod"){

            let sql1="SELECT * from `attachment` where `aid`='"+req.params.aid+"'";
            let query1=db.query(sql1,(err,result1)=>{
              if(err) throw err
              
              if(result1.length!=0){               
                var filename = result1[0].url.split("/").pop();
                let s3 = new AWS.S3(process.env.key);
                var params = {
                    Bucket: process.env.BUCKET,
                    Key: filename
                };
                s3.deleteObject(params, function (err, data) {
                  if(err) throw err
                  if (data) {
                    let sql3="DELETE from `attachment` where `aid`='"+req.params.aid+"'";
                    let query1=db.query(sql3,(err,result1)=>{
                      if (err) throw err;
                      
                      res.status(204).send("Attachment successfully deleted");
                      
                      
                    });
                  }
                  else res.status(401).send({"error": err,"result":"You do not have permission to delete file in S3 !"});
                  
                });
              }else res.status(401).send({'error':err,'result':"This specific attachment does not exist"})             
            });            
          }

            else if(process.env.NODE_ENV === "Dev"){
                console.log("In the development enviornment")                 
                let sql1="SELECT * from `attachment` where `aid`='"+req.params.aid+"'";
                let query1=db.query(sql1,(err,result1)=>{ 
                    if(err) throw err
                    if(result1.length!==0){
                      var filename = 'save/' + result1[0].url.split("/").pop();
                      fs.unlink(filename, (err) => {
                        if (err) throw err;
                        else{
                          let sql3="DELETE from `attachment` where `aid`='"+req.params.aid+"'";
                          let query1=db.query(sql3,(err,result1)=>{
                            if (err) throw err;
                            res.status(204).send("Attachment successfully deleted");
                          });
                        }                   
                      });
                    }
                }); 
                
            }else{
            console.log("not in any enviornment")
        }  
      
      }else res.status(401).send({'error':'User not authenticated to delete this transaction !'})   

    }else res.status(401).send({'error':'Transaction does not exist'}) 
  
});

  
});



//Update Attachments related to this transaction
app.put('/transaction/:tid/attachments/:aid',(req,res)=>{   
  console.log("Test1")
  var url = req.body.url
  let sql2="SELECT * from `transaction` where `tid`='"+req.params.tid+"'"
  let query1=db.query(sql2,(err,result)=>{
    if(result.length!=0){

      if(result[0].uuid == req.headers.uuid){            
        
        if(url){          
              
                if(process.env.NODE_ENV === "Prod"){
                    let sql1="SELECT * from `attachment` where `aid`='"+req.params.aid+"'";
                    let query1=db.query(sql1,(err,result1)=>{
                      
                      if(err) throw err
                      var filename = result1[0].url.split("/").pop();
                      if(result1.length!=0){               
                      let s3 = new AWS.S3(process.env.key);
                        var params = {
                            Bucket: 'csye6225-fall2018-sharmaha.me.csye6225.com',
                            Key: filename,                            
                        };
                        s3.deleteObject(params, function (err, data) {
                          if(err) throw err
                          if (data) {
                            let sql3="DELETE from `attachment` where `aid`='"+req.params.aid+"'";
                            let query1=db.query(sql3,(err,result1)=>{
                              if (err) throw err;
                              var filename = url.split("/").pop();
                              fs.readFile(url, (err, data) => {
                                logger.log(data)
                                if (err) throw err;
                                const params = {
                                    Bucket: process.env.BUCKET, // pass your bucket name
                                    Key: filename, // file will be saved as testBucket/contacts.csv
                                    Body: data,
                                    ACL: 'public-read'
                                };
                                s3.upload(params, function(s3Err, data) {
                                    if (s3Err) throw s3Err                    
                                    let saveUuid = uuid()
                                    logger.log("Attachment ID------>" + saveUuid);
                                    let sql2="insert into `attachment` (`aid`,`url`,`tid`)values('"+saveUuid+"','"+data.Location+"','"+req.params.tid+"')";
                                    let query2=db.query(sql2,(err,result)=>{
                                    res.status(201).send({'error':err,'result':"New attachment for the transaction saved successfully!"})
                                    });

                                });
                              }); 

                            });
                          }
                          else res.status(401).send({"error": err,"result":"You do not have permission to delete file in S3 !"});
                          
                        });
                      }else res.status(401).send({'error':err,'result':"This specific attachment does not exist"})             
                    });            
                  }

                    else if(process.env.NODE_ENV === "Dev"){
                        logger.log("In the development enviornment")                 
                        let sql1="SELECT * from `attachment` where `aid`='"+req.params.aid+"'";
                        let query1=db.query(sql1,(err,result1)=>{ 
                            if(err) throw err
                            if(result1.length!==0){
                              var filename = 'save/' + result1[0].url.split("/").pop();
                              fs.unlink(filename, (err) => {
                                if (err) throw err;
                                else{
                                  let sql3="DELETE from `attachment` where `aid`='"+req.params.aid+"'";
                                  let query1=db.query(sql3,(err,result1)=>{
                                    if (err) throw err;
                                    var filename = 'save/'+ url.split("/").pop();
                                    fs.copyFile(url, filename, (err) => {
                                      if (err) throw err;
                                      logger.log('source.txt was copied to destination');            
                                    });        
                                    let saveUuid = uuid()
                                    logger.log("Attachment ID------>" + saveUuid);
                                    let sql2="insert into `attachment` (`aid`,`url`,`tid`)values('"+saveUuid+"','"+filename+"','"+req.params.tid+"')";
                                    let query2=db.query(sql2,(err,result)=>{
                                    res.status(201).send({'error':err,'result':"New attachment for the transaction saved successfully!"})
                                    });
                                  });
                                }                   
                              });
                            }
                        }); 
                        
                    }else{
                    logger.log("not in any enviornment")
                }  

              }
            else res.status(400).send({'error':err,'result':"Url fields are missing or null !"})
      
      
      }else res.status(401).send({'error':'User not authenticated to delete this transaction !'})   

    }else res.status(401).send({'error':'Transaction does not exist'}) 
  
});

  
});



//Route Files
let login=require('./routes/login');
app.use('/login',login);

//Start Server
app.listen('3000',()=>{
  console.log('Server started on 3000')
});

//user password reset
app.get('/reset',(req,res)=>{
  var uuid = req.headers.uuid

  var useremail = "gupt.tus@husky.neu.edu";
  
    var msg = useremail+"|"+process.env.EMAIL_SOURCE+"|"+process.env.DDB_TABLE+"|"+req.get('host');
    logger.log("Message is --> " + msg)
    var params = {
      Message: msg, /* required */
      TopicArn:process.env.TOPIC_ARN
    };
    var sns = new AWS.SNS();
    sns.publish(params, function(err, data) {
      if (err) logger.info(err, err.stack); // an error occurred
      else{
        logger.log(data);        
      }           // successful response
    });
  
});


  

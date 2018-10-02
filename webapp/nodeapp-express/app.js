const express=require('express');
const path=require('path');
const expressValidator=require('express-validator');
const bodyParser=require('body-parser');
const flash=require('connect-flash');
const session = require('express-session');
const bcrypt=require('bcrypt');



const conn=require('./dbconn.js');
const db=new conn();
console.log("...");
db.connect((err)=>{
  if(err){
    throw err;
  }
  console.log("Mysql connected!...");
});

//db.connect((err)=>{
//  if(err){
//    throw err;
//  }
//  console.log("Mysql connected!...")
//});

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
  }
  else{
    res.render('index');
  }
});
app.get('/logout',(req,res)=>{
  if(req.session.username){
  req.session.username=null;
  console.log('Logged out');
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
        console.log(result.length)
        if(result.length!=0)
        {
          flag=true;
          console.log(flag+'--userexist'+err+'|'+result);
          req.flash('danger','User already exist!');
          res.redirect('/signup');
          return null;
        }
        else{
          if(flag===false)
          {
            console.log(flag);
          const sess=req.session;
          let user={
            username:req.body.username.trim(),
            password:req.body.pass.trim()
          };
          var h=bcrypt.hashSync(req.body.pass,5);
          let sql2="insert into `user` (`username`,`password`)values('"+req.body.username+"','"+h+"')";
          let query2=db.query(sql2,(err,result)=>{
            if(result==='undefined')
            {
              console.log('notdone'+err);
              req.flash('danger','User not signed!');
              res.render('/signup');
            }
            else{
              console.log('done2'+result);
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

  let q = "select * from `transaction`";
  let query2=db.query(q,(err,result)=>{
    res.send({'error':err,'result':result})
  });

});

app.post('/transaction',(req,res)=>{
  
  let description = req.body.description;
  let amount = req.body.amount;
  let merchant = req.body.merchant;
  let date = req.body.date;
  let category = req.body.category;
  let sql2="insert into `transaction` (`description`,`amount`,`merchant`,`date`,`category`)values('"+description+"','"+amount+"','"+merchant+"','"+date+"','"+category+"')";
  let sql3 = sql2 + "values('"+description+"','"+amount+"','"+merchant+"','"+date+"','"+category+"',)";
  console.log(sql2);  
  let query2=db.query(sql2,(err,result)=>{
    res.send({'error':err,'result':result})
  });

});

app.delete('/transaction/:id',(req,res)=>{
  console.log(req.params.id);
  let sql2="DELETE FROM `transaction` WHERE id = 1";
  let query2=db.query(sql2,(err,result)=>{
    res.send({'error':err,'result':result})
  });

});

app.put('/transaction/:id',(req,res)=>{  
  let sql2='UPDATE `transaction` SET `description`=?,`amount`=?,`merchant`=?,`date`=?,`category`=? where `id`=?';
  let query2=db.query(sql2,
    [req.body.description,req.body.amount, req.body.merchant,req.body.date,req.body.category, req.params.id]
    ,(err,result)=>{
    res.send({'error':err,'result':result})
  });

});


//Route Files
let login=require('./routes/login');
app.use('/login',login);

//Start Server
app.listen('3030',()=>{
  console.log('Server started on 3030')
});

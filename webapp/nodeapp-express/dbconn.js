const mysql=require('mysql');
var db=null;
module.exports=function(){
  if(!db){
    db=mysql.createConnection({
      host:'localhost',
      user:'root',
      password:'qqXtrp%5gMtr',
      database:'nodemysql'
    });
  }
  return db;
};

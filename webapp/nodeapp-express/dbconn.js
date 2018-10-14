const mysql=require('mysql');
var db=null;
module.exports=function(){
  if(!db){
    db=mysql.createConnection({
      host:'localhost',
      user:'root',
      password:'asdASD12!@',
     database:'nodemysql'
    });
  }
  return db;
};

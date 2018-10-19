const mysql=require('mysql');
var db=null;
module.exports=function(){
  if(!db){
    db=mysql.createConnection({
      host:'localhost',
      user:'root',
      password:'May#1991',
     database:'nodemysql'
    });
  }
  return db;
};

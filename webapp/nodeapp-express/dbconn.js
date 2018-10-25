const mysql=require('mysql');
var db=null;
module.exports=function(){
  if(!db){
    db=mysql.createConnection({
      // host:'ec2-54-166-255-22.compute-1.amazonaws.com'
      host:process.env.DB_HOST,
      user:process.env.DB_USER,
      password:process.env.DB_PASS,
     database:process.env.DB_NAME
    });
  }
  return db;
};

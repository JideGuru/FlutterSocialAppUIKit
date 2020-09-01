function initFirebase() {
  // Your web app's Firebase configuration
  var firebaseConfig = {
    apiKey : "AIzaSyCbTbTvlK9YuaNriYEgx2HShsuL1KUcBfQ",
    authDomain : "le-chat-3111c.firebaseapp.com",
    databaseURL : "https://le-chat-3111c.firebaseio.com",
    projectId : "le-chat-3111c",
    storageBucket : "le-chat-3111c.appspot.com",
    messagingSenderId : "849813935559",
    appId : "1:849813935559:web:ca112306fafbfd4f84f5e2",
    measurementId : "G-HQZ317GY8G",
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
  firebase.analytics();
}

initFirebase();

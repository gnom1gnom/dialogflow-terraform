import React from "react";
import { Card, Navbar } from "react-bootstrap";
import "./App.scss";
import { MessageFrame } from "./chatbot/MessageFrame";

function App() {
  return (
    <div className="App">
      <Navbar bg="dark" className="app-navbar">
        <Navbar.Brand as="h1" className="app-navbar">
          Dialogflow Example
        </Navbar.Brand>
      </Navbar>
      <div className="app-content">
        <Card className="app-card">
          <Card.Body>
            <Card.Title>Welcome to the demonstration</Card.Title>
            <Card.Text>
              Did I really spend my entire morning just putting this website
              together, and writing infrastructure code to deploy it?
              <br />
              You bet I did, all just to demonstrate something I could have
              demonstrated by serving locally.
            </Card.Text>
          </Card.Body>
        </Card>
        <MessageFrame isOpen />
      </div>
    </div>
  );
}

export default App;

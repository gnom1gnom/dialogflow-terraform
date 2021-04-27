import React from "react";
import "./App.css";
import { MessageFrame } from "./chatbot/MessageFrame";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <MessageFrame isOpen />
      </header>
    </div>
  );
}

export default App;

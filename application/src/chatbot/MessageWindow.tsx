import React, { useRef, useEffect } from "react";
import { IMessage } from "../types";
import "./Form.scss";

export interface IMessageWindowProps {
  messages: IMessage[];
}

const getMessageClassName = (sender: "bot" | "user"): string => {
  if (sender === "bot") {
    return "chatbot-message chatbot-message-bot";
  }
  return "chatbot-message chatbot-message-user";
};

export const MessageWindow: React.FC<IMessageWindowProps> = ({
  messages,
}: IMessageWindowProps): JSX.Element => {
  const messagesEndRef = useRef<null | HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  return (
    <div className="chatbot-messages">
      {messages.map((message: IMessage, i: number) => {
        return (
          <span className={getMessageClassName(message.sender)} key={i}>
            {message.message}
          </span>
        );
      })}
      <div ref={messagesEndRef} />
    </div>
  );
};

import React, { useEffect, useState } from "react";
import { PostMessage } from "../services/PostChat";
import { IMessage, IMessageResponse } from "../types";
import { MessageInput } from "./MessageInput";
import { MessageWindow } from "./MessageWindow";
import { v4 as uuidv4 } from "uuid";
import "./Form.scss";

export interface IFrameProps {
  isOpen: boolean;
}

export const MessageFrame: React.FC<IFrameProps> = ({
  isOpen,
}: IFrameProps): JSX.Element => {
  const [session, setSession] = useState<string>(uuidv4());
  const [messages, setMessages] = useState<IMessage[]>([]);

  useEffect(() => {
    setSession(uuidv4());
  }, [isOpen]);

  const addUserMessage = (text: string): void => {
    setMessages((messages: IMessage[]) => [
      ...messages,
      { message: text, sender: "user" },
    ]);
  };

  const addBotMessages = (response: IMessageResponse): void => {
    setMessages((messages: IMessage[]) => [
      ...messages,
      ...response.messages.map(
        (message: string): IMessage => {
          return {
            message: message,
            sender: "bot",
          };
        }
      ),
    ]);
  };

  const userSendMessage = (text: string): void => {
    addUserMessage(text);
    PostMessage({ message: text, sessionId: session }).then(addBotMessages);
  };

  return (
    <div className="chatbot-window">
      <MessageWindow messages={messages} />
      <MessageInput onSendMessage={userSendMessage} />
    </div>
  );
};

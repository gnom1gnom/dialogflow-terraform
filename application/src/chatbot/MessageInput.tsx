import React, { useState } from "react";
import Form from "react-bootstrap/Form";
import Button from "react-bootstrap/Button";
import Col from "react-bootstrap/esm/Col";
import "./Form.scss";

export interface IMessageInputProps {
  onSendMessage: (message: string) => void;
}

export const MessageInput: React.FC<IMessageInputProps> = (
  props: IMessageInputProps
) => {
  const [message, setMessage] = useState("");

  const onSubmit = (e: React.FormEvent): void => {
    e.preventDefault();
    props.onSendMessage(message);
    setMessage("");
  };

  const onInputChange = (e: React.ChangeEvent<HTMLInputElement>): void => {
    setMessage(e.currentTarget.value);
  };

  return (
    <Form className="chatbot-input" onSubmit={onSubmit}>
      <Form.Row>
        <Col>
          <Form.Control size="sm" onChange={onInputChange} value={message} />
        </Col>
        <Col xs="auto">
          <Button type="submit" size="sm">
            Send
          </Button>
        </Col>
      </Form.Row>
    </Form>
  );
};

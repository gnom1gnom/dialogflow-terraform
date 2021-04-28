import axios, { AxiosResponse } from "axios";
import { IMessageRequest, IMessageResponse } from "../types";

export const PostMessage = async (
  message: IMessageRequest
): Promise<IMessageResponse> => {
  return await axios
    .post(
      "https://europe-west2-arctic-moon-312018.cloudfunctions.net/chatbot-function",
      message
    )
    .then((resp: AxiosResponse<IMessageResponse>) => {
      return resp.data;
    });
};

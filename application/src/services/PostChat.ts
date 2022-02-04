import axios, { AxiosResponse } from "axios";
import { IMessageRequest, IMessageResponse } from "../types";

export const PostMessage = async (
  message: IMessageRequest
): Promise<IMessageResponse> => {
  return await axios
    .post(
      "https://europe-west2-dialogflowdemo-340213.cloudfunctions.net/chatbot-function",
      message
    )
    .then((resp: AxiosResponse<IMessageResponse>) => {
      return resp.data;
    });
};

import axios, { AxiosResponse } from "axios";
import { IMessageRequest, IMessageResponse } from "../types";

export const PostMessage = async (
  message: IMessageRequest
): Promise<IMessageResponse> => {
  return await axios
    .post(
      "https://europe-west2-crazy-cats-123.cloudfunctions.net/chatbot-api",
      message
    )
    .then((resp: AxiosResponse<IMessageResponse>) => {
      return resp.data;
    });
};

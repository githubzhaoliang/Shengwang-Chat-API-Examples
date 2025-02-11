# API Example Web

_English | [中文](README.zh.md)_

## Overview

The repository contains sample projects that implement single Chat using the Shengwang Chat SDK.

## Project structure

The project uses a single app to combine a variety of functionalities.

| Function                | Location                                         |
| ----------------------- | ------------------------------------------------ |
| The page content        | [index.html](./index.html)                       |
| Sending text messages   | [index.js](./src/index.js)                       |
| Sending a Voice Message | [sendAudioMessage.js](./src/sendAudioMessage.js) |
| The recording           | [recordAudio.js](./utils/recordAudio.js)         |
| Get conversation list   | [conversationList.js](./src/conversationList.js) |
| Get historical messages | [conversationList.js](./src/conversationList.js) |

## How to run the sample project

### Prerequisites

- A valid Shengwang Chat developer account.
- [Create the Shengwang Chat project and get the appId](https://console.shengwang.cn/overview) 。
- [npm](https://www.npmjs.com/get-npm)
- SDK supports Internet explorer 11+, FireFox10+, Chrome54+, Safari6+ text, expression, picture, audio, address messages sent to each other.

### Steps to run

1. Replace your own appId
   Replace 'your appId' in the src/index.js file with your own appId.

2. Install dependencies

```bash
  npm install
```

3. Start the project

```bash
  npm run start
```

4. Open your browser to https://localhost:9000 and run the project.

You are all set! Feel free to play with this sample project and explore features of the Shengwang Chat SDK.

## Frequently asked questions

Why does the error digital envelope routes:: unsupported occur when running a the project locally?

The project in this article is packaged through webpack and runs locally. Due to changes in the dependency on OpenSSL in Node.js 16 and above versions, it has affected the dependency on the local development environment in the project (see [webpack issue](https://github.com/webpack/webpack/issues/14532) for details)
）Running the project will result in errors. The solution is as follows:

- (Recommended) Run the following command to set temporary environment variables:

```Bash
export NODE_OPTIONS=--openssl-legacy-provider
```

- Temporarily switch to a lower version of Node.js.

Then try running the project again.

## Feedback

If you have any problems or suggestions regarding the sample projects, feel free to file an issue.

## Reference

- [Shengwang Chat SDK Product Overview](https://im.shengwang.cn/)
- [Shengwang Chat SDK API Reference](https://im.shengwang.cn/sdkdocs/chat1.x/web/)

## Related resources

- Check our [FAQ](https://doc.shengwang.cn/faq/list) to see if your issue has been recorded.
- Dive into [Shengwang SDK Samples](https://github.com/Shengwang-Lab) to see more tutorials
- Take a look at [Shengwang Use Case](https://github.com/AgoraIO-usecase) for more complicated real use case
- Repositories managed by developer communities can be found at [Shengwang Community](https://github.com/Shengwang-Lab)
- If you encounter problems during integration, feel free to ask questions in [Stack Overflow](https://stackoverflow.com/questions/tagged/agora.io)

## License

The sample projects are under the MIT license.

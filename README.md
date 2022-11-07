# StudentSocietyDAO
## 如何运行

1. 在本地启动ganache应用，创建新环境，

   由于合约中包含了ERC20和ERC721，导致合约比较臃肿，调用函数需花费较多Gas

   **不能使用QuickStart，因为默认Gas Limit是6721975，不够多**

   **一定要在创建Workspace时将Gas Limit调高，经测试672197500可以完美运行**

2. 在 `./contracts` 中安装需要的依赖，运行如下的命令：

   ```bash
   npm install
   ```

3. 在 `./contracts/hardhat.config.ts`中配置好部署信息

   ```json
   networks: {
       ganache: {
         url: 'http://localhost:7545'	//这里填Ganache中RPC Server地址和端口
         accounts: [
           '0xee51ad27563ccc0ee1f21880c2bea35b0648df7d46a72cd98ed6c488a9599294',	//这里填上一个Ganache中有钱的用户的私钥
         ]
       },
     },
   ```

4. 在 `./contracts` 中编译并部署合约到ganache上，运行如下的命令：

   ```bash
   npx hardhat run scripts/deploy.ts --network ganache
   ```

5. 将控制台中输出的studentDAO合约地址复制到`./frontend/src/utils/contract-addresses.json`中

6. 将编译生成的合约abi拷贝到前端中

   即将`./contracts/artifacts/contracts/StudentSocietyDAO/StudentSocietyDAO.sol/StudentSocietyDAO.json`

   复制到`./frontend/src/utils/abis/StudentSocietyDAO.json`

7. 在 `./frontend` 中启动前端程序，运行如下的命令：

   ```bash
   npm run start
   ```

## 功能实现分析

简单描述：项目完成了要求的哪些功能？每个功能具体是如何实现的？

建议分点列出。

1. 每个学生可以在“我的用户”界面绑定钱包

   ​	该功能通过window对象里小狐狸注入的ethereum对象提供的request方法实现

   ​	钱包地址存储在main.js中，作为全局变量使用

   ​	钱包地址是每个学生的唯一标识，以下功能都需要连接钱包才能进行使用

2. 点击左侧侧边栏，可以进入不同界面

   ​	通过router和点击回调函数实现

3. 在“使用说明”界面，可以查看该项目的简单介绍

   ​	这是一个纯文本组件

4. 在“我的用户”界面，每个学生可以领取10点初始积分，仅限领取一次

   ​	“领取初始积分”按钮绑定有回调函数，回调函数会以send方法调用合约中airdrop方法

   ​	合约中airdrop方法会先判断用户是否领取过积分，若未领取过则调用学生积分MyERC20中的mint方法铸币，然后将该地址标记为已领取

5. 在“当前提案”界面，每个学生可以查看当前所有活跃（可投票的）提案，包括提案标题，提案内容，赞成数和反对数

   ​	合约内部写一个函数，以数组形式返回所有提案的相关信息

   ​	**合约内部再写一个函数，更新活跃提案的状态，判断其是否已结束，以下称之为状态刷新**

   ​	该界面的组件在加载时会先以send方法更新所有活跃提案状态，再以call方法读取所有活跃提案，再放入表格中

6. 在“当前提案”界面，每个学生可以使用1点积分新建提案

   ​	合约内部写一个函数，接受两个参数：提案名和提案内容。

   ​	先判断学生是否有充足积分，如果积分充足，则通过burn方法扣除积分，然后将该提案初始化并加入mapping中

   ​	**为方便实验，提案默认活跃时间`default_duration`为120秒，在实际使用中可以换成2天等比较合适的时间**

7. 在“当前提案”界面，每个学生可以使用1点积分对活跃提案投票

   ​	合约内部写一个函数，接受两个参数：提案index和赞同/反对。

   ​	先判断学生是否有充足积分，如果积分充足，则通过burn方法扣除积分，然后从mapping中找出该提案，对其中的赞同数/反对数加一

8. 当提案结束时，赞同数大于反对数的提案会被通过，提案发起人将收到`赞同数+反对数-1`数量的积分

   ​	在状态刷新时执行

9. 在“已完成的提案”中，学生可以查看所有已经结束的提案

   ​	进入该页面时，先执行状态刷新，再获得数据

10. 在“小礼品”界面，发起提案并通过3次的学生，可以领取社团颁发的非同质化代币纪念品

    ​	进入该页面，先执行状态刷新，再获得数据

    ​	使用ERC721相关接口实现

    ​	符合要求的用户可以输入纪念品内容，提交后会得到独一无二的纪念品ID

    ​	纪念品ID和纪念品内容会显示在该页面

## 项目运行截图

1. 连接钱包
![1.png](https://s2.loli.net/2022/11/07/5IDTzAF9aYB7e1q.png)
2. 领取初始积分
![2.png](https://s2.loli.net/2022/11/07/a5Zetj9lrhqNbKY.png)
3. 新建提案
![3.png](https://s2.loli.net/2022/11/07/yluU7iLKgH1ePk2.png)
4. 投赞同/反对票
![4.png](https://s2.loli.net/2022/11/07/lBOmpuRZkoKqxeg.png)
5. 查看已完成提案
![5.png](https://s2.loli.net/2022/11/07/UvYsuXRNZfj1cTo.png)
6. 领取纪念品
![6.png](https://s2.loli.net/2022/11/07/ZIibL3KcAEOkSsB.png)
7. 查看纪念品
![7.png](https://s2.loli.net/2022/11/07/QjZX3gdKOGuDYez.png)
   

## 参考内容

课程的参考Demo见：[DEMOs](https://github.com/LBruyne/blockchain-course-demos)。

如果有其它参考的内容，也请在这里陈列。
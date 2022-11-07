<template>
    <a-typography-title>介绍</a-typography-title>
        <a-typography-title :level="3">当前提案</a-typography-title>
        <a-typography-paragraph>
            在该界面，用户可以查看当前活跃的提案，并向这些提案投赞成票或反对票
        </a-typography-paragraph>
        <a-typography-paragraph>
            在页面左上方有新建提案按钮，点击后会显示表单
            用户可以在表单内填写提案内容，填写完毕后消耗 1 个代币即可发布
        </a-typography-paragraph>
        <a-typography-paragraph>
            投票时间默认为2天，在本实验中更改为默认20分钟。
            当投票时间截止后，赞成票多于反对票的提案会被通过
            当提案通过时，提案发起人将会获得（赞同数+反对数-1）数量的代币
        </a-typography-paragraph>

    <a-typography-title :level="3">已完成的提案</a-typography-title>
        <a-typography-paragraph>
            在该界面，用户可以查看已截止投票的提案
        </a-typography-paragraph>

    <a-typography-title :level="3">我的用户</a-typography-title>
        <a-typography-paragraph>
            在该界面，用户可以使用MetaMask进行登录
            登录后可以查看当前余额
            新用户可以在该界面领取 10 点初始积分
        </a-typography-paragraph>

    <a-typography-title :level="3">小礼品</a-typography-title>
        <a-typography-paragraph>
            在该界面，发起提案并通过三次以上的用户可以领取一个ERC721纪念品
            纪念品包括用户填写的纪念品内容和一个独一无二的纪念品ID
        </a-typography-paragraph>
</template>
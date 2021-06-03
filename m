Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558EA39A0DB
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFCMbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:31:01 -0400
Received: from mail-eopbgr60109.outbound.protection.outlook.com ([40.107.6.109]:44654
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230155AbhFCMbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:31:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auOowhG1/NY2cDOE47nEyboflAwF3wIFxQIlGX0YEOf30ZkPsjH7qtd0iJR78a4Jr2dNPePZEeHtQxkypMJA4592qOT6jbQ4ejl3AJbkiXVNGol6u2BdQuwv41KZqPY9421KbxMAlYDv7S+hPtVkUZ+nNh3oDwSvcyHI8J5CKH8bs1lM1s62izhQk2ufbdFtnKuHAQjT7e8eRojZhdS67PT/3lqMiKyDnXxFZVpt/0xzeaLBQmrm/ZvMO1/HAbUS8y7TYDD/cxPQhRejwkhlAP/fvlkVpYBGcsscTnGF/YgA86udE3V5ynlZ7pt7NBwiPwjb/mXc4dCuhOc4xoAhGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RYnXFW0oEzuHfiakC7o9zWRvken7NLBJ/RdDZnwcec=;
 b=aPQPw4jz8Gll4qfzTFraMfbhw7x56ogQhnpimJOFqYXOJKSsGab6zgx5O18MUEerSW9CteiXTlvi5bHEDiX1JLp5GG8ZsaYTXUpIN5TljcfNpiyfrQldwCOF+HzMySRd/pNPK6sVnRApzScvUDdWD9OgBQIdUWcHBacmCLOCPX2UghWabOfAE3IzeiEmSMVSomj0dvoJYPZ+nrzdK+QTFcvpLH2w8y+apj+vX6r4YXSyv0Ex1UXIkyyPul+cCAH7EjrVRr8RrfLfSsh5UTzIVgDbtzfKd685RBHtkswRQT6FkezSAoBThjyl/E1To5kSrz45CgCqxBOGgaNRctgEWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RYnXFW0oEzuHfiakC7o9zWRvken7NLBJ/RdDZnwcec=;
 b=P3h26o3k6xe2IhQte51XVzwAnH5zsxaEDi0LheXp1GIJ9OhPuZ6u5cc12VUYqTeRgz0qPC7fQmXfj0gZWOOcVgQyETVYJhrKeg2zWVFQvNadckEOHY0+AYq5ZvD2ZIghKR6okjjn4d1Hl5g7pWJfTnrV92N8kfQcIwAJPIU0rBU=
Authentication-Results: openvz.org; dkim=none (message not signed)
 header.d=none;openvz.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM7PR08MB5494.eurprd08.prod.outlook.com (2603:10a6:20b:dc::15)
 by AM6PR08MB5127.eurprd08.prod.outlook.com (2603:10a6:20b:e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 3 Jun
 2021 12:29:15 +0000
Received: from AM7PR08MB5494.eurprd08.prod.outlook.com
 ([fe80::f928:f4f2:77c0:74b4]) by AM7PR08MB5494.eurprd08.prod.outlook.com
 ([fe80::f928:f4f2:77c0:74b4%7]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 12:29:15 +0000
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
To:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Message-ID: <bfa92991-94c8-6212-0a42-9b5b01bcca05@virtuozzo.com>
Date:   Thu, 3 Jun 2021 15:29:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.215.60.243]
X-ClientProxiedBy: AM0PR02CA0029.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::42) To AM7PR08MB5494.eurprd08.prod.outlook.com
 (2603:10a6:20b:dc::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.100.8] (185.215.60.243) by AM0PR02CA0029.eurprd02.prod.outlook.com (2603:10a6:208:3e::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 12:29:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16ed2311-595b-4c02-53c7-08d9268b3301
X-MS-TrafficTypeDiagnostic: AM6PR08MB5127:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB512715CD26B4E213FAC734F6C13C9@AM6PR08MB5127.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L5Qvatqv0fEnaZYppxsFB8qay6Y+MYm+m/mmDQv2F+bgslOvSUhu/zSgZveVX/O1anI7ygS+/cYbQD8Y90XvT1vMJ5JvNe4fCZSa6P6A5B4GsGUe3Q9nDNcDRbYdb4SmBz34P0bNtDH2gmS/Ccza3enKXMd72ZeOvG/OCnHEcP7CNpED/UmfHW7BS4YIajDA1OoYZBZ3Ogtney4GHAsLPZYy6WXYUJvwwkBb2j/hmvxmPxK6kFwCOFgixuyJHIij+5OprjF451dxz1IIpwsUqTeRSLQDNe9ZFMKtoJz2ow3dTMslYAd3w+vmB4pK0Bb+C2cIj1y/RGJcauGazPCVD71SH2lSAULTFGr+fSaVZhCC5rQf5KeM11/JmRd9myBpqaTZ5vh6e0LOvtRrsYbboS+yCBHphqEx/btpXa0lKNJm2c9gSPfnm1+qIvmIn8T90G7qkPvu8abpQAm+VN3rMkKySlNJkSRAS36sjqpqGYQzt64mLSZ54xdxsKcnM3uEFXTp50qkemrgOaqmfEEmy+4UxPdjOUhWMpAgFy7kjS78Mqh7svh14xltXGKRIWC+tBiC9jAxv7L/wE6u1ELDO2pVYLka9T5hptFnFlRgT1MQFRZJInoP2EaxDUFnRGtIJ7o/p6G2zAvhTSNqQOvfLYvumxalyZ5cJhudaOjwFb4m8zlX7SFlH3NPJRYV3lelsSG3LFzWzVr9GaZfH2gK8qYUJTyjLH+C4F6n12FKDRM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5494.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39840400004)(366004)(376002)(396003)(38350700002)(38100700002)(956004)(6486002)(31686004)(7416002)(31696002)(316002)(107886003)(8676002)(8936002)(2616005)(66946007)(186003)(478600001)(54906003)(66476007)(5660300002)(52116002)(4326008)(26005)(86362001)(36756003)(2906002)(16576012)(83380400001)(66556008)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?amFyaXYrRFB4Lzcyb2l0dkV4TCtLT0J0V0lzTHhUY1RyOGRSV3ZoYmN6T2lh?=
 =?utf-8?B?cmFXTnAvN0hWOERMSE5xVDhjeEwvV0t2QkZhRkFWS1NoTEhLVTU5UkpwV212?=
 =?utf-8?B?a0lnWnYrMTgzVk84Ym5jQ2RPNnJrU3FLRTBMZ2d5ZVJCejNIUmFOcGpLdEN0?=
 =?utf-8?B?Q09UOHcrUUluK29XWFUxbks1VDh1RkZtQ0dLb3BKT2pGVEhYaXplcVJUdGFR?=
 =?utf-8?B?aENUS29Nb2Rla2NqNjNoSVhBVERjNzUraTdMVlIxN2d4a3JmY0o1WlJMU3g4?=
 =?utf-8?B?WDJQSUU3bGpKeWdpVlMvaFJZQ050MXFMdU5CMm1VZFVzQzNKYjRqeEQ4cGhn?=
 =?utf-8?B?WnZKaFQ2QllrTDVMc3Y1dGNnVWJyQjNJTk9meHdoQm96RkIxVFFtQ3BTc2h2?=
 =?utf-8?B?Q042bFB3VU8rT2s2MDR3ZlN6MTJXQ3RwU0szU3lzTFI2YUJoZXM2bHM3MklP?=
 =?utf-8?B?ZStwN2tvWXJtRXFPekJ0TU5qd2lUK0lqdXpYZ0xxalQyMC8xcWxXd0dnRHgw?=
 =?utf-8?B?aTAyV0RlVHlseU5kTFZRY0xTMi8xVnJzYnBOcnVmSzU1UU1tbmVpZ3Bub1NR?=
 =?utf-8?B?RSsyTjlyN3NGU21YZEN0WjNzUTd1aG9udEp5S3NPUUp5SEQzd21UaTJIa1Fl?=
 =?utf-8?B?S25qcXJHYnBHMHJTQnM1Y2ZBU1hJM0xsSHNsRHF0c205MzhVc1pVRDZaWDFD?=
 =?utf-8?B?R01jVVBuM282bU5zc0RUNHNPZDloRHBYeVBBVHNKUXlzc09UcDgxdzJIV0Jh?=
 =?utf-8?B?ck5GZzBlWXA5bkZyam40UjhjZmJxQU5CUUltQVVyQlVrRHl0MXIyeDJqT0hQ?=
 =?utf-8?B?WCt6NmxjdVRpc3ljdlRRS21DQkFMeEFPZWRWZVRaK0orMmpKbGZick5rQzZU?=
 =?utf-8?B?S2hYV1Z1N204TFNwd1l0UnR3cGJleXUrM3hjMllPZTVmZ3F6blc2YWZXN3BR?=
 =?utf-8?B?RmpMSGZrWVR4TXlPcnp3YlpQdWNVaTdzQ0dlcHBWNjRJVlFZK1VHTmVGaVlP?=
 =?utf-8?B?SHloelNPZFh1eXR4MDhuU0Q5dWxjYmEwbzhMQ3h6TktnZW1QZ0tVY2xSZity?=
 =?utf-8?B?NkNBbWIyYlErTUFUb25pTkhoMDJia1VFMFk1ZkZOc3FkNC8wS05abnVFa2tV?=
 =?utf-8?B?OTlzU3VPNC9Vc2lDWVROdDNObDJ1SkFkUzlUSFhXRFRJaXRtSHNjN2FJamk4?=
 =?utf-8?B?SlZmTkVHMHNtcGt4cUgvbDZMRVNDNzlvNE51aWEwS1pyMVIvNnlzMG12bm8r?=
 =?utf-8?B?VUpyOTFkWjFOTllOb2VoYmNEUUhtTmpPWUtaMkFvWDc1OTBEUEMyeGJpd0JX?=
 =?utf-8?B?QXg2ODBZMjZzU0w2SVV0YU9OUE1BNllxb0pIeDZlYk40dzhCRVpxQkJlc2lr?=
 =?utf-8?B?dWpTU1VLRlMya3BkUTQ1TWoxT1MrMEdtTGEzRW8vQjErL1VFcmwveUoxU0U2?=
 =?utf-8?B?TFJUSWd1aUpCQ0hDRHZWbU14QlllSm1xbTN1Q0xxSlVYb2VCUTdoZGx3TlR3?=
 =?utf-8?B?aWw3NzJkaGNzMzhTc25qVnVDNGtRNnpvdnNlaml6WUZ5WU5mWVZkMzB6MmFD?=
 =?utf-8?B?d1pxNm9mSTVmUWIzSVJBeG5yN1VBY2dYckJZSzNKRTI0T2hYcW81NjBicStp?=
 =?utf-8?B?MnZwWjVhd3U3c0dDeldNQ1I1cVZrNEFtT05DUit2QWFka2t1elgvMUd4ejlH?=
 =?utf-8?B?NThnQWtZa2czSGQ2bnVoMEpTZEZUdHVaM2xtZU9uZjlPUVB5dUI0bmhTR0tY?=
 =?utf-8?Q?7uwOxYkVTekriDjGsLZ/hHaAwD4PWImZYXeTG21?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ed2311-595b-4c02-53c7-08d9268b3301
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5494.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 12:29:14.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFTr9FKumHNlW6p8QZty4YyRYD2Bffgv8sb82ZsXsaXXMdkujMtahqHE3ls3BqAolmrt8lFYhF+fxA7gCZXatGmowBKDJI8phy/yt3uIcO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

03.06.2021 12:07, Valeriy Vdovin wrote:
> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
> get virtualized cpu model info generated by QEMU during VM initialization in
> the form of cpuid representation.
> 
> Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
> command line option. From there it takes the name of the model as the basis for
> feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
> that state if additional cpu features should be present on the virtual cpu or
> excluded from it (tokens '+'/'-' or '=on'/'=off').
> After that QEMU checks if the host's cpu can actually support the derived
> feature set and applies host limitations to it.
> After this initialization procedure, virtual cpu has it's model and
> vendor names, and a working feature set and is ready for identification
> instructions such as CPUID.
> 
> Currently full output for this method is only supported for x86 cpus.
> 
> To learn exactly how virtual cpu is presented to the guest machine via CPUID
> instruction, new qapi method can be used. By calling 'query-kvm-cpuid'
> method, one can get a full listing of all CPUID leafs with subleafs which are
> supported by the initialized virtual cpu.
> 
> Other than debug, the method is useful in cases when we would like to
> utilize QEMU's virtual cpu initialization routines and put the retrieved
> values into kernel CPUID overriding mechanics for more precise control
> over how various processes perceive its underlying hardware with
> container processes as a good example.
> 
> Output format:
> The output is a plain list of leaf/subleaf agrument combinations, that
> return 4 words in registers EAX, EBX, ECX, EDX.
> 
> Use example:
> qmp_request: {
>    "execute": "query-kvm-cpuid"
> }
> 
> qmp_response: {
>    "return": [
>      {
>        "eax": 1073741825,
>        "edx": 77,
>        "in-eax": 1073741824,
>        "ecx": 1447775574,
>        "ebx": 1263359563
>      },
>      {
>        "eax": 16777339,
>        "edx": 0,
>        "in-eax": 1073741825,
>        "ecx": 0,
>        "ebx": 0
>      },
>      {
>        "eax": 13,
>        "edx": 1231384169,
>        "in-eax": 0,
>        "ecx": 1818588270,
>        "ebx": 1970169159
>      },
>      {
>        "eax": 198354,
>        "edx": 126614527,
>        "in-eax": 1,
>        "ecx": 2176328193,
>        "ebx": 2048
>      },
>      ....
>      {
>        "eax": 12328,
>        "edx": 0,
>        "in-eax": 2147483656,
>        "ecx": 0,
>        "ebx": 0
>      }
>    ]
> }
> 
> Signed-off-by: Valeriy Vdovin<valeriy.vdovin@virtuozzo.com>

Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>

-- 
Best regards,
Vladimir

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1070B4BA492
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 16:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242605AbiBQPjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 10:39:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239961AbiBQPjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 10:39:43 -0500
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00106.outbound.protection.outlook.com [40.107.0.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384DA2B2E15
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 07:39:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miFuxGwvH7Mqy76yRfShwEgWpRT4BdQWBWC4hvp7pcAzDTeHFkVgfP3bXPlzCJyxwezI96IV52xTrbBud4tuzJdoJexMa/ncXjESuTs7F4ByZz66tGp/jT6CupGMO428yUu7oe0bc1VkwVN6GPUSh9+GnA5t3WrFTy/unzEbWW2bX1aNILTzgPrQsali7iE8avplpKgJFY9itgS9HZP6l7x7OadIXp5elQCIxouM0tERiZtyPwf99exc839IECKGxlKDNAgI2R376QzcOZjXOVa+UB8399KnwoUFwBQ5AfQn4SYrta0UqUzRB2WOOF11sVNT8702jVcoObXHehnO/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7aubQ+zrrkJo9MthEj6OdHAFo5ZycTWKar0xFDj1GQ=;
 b=Be2Bk/LGdjZJpFotiNHpia9Y3JBADInXe6noLbZ9ftdYLqaV/3WpUhMgKVQYITtuKSmO8mWJy7JKwh0JFAFAvjcNxOZQ9/gdhfMTsq7KVSTRQRbhFNMmgulmzS7kPDn8OVUiTzfEVFee8t6aRhq8q0Ub/FLSTTCR0301R64ZpZEqIx6bQD771sbnNns+G0OXR9fmgoa8gVpYljlfV6XuuQnG8UHgvKMYprgDeQJz5ZbDxxZd1ncV7UUJkAQx3z3dgPHvCDOHGxJyV8n26TVFgjsoQd4eMNtd5jTwJzof7SnEM+rEHGUJalGUT3NE2aDKM1yf+l6YH5IcHt0tRX7DmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7aubQ+zrrkJo9MthEj6OdHAFo5ZycTWKar0xFDj1GQ=;
 b=B2i60ScO3qQVu/JXKLdK36hUVG46ZQIUQo4b3xEBgZNYgdB5NvEGUt/59U6T/nSQJL4XLkmYZiNQCjt0eB0KVYt92AHMWAD50xON5CkiurBCFLgzkpmg8/Fn83t+ovuCCeUGxJjnNZRmQ6nxLB5zOiS3WM4cX87s6lsRuosZv2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com (2603:10a6:20b:304::18)
 by AM0PR08MB3826.eurprd08.prod.outlook.com (2603:10a6:208:105::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 17 Feb
 2022 15:39:24 +0000
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::49c:67e9:3e24:8714]) by AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::49c:67e9:3e24:8714%4]) with mapi id 15.20.4995.017; Thu, 17 Feb 2022
 15:39:24 +0000
Message-ID: <8cfa9b17-e420-0ca6-4e50-ccf2dfd538bb@virtuozzo.com>
Date:   Thu, 17 Feb 2022 18:39:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v17] qapi: introduce 'x-query-x86-cpuid' QMP command.
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com, richard.henderson@linaro.org,
        pbonzini@redhat.com, armbru@redhat.com, eblake@redhat.com,
        wangyanan55@huawei.com, f4bug@amsat.org,
        marcel.apfelbaum@gmail.com, eduardo@habkost.net,
        valery.vdovin.s@gmail.com, den@openvz.org,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
References: <20220121163943.2720015-1-vsementsov@virtuozzo.com>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
In-Reply-To: <20220121163943.2720015-1-vsementsov@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P189CA0021.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::25) To AM9PR08MB6737.eurprd08.prod.outlook.com
 (2603:10a6:20b:304::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb1522ca-7cc2-4068-c50f-08d9f22bac9d
X-MS-TrafficTypeDiagnostic: AM0PR08MB3826:EE_
X-Microsoft-Antispam-PRVS: <AM0PR08MB38266886C366508FF34A173DC1369@AM0PR08MB3826.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7Wgm1a59er2cwYoGU6jTAdMQWUIhJGEKxnNanASSpnNcKUmrbFIXsmR/UbmNPUgd7i+QXqrbxP2fvXV88vPKBr9XeUIs01bsSZ38P016POUxwgK0M0+FnzIvU5Fiat72RF6LhXcRb9eNEN6F9gwk1Rl2tFa6XQ2ym07LzeOENhpQ8ta0avLuQL928xSzp3cseD4X6lDsiZTmuhFC4QHX3ET2LtNiNjrWkMat5S8tvK2/Kp6QqxaW+Y+sGSfyBTQx62Z+To+oXqJB+/VFbfxpcxck5eIEFBg2v++OF120DeZH9ptgmFYWJOKi6r68Xgr3fl+D9twvZcXfZbW5gN/ifDOCqPCGD/MeloTk+jBaCvwbUr9dNTBDh2uwr3tCIi8Cw7ODA2QoCkbvo64gUHeW5shAlt7GPOiUZWZGtK42RpG6LDkAPXi0hk1fioJxSx44latR9ThzF5+RCIsoI8ujhKGp+C7FF9sdWWLzxUaQG2OOvjMqFFuHLj11PNXiG54OXr96m46rxjftbVPR5XgYkav5Sjns/ILM3myvJh5JzmgXWxn0UYk22dtU9dzGRRTYd/8P0jHnFuJp8LSZr9HgbzpyQjL0Fd1sdHl+UKXDqY8neW16zGfQS0NRrFHZIf/tTxybyiuhKt89uCTDYFwUP89N/bwYFeVge+OEXaDsCUJIANJgpEeQe94VZlv4Z6PMg/SUV3jH+8/59aV5NAispaiCJbqSxiM8F/4f6Oyl9ddQ2bMF45Fil0WW5vbEVwmVOfjC12sz7HB7pNp2L089Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6737.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(52116002)(186003)(316002)(7416002)(5660300002)(6506007)(6486002)(36756003)(8936002)(31696002)(6512007)(107886003)(508600001)(86362001)(31686004)(8676002)(2906002)(66476007)(38350700002)(38100700002)(66556008)(2616005)(6916009)(66946007)(83380400001)(6666004)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG5UTGRIRnEwK1YrY0pndkdNRUlGMThJamJkZTdIUjFPdDh5b0hWZXFDSC94?=
 =?utf-8?B?WUVBSjN4WFpvaGtKNnN6MmFOUzBCRUgvNlpTNEgxbWpwQmRvdXVZU1h6MUVw?=
 =?utf-8?B?S292WHhSS0xMbmFFS1kyVzVRdnlXZm9HQUxUTDJhbWRxL3MyRzlJM2R4ZkNC?=
 =?utf-8?B?bHR3VlFnUW42bTE2Qys1aWY2WHJROENCTDFGd2ZPcldzVnhyd25zbW1qUU00?=
 =?utf-8?B?bUFkcUZRVEMzdThYRnVDQTdBa3oyamtGcVBkZjBQRzVsTVlHNlBGbHljM0Jt?=
 =?utf-8?B?RHJxcGZUVUFvL3NIN04zSG1jK1lZUldzZmpVZzd1U3ZHSVA4YW9NamVaUVNr?=
 =?utf-8?B?cXpYVmVtZWRSK1pCOXVlcmxkTkxFdUhBcFpYQkdITHRxQjNNazFFRXYxSE4v?=
 =?utf-8?B?dUlGazIwcXJMU0NNSGduTkdLSW1rb2l5bS9Cdm1mR1FHbHNqUHdxbUdUUktX?=
 =?utf-8?B?RDhadmczYjdmcm92UHlGVVRVSWh4QVZuL3NzUEtLMHlLVmI2Tks4OHN2bmhk?=
 =?utf-8?B?RWdNcDBCKzM3cE9sTXpxZW5DbEM4SXZ5Ujl2TCs2UytrcDhqVE05RU5UUW1m?=
 =?utf-8?B?b1NYYjNKeW4vVkJGZUlHazFUUFZuUml0OEtiazAyM0Z0R0NsbExDdmthaFVs?=
 =?utf-8?B?SzYwQkdpU3paUXdsTHVzYnUrTCtTczBTR1dNMnMxSFZMVGxMSGhVWFVlM2Yz?=
 =?utf-8?B?aWhBWWlFZEhJbDVqZFJxbjg4ejBvYjd1blZnd1Rndi9UWjJobDdIeGg3Q1l2?=
 =?utf-8?B?ZXJ2ZVhxU01TbFV6S3VXdFNtZ1o5MzNkNVI3QmdtTnphdTdiQkZYOW02ZWph?=
 =?utf-8?B?OW5vTWd6ak1zQWNuQXdndlFudmdrZ3krYUluY3cyTWJlbkYzeHVndGhJTTUz?=
 =?utf-8?B?OFpjYXcrMXpQNVM1YUZhWmVmbmZvdzVic0ZNUlIrbmliaTJObUFqNEpJTE1S?=
 =?utf-8?B?WE51U3cwSS9VbG41ejJyNTlpdnR2TGYzMWZERUI5dzRKbkhPclFucHkxczB1?=
 =?utf-8?B?OGwyWk1kbnBRMkc3TzF1bFZOeVVzZC9YREJxUUtzRXhoNTR2czJ6OGN0aEty?=
 =?utf-8?B?NFZrazlubWxYcFBRN1lzV2tyeXc5QWZlcU4wQ00zVmFiY1V6NW9SQmc1OVdI?=
 =?utf-8?B?eVpXVU5lMVN1SUtlU1BUVEZpenRya1NxMTZWUDUyMmkyYUVGbDhJMWphUmFy?=
 =?utf-8?B?MEcvQ0tNdE9kM1hPZkUweGtuU2JnUjcwRjBUb0d0dFB1bUkwMm9mWkdIZzRy?=
 =?utf-8?B?YS9wbmVJWkYvRVRFREw2bVR0NVNhR01zMUFJL3R1VllPdjlyWU85QjFZcTlS?=
 =?utf-8?B?YUxrZW5lMWxqTUlIU1RESFp6MDczclcxODZwZi85SUZwb1Y3RE9OektRcVd4?=
 =?utf-8?B?cU9MYSs3aGg0cmhJVzNUMzM4NTlUYjFPc1BoUGJYdHRnWmxYdnBORCt0eFJD?=
 =?utf-8?B?MDEwZEhONDl1VlFlZ0U3MFQzRU05Z0pISCtKUWhxbEU0S0QxTmdCeElKV3JH?=
 =?utf-8?B?S094ckJQMHlpeWdYRGlQVXFtNHpsNHlSLzFneXNwbkMrYXFkS0VGSTllSDR4?=
 =?utf-8?B?WFYxc0dnU2RWRXpWd0c5TmRYZVgxN0kwWlNqSjBGL09OV20zVmF5Z2VGTHFj?=
 =?utf-8?B?VC9mVlQ0Qm1mdi96SXMvWXFTcG1OeEp3NGFsVzFHRHFkbzJMQ0phUXc2MFVm?=
 =?utf-8?B?L0xwV2UvQUZ0ZTZwVlh2dHJ2MkFHc2ZaeEM0MzJlZzdWell6Q0kyV3RWYTRR?=
 =?utf-8?B?elFnNDh3QmszWHVEaGN0YmZyR0lndUFjVWFKYTA1VnBtQi9CeFhoVjVZZDE4?=
 =?utf-8?B?aGY5c2Q0bHRWNDN1ZytlaVBXVHdvaCtYdE1iOHFjTlIrRktJOUxGL0FiMCtm?=
 =?utf-8?B?TEZNVGZWMjlXeVpWYzZLVitaNXlwVmNDU1FIWm1LVkR2TFU2Sm95U3dnenFj?=
 =?utf-8?B?ZVRrY29QVlBSSFczWm4ya0JBZlFsUmxQNEpURFRIalVRYkxMY1lqbllNREdN?=
 =?utf-8?B?RTh3M2wwTFd0R25zSE43V0JsNHE5SHdDMThoUXNSNElSbk12QzJwaU5HS0dO?=
 =?utf-8?B?cVE3RzVoZGMrdlMvUmVKS1pyT0dZeW1keDVwVCs2bGRkZW0zVHlISk1NbWZQ?=
 =?utf-8?B?YWM2VDRaQ2xZcWxVd0hMdkN6aWVVUTJ1UDBhNThXUmhsMml0K2xrcC9aSEpQ?=
 =?utf-8?B?L1pXeGhaQXBQRys1NnZUZ3hpVnJPZmlRaElVb0dwT2tEajlCNmwxSFN3dzB6?=
 =?utf-8?B?Y3cyV2R4UG9yeC82dnVyQ3lraGdRPT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1522ca-7cc2-4068-c50f-08d9f22bac9d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6737.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 15:39:24.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgWnebKh2pN12ThSUq4ExP67sTHpgOHrMrOUWMUJqi7YWzftblGJ1s6CfCHMevniG3IKmyAhYfzLpCuf4m044aJX2L1acibItYDjR+4mcU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3826
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping :) Any hope that we will merge it one day?)

21.01.2022 19:39, Vladimir Sementsov-Ogievskiy wrote:
> From: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
> 
> Introducing new QMP command 'query-x86-cpuid'. This command can be
> used to get virtualized cpu model info generated by QEMU during VM
> initialization in the form of cpuid representation.
> 
> Diving into more details about virtual CPU generation: QEMU first
> parses '-cpu' command line option. From there it takes the name of the
> model as the basis for feature set of the new virtual CPU. After that
> it uses trailing '-cpu' options, that state if additional cpu features
> should be present on the virtual CPU or excluded from it (tokens
> '+'/'-' or '=on'/'=off').
> After that QEMU checks if the host's cpu can actually support the
> derived feature set and applies host limitations to it.
> After this initialization procedure, virtual CPU has it's model and
> vendor names, and a working feature set and is ready for
> identification instructions such as CPUID.
> 
> To learn exactly how virtual CPU is presented to the guest machine via
> CPUID instruction, new QMP command can be used. By calling
> 'query-x86-cpuid' command, one can get a full listing of all CPUID
> leaves with subleaves which are supported by the initialized virtual
> CPU.
> 
> Other than debug, the command is useful in cases when we would like to
> utilize QEMU's virtual CPU initialization routines and put the
> retrieved values into kernel CPUID overriding mechanics for more
> precise control over how various processes perceive its underlying
> hardware with container processes as a good example.
> 
> The command is specific to x86. It is currenly only implemented for
> KVM acceleator.
> 
> Output format:
> The output is a plain list of leaf/subleaf argument combinations, that
> return 4 words in registers EAX, EBX, ECX, EDX.
> 
> Use example:
> qmp_request: {
>    "execute": "x-query-x86-cpuid"
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
> Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
> Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
> ---
> 
> v17: wrap long lines, add QAPI feature 'unstable' [Markus]
> 
>   qapi/machine-target.json   | 50 ++++++++++++++++++++++++++++++++++++++
>   softmmu/cpus.c             |  2 +-
>   target/i386/kvm/kvm-stub.c |  9 +++++++
>   target/i386/kvm/kvm.c      | 44 +++++++++++++++++++++++++++++++++
>   tests/qtest/qmp-cmd-test.c |  1 +
>   5 files changed, 105 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index f5ec4bc172..1568e17e74 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -341,3 +341,53 @@
>                      'TARGET_I386',
>                      'TARGET_S390X',
>                      'TARGET_MIPS' ] } }
> +
> +##
> +# @CpuidEntry:
> +#
> +# A single entry of a CPUID response.
> +#
> +# One entry holds full set of information (leaf) returned to the guest
> +# in response to it calling a CPUID instruction with eax, ecx used as
> +# the arguments to that instruction. ecx is an optional argument as
> +# not all of the leaves support it.
> +#
> +# @in-eax: CPUID argument in eax
> +# @in-ecx: CPUID argument in ecx
> +# @eax: CPUID result in eax
> +# @ebx: CPUID result in ebx
> +# @ecx: CPUID result in ecx
> +# @edx: CPUID result in edx
> +#
> +# Since: 7.0
> +##
> +{ 'struct': 'CpuidEntry',
> +  'data': { 'in-eax' : 'uint32',
> +            '*in-ecx' : 'uint32',
> +            'eax' : 'uint32',
> +            'ebx' : 'uint32',
> +            'ecx' : 'uint32',
> +            'edx' : 'uint32'
> +          },
> +  'if': 'TARGET_I386' }
> +
> +##
> +# @x-query-x86-cpuid:
> +#
> +# Returns raw data from the emulated CPUID table for the first VCPU.
> +# The emulated CPUID table defines the response to the CPUID
> +# instruction when executed by the guest operating system.
> +#
> +# Features:
> +# @unstable: This command is experimental.
> +#
> +# Returns: a list of CpuidEntry. Returns error when qemu is configured
> +#          with --disable-kvm flag or if qemu is run with any other
> +#          accelerator than KVM.
> +#
> +# Since: 7.0
> +##
> +{ 'command': 'x-query-x86-cpuid',
> +  'returns': [ 'CpuidEntry' ],
> +  'if': 'TARGET_I386',
> +  'features': [ 'unstable' ] }
> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> index 23bca46b07..33045bf45c 100644
> --- a/softmmu/cpus.c
> +++ b/softmmu/cpus.c
> @@ -129,7 +129,7 @@ void hw_error(const char *fmt, ...)
>   /*
>    * The chosen accelerator is supposed to register this.
>    */
> -static const AccelOpsClass *cpus_accel;
> +const AccelOpsClass *cpus_accel;
>   
>   void cpu_synchronize_all_states(void)
>   {
> diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
> index f6e7e4466e..71631e560d 100644
> --- a/target/i386/kvm/kvm-stub.c
> +++ b/target/i386/kvm/kvm-stub.c
> @@ -12,6 +12,7 @@
>   #include "qemu/osdep.h"
>   #include "cpu.h"
>   #include "kvm_i386.h"
> +#include "qapi/error.h"
>   
>   #ifndef __OPTIMIZE__
>   bool kvm_has_smm(void)
> @@ -44,3 +45,11 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
>   {
>       abort();
>   }
> +
> +CpuidEntryList *qmp_x_query_x86_cpuid(Error **errp);
> +
> +CpuidEntryList *qmp_x_query_x86_cpuid(Error **errp)
> +{
> +    error_setg(errp, "Not implemented in --disable-kvm configuration");
> +    return NULL;
> +}
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 2c8feb4a6f..eb73869039 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -20,11 +20,13 @@
>   
>   #include <linux/kvm.h>
>   #include "standard-headers/asm-x86/kvm_para.h"
> +#include "qapi/qapi-commands-machine-target.h"
>   
>   #include "cpu.h"
>   #include "host-cpu.h"
>   #include "sysemu/sysemu.h"
>   #include "sysemu/hw_accel.h"
> +#include "sysemu/accel-ops.h"
>   #include "sysemu/kvm_int.h"
>   #include "sysemu/runstate.h"
>   #include "kvm_i386.h"
> @@ -1565,6 +1567,44 @@ static Error *invtsc_mig_blocker;
>   
>   #define KVM_MAX_CPUID_ENTRIES  100
>   
> +struct kvm_cpuid2 *cpuid_data_cached;
> +
> +
> +CpuidEntryList *qmp_x_query_x86_cpuid(Error **errp)
> +{
> +    int i;
> +    struct kvm_cpuid_entry2 *kvm_entry;
> +    CpuidEntryList *head = NULL, **tail = &head;
> +    CpuidEntry *entry;
> +
> +    if (!kvm_enabled()) {
> +        error_setg(errp, "Not implemented for non-kvm accel");
> +        return NULL;
> +    }
> +
> +    if (!cpuid_data_cached) {
> +        error_setg(errp, "VCPU was not initialized yet");
> +        return NULL;
> +    }
> +
> +    for (i = 0; i < cpuid_data_cached->nent; ++i) {
> +        kvm_entry = &cpuid_data_cached->entries[i];
> +        entry = g_malloc0(sizeof(*entry));
> +        entry->in_eax = kvm_entry->function;
> +        if (kvm_entry->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) {
> +            entry->in_ecx = kvm_entry->index;
> +            entry->has_in_ecx = true;
> +        }
> +        entry->eax = kvm_entry->eax;
> +        entry->ebx = kvm_entry->ebx;
> +        entry->ecx = kvm_entry->ecx;
> +        entry->edx = kvm_entry->edx;
> +        QAPI_LIST_APPEND(tail, entry);
> +    }
> +
> +    return head;
> +}
> +
>   int kvm_arch_init_vcpu(CPUState *cs)
>   {
>       struct {
> @@ -1981,6 +2021,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
>       if (r) {
>           goto fail;
>       }
> +    if (!cpuid_data_cached) {
> +        cpuid_data_cached = g_malloc0(sizeof(cpuid_data));
> +        memcpy(cpuid_data_cached, &cpuid_data, sizeof(cpuid_data));
> +    }
>   
>       if (has_xsave) {
>           env->xsave_buf_len = sizeof(struct kvm_xsave);
> diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
> index 7f103ea3fd..94d9184a84 100644
> --- a/tests/qtest/qmp-cmd-test.c
> +++ b/tests/qtest/qmp-cmd-test.c
> @@ -54,6 +54,7 @@ static int query_error_class(const char *cmd)
>           /* Only valid with accel=tcg */
>           { "x-query-jit", ERROR_CLASS_GENERIC_ERROR },
>           { "x-query-opcount", ERROR_CLASS_GENERIC_ERROR },
> +        { "x-query-x86-cpuid", ERROR_CLASS_GENERIC_ERROR },
>           { NULL, -1 }
>       };
>       int i;
> 


-- 
Best regards,
Vladimir

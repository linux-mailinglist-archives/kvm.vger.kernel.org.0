Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5388B313D11
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhBHSSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:18:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbhBHSQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 13:16:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118I5Dja134439;
        Mon, 8 Feb 2021 18:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=jVOaMRCqwCrCM6X2FJqyfDGMlkQY3kFNDRBUuG3lguU=;
 b=n7k3/SIyzExIurNEkjHhdCsgC1hhRMRpmUgak9WbwyM4d4U1XKLLJvzjH/x4CyEjRwMd
 CUWMk64LlPTUQuIe7r/ZR9TjN9Rs2s9W/t1plAvA6SjpJy8e0MAqlhUlsSfxnEZ6LYo9
 0VeLjaBDUZpuoC/14C5M/C9RoYV6S7wYKg497/o9rkDK1nS08N6fDFe0RFZVbq0aTwub
 z31YgQFdn+DYw2RdaJcEXboahLYUckclI3vHLBOr2lzxF03CzUmjCddBc5vQRKxsZ0yd
 7BMILFtzhB+CUeiDwvkNf7YDaxx6vkJzHStmPUc1CEPANxzRFdAsntHvy3ScwYPmXB5/ RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36hk2kcujb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 18:14:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118I5Ka9189837;
        Mon, 8 Feb 2021 18:14:08 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2055.outbound.protection.outlook.com [104.47.38.55])
        by aserp3020.oracle.com with ESMTP id 36j5106292-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 18:14:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAzATab5+Kcfdvma/czpVPqF5/4UHnRmecjoyApS1ntIBgttKSPEh/Ti2Tdbtn+6AjUqNmlxUvU+/GgdP2FHfnzOytM6Ktq1ZwpOAePgGVrWhKAI3KpCMY1cCUgv7dAts5C+Oq8kUus9j56NmBsFRfr1ID4YjRY7PmO2XLeHFvLp28tq6VO6ablcX788oTRqrgzlo/y2wlVL3Hk+9Oe9sJOsj+UjWICl1uc3pXTWscQwkGWx1t3jNFnXYBBR9doTlRbbcQoyVggiwPygVECWZYYIcOt7tAwSTLYI1MMbB0eorczk4ApsTdmk9MGcFI34oawjV0I9HqfOin9pVp1IyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVOaMRCqwCrCM6X2FJqyfDGMlkQY3kFNDRBUuG3lguU=;
 b=kBGNZO2cS9QTUgLxxh4R4bFADpQFy8k0lKoMzZxKIntnjHZEwDL3bj0s5VcpTlfNK/FKgeWrxB8hrh0O+vfGrfZQL23/9MuelRkE8R9WU/Wb/fhti6BlbFnA+BLx7O9PT9/GD/wecTwxexaprODi0ymLjCXezGrbLIo/v3OyEZiFgOYycpsbB+Wra9kov2JS3TEet19rr1lJuctjIm1gaZIQ125en5J7uWK20VJes7Tydo3NPcT9zx52rayiorS+QODnmQY46DWH+FEZzThO1uGmO1IMvjjseJ94O87ibuFNo3zucUYlzs0euM2/d62OWZxfCoD3bkMr/BG+r8zpbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVOaMRCqwCrCM6X2FJqyfDGMlkQY3kFNDRBUuG3lguU=;
 b=y5I3klwu+/peSbWPfkYbIpHORdT6VB+p5KL97/EpwXl3WaJPUe6w0og6rjkXz0jTJ0tGkxeEaP4L0zTWFqnNbFk4icaQoZuEi3M44l0dHwH0YYGhFeWvOpFf6gRqc6LKOwF7gT2sR0nCn1ul/wPgy7bZuLJ4HpNtwI/+YPmgXgk=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BY5PR10MB4116.namprd10.prod.outlook.com (2603:10b6:a03:203::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 18:14:05 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456%4]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 18:14:05 +0000
Date:   Mon, 8 Feb 2021 13:13:59 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Zhimin Feng <fengzhimin@bytedance.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com
Subject: Re: [RESEND RFC: timer passthrough 0/9] Support timer passthrough
 for VM
Message-ID: <YCF/ZzI3OTBRMgVf@Konrads-MacBook-Pro.local>
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205100317.24174-1-fengzhimin@bytedance.com>
X-Originating-IP: [138.3.200.11]
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Konrads-MacBook-Pro.local (138.3.200.11) by BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 18:14:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8fe363f-8491-4797-e8dd-08d8cc5d51dd
X-MS-TrafficTypeDiagnostic: BY5PR10MB4116:
X-Microsoft-Antispam-PRVS: <BY5PR10MB411662A1E316B8ED72423824898F9@BY5PR10MB4116.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HzeHPkQ543rkila4iHqM1wrTnEGetH3AL9xw9fBDMiu1ay4bTzAo+s09pLjqZHGWRrs1PH50+UFgCKZqNSCpFRbSk6uRCP43iGHnUhzKqCKTN6JOgQEFiSVVtcLh15h2RxnxSDyKHYO7DfLS3QU9dawiZ0gwScpByezufUDprK3UAkBYUFA2nlACdCHhkMmQ8xuyCCpXGHDMg+mu4JEvdlgnl6qNxwiINfPA+5GRvCt1q3E6QLeR+X7x62aVyqykLTIMNeEfcpaO6iSqpx9ByoNCnSYoWhwIm1DbcvLnYMV14VWJ9xxjbW9OFqH1QXnNY+t9wEXwZboVIxHHk7hKWwoVVyNJfkoMiR4Jv5xfZPh16CO2fMSeoaTU8XkGX3GuDesdGzZg+KrSdQBnN3Fpc8T77tj4r+hRm2rWCUNDIxMdw6Fd3kbGG3ScKQY31U9a2Q22xyKJTFgl4xM6V1XP9VoaukL0irBkH/0fq5e+yHL/Awxyn7DMFY4fvibDqAF6p3/UEgXg7fIC02BA8+W0mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(346002)(376002)(86362001)(9686003)(186003)(6666004)(478600001)(83380400001)(16526019)(52116002)(8676002)(7696005)(6506007)(55016002)(6916009)(8936002)(7416002)(66476007)(956004)(66556008)(2906002)(66946007)(26005)(5660300002)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?w2He0qUl5aL16vBeIx0K0tFGSl22MucybeEHvbAZHbtLV3FcjEdghPDrwb6l?=
 =?us-ascii?Q?dVWXNGSgSAv1H0jFxp+nbA/vO2yyczpSD10ISWRjBMsiwKuKb1VnmpEAVgWx?=
 =?us-ascii?Q?Ndrg48kMRn6u92CGsr7jHVD0gUvwpYgTSYFzxqP8FuFiHlB7lm27jKLUCvKl?=
 =?us-ascii?Q?7h8F2oxdF15FpHawk1MgHjiD9+ysuz1I4KydiYwfVJnsZzRKZMStJqwjoErW?=
 =?us-ascii?Q?cenCOr90/Nq0uZX4qFssVpULpxByQJjtVNhaSkqbX6IXoY/tIuXzCGOMN2yS?=
 =?us-ascii?Q?svYXcmlHs/UZuEa/c6WfprKmQV7pEf+Mb8/DmeeJoIx1qBGBVRJ2y+sWwOV2?=
 =?us-ascii?Q?mtdo+r0LYYRBUvyskxIpvug/u3qFFPlvGHYsJo/6XqW38JYhy/pjd4j0ZG61?=
 =?us-ascii?Q?E8JDIQqdL8S6k8yCQf+3EUtJUfYbB1TRpea+SYeNQgZ/uvac8SKywd/F7Pov?=
 =?us-ascii?Q?YFi6FkRFS1iwmg+NBFczVWotSaap1GhxKLgEAnCVLQMBLY4yZHGqpaSO/4yD?=
 =?us-ascii?Q?SDrPErKWtgzK3firVTOMtiXQFrY0eD+AI76HvG7VFPy9lkAlQxuYy4iOIbM9?=
 =?us-ascii?Q?TC1bItsgy7MUiWcHq+920aMHPq8ESPc7qaxO0QXXxq/nWflrV7WynTEQOVPM?=
 =?us-ascii?Q?KU05KfDTikbXEGna/MqINp0rz8i6B5C6cw+1RQPIBZGAEk4m2WZ9n62LWMMH?=
 =?us-ascii?Q?VC22wJ11fvSAyBJ24FfytnIx8GfYTm80LjOGWci+o5gSJZ6KB924aUsv93Z/?=
 =?us-ascii?Q?G8UEyJSsmAQUWaODWTUJsKzE/GsBRadHe4ov/s9nogsqJv2imZid/jUMaw3j?=
 =?us-ascii?Q?X8NPYoUD+sR/7gYZDsW2usOfG7XD/3cgCy7zCWW4Erxgc/2zMFXEQ7z2SB/p?=
 =?us-ascii?Q?iFLwcxzuEw4Q98zKJrz1A12XJ0/lsQTfoYof9mO7Q5IDeJd0FVnXn0Zoxv8t?=
 =?us-ascii?Q?et67W0iAAbeH7ZGDKysERWUg0v/yU70xoFoZKNGho3SILJWGD7JOemMAkrFN?=
 =?us-ascii?Q?8RSPH7u/WEkHU9Kv/j4Q8QPunaN+szbj+fGIbHlxtvNaxZe29AP7cw9wuybK?=
 =?us-ascii?Q?z/zKX/etvdpeWasA9U66YMQ2TK2ILgtj8MjgYXV4Df8x0hF7mpLMmLoQb+dl?=
 =?us-ascii?Q?Igc9Of+u5dXG5lI6WrBmpw2wf6IZDKYdDcHbCJd21UawFt/cFVi7AOSCO+7G?=
 =?us-ascii?Q?xAiPX7MvZ49+qF8M1sTo5HRke/fDUH0YjNr3bOpdLjVfUKCvX1tEpy5MVqo1?=
 =?us-ascii?Q?lahDiu2tsumN8XiBKkNF8emB3JJDaKNW0IZPuWFl156nGPu0VbwdB8hZJH6s?=
 =?us-ascii?Q?b6rbUm5/UQgBz0VkCFY0Om4Q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8fe363f-8491-4797-e8dd-08d8cc5d51dd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 18:14:05.2566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GvhCv26PiyP9r/ZSweDmkvH5EhsTkMdUg1LGfS2IxwJdsXmFgwXJBsWBpJD8PorZckDnP/ET0nRz7rfP+rxnQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102080112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 06:03:08PM +0800, Zhimin Feng wrote:
> The main motivation for this patch is to improve the performance of VM.
> This patch series introduces how to enable the timer passthrough in
> non-root mode.

Nice! Those are impressive numbers!

> 
> The main idea is to offload the host timer to the preemtion timer in
> non-root mode. Through doing this, guest can write tscdeadline msr directly
> in non-root mode and host timer isn't lost. If CPU is in root mode,
> guest timer is switched to software timer.

I am sorry - but I am having a hard time understanding the sentence
above so let me ask some specific questions.

- How do you protect against the guest DoS-ing the host and mucking with
  the host timer?

- As in can you explain how the host can still continue scheduling it's
  own quanta?

And one more - what happens with Live Migration? I would assume that
becomes a no-go anymore unless you swap in the guest timer back in? So
we end up emulating the MSR again?

Thanks!

> 
> Testing on Intel(R) Xeon(R) Platinum 8260 server.
> 
> The guest OS is Debian(kernel: 4.19.28). The specific configuration is
>  is as follows: 8 cpu, 16GB memory, guest idle=poll
> memcached in guest(memcached -d -t 8 -u root)
> 
> I use the memtier_benchmark tool to test performance
> (memtier_benchmark -P memcache_text -s guest_ip -c 16 -t 32
>  --key-maximum=10000000000 --random-data --data-size-range=64-128 -p 11211
>  --generate-keys --ratio 5:1 --test-time=500)
> 
> Total Ops can be improved 25% and Avg.Latency can be improved 20% when
> the timer-passthrough is enabled.
> 
> =============================================================
>                | Enable timer-passth | Disable timer-passth |
> =============================================================
> Totals Ops/sec |    514869.67        |     411766.67        |
> -------------------------------------------------------------
> Avg.Latency    |    0.99483          |     1.24294          |
> =============================================================
> 
> 
> Zhimin Feng (9):
>   KVM: vmx: hook set_next_event for getting the host tscd
>   KVM: vmx: enable host lapic timer offload preemtion timer
>   KVM: vmx: enable passthrough timer to guest
>   KVM: vmx: enable passth timer switch to sw timer
>   KVM: vmx: use tsc_adjust to enable tsc_offset timer passthrough
>   KVM: vmx: check enable_timer_passth strictly
>   KVM: vmx: save the initial value of host tscd
>   KVM: vmx: Dynamically open or close the timer-passthrough for pre-vm
>   KVM: vmx: query the state of timer-passth for vm
> 
>  arch/x86/include/asm/kvm_host.h |  27 ++++
>  arch/x86/kvm/lapic.c            |   1 +
>  arch/x86/kvm/vmx/vmx.c          | 331 +++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c              |  26 +++-
>  include/linux/kvm_host.h        |   1 +
>  include/uapi/linux/kvm.h        |   3 +
>  kernel/time/tick-common.c       |   1 +
>  tools/include/uapi/linux/kvm.h  |   3 +
>  virt/kvm/kvm_main.c             |   1 +
>  9 files changed, 389 insertions(+), 5 deletions(-)
> 
> -- 
> 2.11.0
> 

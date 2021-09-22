Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250254142D6
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 09:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhIVHn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 03:43:27 -0400
Received: from mail-eopbgr70133.outbound.protection.outlook.com ([40.107.7.133]:24448
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233230AbhIVHn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 03:43:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbW7Vt9exZqUx9l0+YITBgU7Lrrrmlxr9mVSsVMT8zCNB9RHg01Vpviu94mo6iXqUfOFxJn0YadZB683ukW+e6XzkBLApFvTBfBZS9hFIVZI44KaMRkLa37UqoFWf4QX0HWjGaZL8Cp9XOGl/e540k/8DKqx0i9wZJlsj/lSNFDzhtBIWBEDTGXq6ux07PRgalQPkHWPNQISZ8v07qkwDoT8Brp334h67XXM3eHywR29QRGb/pApPbem25jZL3sTzVuGFbmgrCl7EfllPecTlBGekc1y8D5hepwymsNZRrIULnxPQfi6vwJF+zyuQu6J3FrPDXmd9K23/2gG1WEIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WBoQ5H8rUY+Z0Eyy4kPrYpKbwBy6K5N4DKniM5K7xP8=;
 b=Y5PUnGOYpiURKqe8Lc4teCdAx/7JcosSpPTyHV+oYsk55bls2Srl4J4QCEpLnBY6L8Fbdv7vL5yV5XAgfjC/o6LouQ08AtLAAKwXmsiEcW8dQ4KTLgbiKNs5Z2bK3XFp0U+Ch1IgM8vIIHYW3C4KTIQIKmjKrcigEqBuwg7U5HhopTjf6j60l2gd6l4MvXnKuhljynGSZOccPa/tg2pk3IOdVzLx7fmfuZiDF9ZjOcsq7ApHzJ12FKqquqx6lyrFj6oPgKFGwXICn50aRRWYMsaBZf4+zt71XoBaNSMXrfWtUnABmQZ1kJjt0eE1YoHcCHhlJpnCMO7unmMWUt10nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBoQ5H8rUY+Z0Eyy4kPrYpKbwBy6K5N4DKniM5K7xP8=;
 b=Xqiw+u3LQML8SZlbzmn8Avu/zf6a+5kSuM7igYQnj0VrDQqqXKSLqJ2QAxWHmlKkQRfhMjKxPdZCsYTYtdqew5v8TKSqG8K/RDMEycXimUaxP3JX7YOMPqMfKJsFAZu7DGa0ILjqe8xkECzWPpm0ycYetPEaXozK10TgJwilEls=
Authentication-Results: virtuozzo.com; dkim=none (message not signed)
 header.d=none;virtuozzo.com; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM7PR08MB5494.eurprd08.prod.outlook.com (2603:10a6:20b:dc::15)
 by AS8PR08MB6423.eurprd08.prod.outlook.com (2603:10a6:20b:318::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 07:41:55 +0000
Received: from AM7PR08MB5494.eurprd08.prod.outlook.com
 ([fe80::2817:53b3:f8b4:fe22]) by AM7PR08MB5494.eurprd08.prod.outlook.com
 ([fe80::2817:53b3:f8b4:fe22%9]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 07:41:55 +0000
Subject: Re: [PATCH v15] qapi: introduce 'query-x86-cpuid' QMP command.
To:     Valeriy Vdovin <valery.vdovin.s@gmail.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
References: <20210816145132.9636-1-valery.vdovin.s@gmail.com>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Message-ID: <24143eb0-9ab4-bcf7-94e7-32037ad49b2e@virtuozzo.com>
Date:   Wed, 22 Sep 2021 10:41:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20210816145132.9636-1-valery.vdovin.s@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0101.eurprd04.prod.outlook.com
 (2603:10a6:208:be::42) To AM7PR08MB5494.eurprd08.prod.outlook.com
 (2603:10a6:20b:dc::15)
MIME-Version: 1.0
Received: from [192.168.100.5] (185.215.60.205) by AM0PR04CA0101.eurprd04.prod.outlook.com (2603:10a6:208:be::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 07:41:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0420d6e-aaaf-42e3-b604-08d97d9c72c4
X-MS-TrafficTypeDiagnostic: AS8PR08MB6423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR08MB6423D85E2EC4C72071EF2501C1A29@AS8PR08MB6423.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1uphQ/ya1GMq04RDRdaNBQ8TlH4C2rdLTVmWdbfs0Lj0g/tIbCHZsecqwC6dB8GxoaQYFjR3Y8ftcH0omYkh3+RFSva6SE3H+r1LzSOw9cHWDMPFQiRoXv3GPaQI4hJ7ktjZ2r9QbVtEZlpwvH7fQg8xy5W1Nqm7tECK0ZJ9p8jFXj9PcfhPIePUvl1FVkpMuCQnMwzoHcDa+EkUHFnDuEOmKkVk0KNA3aKdmjNGWcyfuXzYCOT2DYOZ3qJarRiuja9Ofb48IcFoHPHDHVCQTrrPzpc9OWUjgDhrOe/lcDCk3E5wmx7ncr1g4FOcveil1nszOdHxVoS9PSNk6k6JBAsgN61f+yZhzGTuJcvFzuRDP+8cDDOdGqhIPEGxcB1FerR5sMwpGS8CqWIy+0qJSeocAGiFYPx1MsvLP/BJxjCjnkcMwkK3HfzG9I4QUygwvhxeaURPY7Nx/zTTRyjGmtS/QauqRL/vBek/pOePOLSWPWSLoZCVibtxJikDaoQBc7c0k3kzm6AGzW80tF3Db5stJ+9VF05B42LxRujkT/JayPG1/4A48vkQFFALTwZ2t258CnRVahl6zoFPXrQiXHH5YTlmMNiSP6baHnxjbkuIHeUGSqOFb+gVdc96UuLQkvw6aCXPWd+mGzit4miKX5zHb/gKAPCbV7FEsE3sQwG0wmtR5U1VdnMtL28aedZgKp1Sben9r4Zs2gxm8XuohbHrs5ZVJmTP8TPMVXz+JlGuRtPGG0fC3Oo59WAJnXwNQNXOUaBxmE1PiDWbeN//jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR08MB5494.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(4326008)(7416002)(8676002)(5660300002)(38100700002)(66556008)(52116002)(83380400001)(38350700002)(26005)(16576012)(66946007)(8936002)(2616005)(54906003)(31686004)(2906002)(6486002)(66476007)(316002)(31696002)(508600001)(956004)(36756003)(107886003)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkZoVHVvN2FHdUNJYStvcFNtRGZEa2FBb3h5OWFXWWJvamZYRzh1d2RTbXJl?=
 =?utf-8?B?TTg1QW5nalZ1bEFwWjQxZUdMbWdwdlJ2UGlWLzRGRWZVRC9qV2xCWk9YLzRP?=
 =?utf-8?B?WUVQSllGcCt5L21mQk1qSGYrS0xFeUhYQ1RHN01yNVEwdUprZHJrc253em5Y?=
 =?utf-8?B?WTg4dkJtQlJRS2gveXZCT0xmOUhQTGVHV3lkUks2dGtVT2F4alpEQ21OVzdN?=
 =?utf-8?B?RUJJaC8wR1V0SEFJRnl2SWRMUnpEZzZXQmdyTGJJVCtTenlQZ2VaWGIzL1kv?=
 =?utf-8?B?ZDdSWFp1WlltV0RZbkYyU0Z1V2U4UW1LWE4vRVZqRWMyZXFmb2M4VzJxUmNu?=
 =?utf-8?B?Ym1nZCtZa0pPc0pwTUc1MnEwME93bFB4N2NZNmxiaXYraFpOYjZsMWtaWFFs?=
 =?utf-8?B?NkQxeEY5dHRNQmJ5a1duMnZ0cjlGY2Q3YWpzOEl0WW91UlhGcnJMMXVQb01o?=
 =?utf-8?B?Y1FEbjV3Zk1vNDF4QWVKRWFpWFJHbXhSdzI0M0RYTzQ0aW8zb2IzenRFRzQz?=
 =?utf-8?B?anVyVFoyUVFTLzVidHpPWnl2SmVYV2tnVlQrM2JURXVxdDg3dW42TUVncFVQ?=
 =?utf-8?B?OVA5d2JDUkl1ZGRZenBpanZhYWR6UUt2alBpS2N3dTBHRThkWFNsZ2FXbWJI?=
 =?utf-8?B?bVVmdmpWckJKdFpOeHBGSjRwNkdUcVB1VkpuNFl5VWJLSVZRSE4rUFdIWjRG?=
 =?utf-8?B?UnlDWG82ckZweVJTTzlqUjcvam1YS0ExaUxQMEtqZUJyRUYxQWZrd1Y0VjZv?=
 =?utf-8?B?c24wQVJKTUxDWExiaE5rMHNEUzIyNUdkU25WdlRKTFE4ODUwM2tQdWV3cEpu?=
 =?utf-8?B?bVlZclR3NzR3SlB2VjdST1hiSGg2TFZPdVpwVjBtVENtbEp6Z3o1YlJIeW1L?=
 =?utf-8?B?SHBkTitvbytqMlZDbVNDUDBDWXBkdUhLS3ZLU3hmQlFJY2F1Q3djZUVYOVFy?=
 =?utf-8?B?OUplZzl6ZnhPa21RZElsZkZqQXJDVThYZ2lyZXFvYU1Ub1NUVjBTSDl4UUFR?=
 =?utf-8?B?dE1ySm1FS0toNm02WkhmQjM3T0J3UDVuclhWdzc0Q0VTQ3JxNGJWT1ZmTmpN?=
 =?utf-8?B?MWpVMXRoUHZRakc0WWIrL3B2T1UwN2t5djFXRmNRM25EakYrOGdXSkU0c2tT?=
 =?utf-8?B?N1JKdFJ6TE95cUhuNzQwaURaTEt2TTErL2RvYmdaN1RQdExvakt4dXdnRy9l?=
 =?utf-8?B?QVhvaU5pQmFYSkEzMDZBRWtZRlRIS1VXcnR2T0dvamE3VGxkRkFrYndWVzBw?=
 =?utf-8?B?OGdESUlDSFU0MnRmS0Z5V0RQMzF6Vy8vOEZJeXpQSGF1d3djaUZvVE1qZms3?=
 =?utf-8?B?bkVlMHB2TFhvRDRGeEhPR3pxY2tnNC9YY0FrUUxPaEh2UXgzN2x0eGdtVklV?=
 =?utf-8?B?eTJRdm9ZbURHSnEwalN6ZDJrL2hMZHgxN3dxZEpVVElvTVZ3ei9uUThCWi9t?=
 =?utf-8?B?aVpacW1WRHNpZ21tTUpUSHl5dFJIQlZmaTJYbll1YUYrRG9MRnBUWEc1WXlJ?=
 =?utf-8?B?U0JLaldPN0FtbkJ3Y3o2b0ZwaDlNSGl4Ky9vd1VMeUJJdkFOSWR3T2NCQVM3?=
 =?utf-8?B?UnE4N1I1VHEzWmx6Z0tQelRSOHV1VGpjSFdHc0NVT2N0TW9JSjMxNFVrRU1Y?=
 =?utf-8?B?Vzhnd2hncnVVUUxMWFlzalpkS2x1T00wMTNXUnhURWJNcHlMN0N3cHhRdVMx?=
 =?utf-8?B?RUJZcTJYaTl0Q3o2QUcyLzNMUkx5UUNZTG4waUFFV1BrYStDUUp2eWw0SEg2?=
 =?utf-8?Q?9myi1jnzARLyA5bApanALFc2Wq+tgyCbH6LNthW?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0420d6e-aaaf-42e3-b604-08d97d9c72c4
X-MS-Exchange-CrossTenant-AuthSource: AM7PR08MB5494.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 07:41:54.9344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qBaJRpAFCHqzVjnnQeW7avUC1innT8DvQHHHc8XOEm46Tl1rmbLw/DVfPrPp5bMoitc86srFwB7VO82dmeB+mkrZM4tmE7ifamAmhYWAQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6423
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

Hi! Any chance for this to land?

The solution is very simple now: we don't modify any logic and just export kvm_cpuid2 entries as simple and flat QAPI list. What's the problem with it?

If any doubts, we can go with x- prefix for a new command.

16.08.2021 17:51, Valeriy Vdovin wrote:
> From: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
> 
> Introducing new QMP command 'query-x86-cpuid'. This command can be used to
> get virtualized cpu model info generated by QEMU during VM initialization in
> the form of cpuid representation.
> 
> Diving into more details about virtual CPU generation: QEMU first parses '-cpu'
> command line option. From there it takes the name of the model as the basis for
> feature set of the new virtual CPU. After that it uses trailing '-cpu' options,
> that state if additional cpu features should be present on the virtual CPU or
> excluded from it (tokens '+'/'-' or '=on'/'=off').
> After that QEMU checks if the host's cpu can actually support the derived
> feature set and applies host limitations to it.
> After this initialization procedure, virtual CPU has it's model and
> vendor names, and a working feature set and is ready for identification
> instructions such as CPUID.
> 
> To learn exactly how virtual CPU is presented to the guest machine via CPUID
> instruction, new QMP command can be used. By calling 'query-x86-cpuid'
> command, one can get a full listing of all CPUID leaves with subleaves which are
> supported by the initialized virtual CPU.
> 
> Other than debug, the command is useful in cases when we would like to
> utilize QEMU's virtual CPU initialization routines and put the retrieved
> values into kernel CPUID overriding mechanics for more precise control
> over how various processes perceive its underlying hardware with
> container processes as a good example.
> 
> The command is specific to x86. It is currenly only implemented for KVM acceleator.
> 
> Output format:
> The output is a plain list of leaf/subleaf argument combinations, that
> return 4 words in registers EAX, EBX, ECX, EDX.
> 
> Use example:
> qmp_request: {
>    "execute": "query-x86-cpuid"
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
> ---
> v2: - Removed leaf/subleaf iterators.
>      - Modified cpu_x86_cpuid to return false in cases when count is
>        greater than supported subleaves.
> v3: - Fixed structure name coding style.
>      - Added more comments
>      - Ensured buildability for non-x86 targets.
> v4: - Fixed cpu_x86_cpuid return value logic and handling of 0xA leaf.
>      - Fixed comments.
>      - Removed target check in qmp_query_cpu_model_cpuid.
> v5: - Added error handling code in qmp_query_cpu_model_cpuid
> v6: - Fixed error handling code. Added method to query_error_class
> v7: - Changed implementation in favor of cached cpuid_data for
>        KVM_SET_CPUID2
> v8: - Renamed qmp method to query-kvm-cpuid and some fields in response.
>      - Modified documentation to qmp method
>      - Removed helper struct declaration
> v9: - Renamed 'in_eax' / 'in_ecx' fields to 'in-eax' / 'in-ecx'
>      - Pasted more complete response to commit message.
> v10:
>      - Subject changed
>      - Fixes in commit message
>      - Small fixes in QMP command docs
> v11:
>      - Added explanation about CONFIG_KVM to the commit message.
> v12:
>      - Changed title from query-kvm-cpuid to query-x86-cpuid
>      - Removed CONFIG_KVM ifdefs
>      - Added detailed error messages for some stub/unimplemented cases.
> v13:
>      - Tagged with since 6.2
> v14:
>      - Rebased to latest master 632eda54043d6f26ff87dac16233e14b4708b967
>      - Added note about error return cases in api documentation.
> v15:
>      - Rearranged nested if statements.
>      - Made use of kvm_enabled() instead of custom function.
>      - Removed generated typedefs
>      - Added indentation to qapi docementation.
> 
>   qapi/machine-target.json   | 46 ++++++++++++++++++++++++++++++++++++++
>   softmmu/cpus.c             |  2 +-
>   target/i386/kvm/kvm-stub.c |  9 ++++++++
>   target/i386/kvm/kvm.c      | 44 ++++++++++++++++++++++++++++++++++++
>   tests/qtest/qmp-cmd-test.c |  1 +
>   5 files changed, 101 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index e7811654b7..75398bc1a4 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -329,3 +329,49 @@
>   ##
>   { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
>     'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
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
> +# Since: 6.2
> +##
> +{ 'struct': 'CpuidEntry',
> +  'data': { 'in-eax' : 'uint32',
> +            '*in-ecx' : 'uint32',
> +            'eax' : 'uint32',
> +            'ebx' : 'uint32',
> +            'ecx' : 'uint32',
> +            'edx' : 'uint32'
> +          },
> +  'if': 'defined(TARGET_I386)' }
> +
> +##
> +# @query-x86-cpuid:
> +#
> +# Returns raw data from the emulated CPUID table for the first VCPU.
> +# The emulated CPUID table defines the response to the CPUID
> +# instruction when executed by the guest operating system.
> +#
> +#
> +# Returns: a list of CpuidEntry. Returns error when qemu is configured with
> +#          --disable-kvm flag or if qemu is run with any other accelerator than KVM.
> +#
> +# Since: 6.2
> +##
> +{ 'command': 'query-x86-cpuid',
> +  'returns': ['CpuidEntry'],
> +  'if': 'defined(TARGET_I386)' }
> diff --git a/softmmu/cpus.c b/softmmu/cpus.c
> index 071085f840..8501081897 100644
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
> index f6e7e4466e..feb0d7664d 100644
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
> +CpuidEntryList *qmp_query_x86_cpuid(Error **errp);
> +
> +CpuidEntryList *qmp_query_x86_cpuid(Error **errp)
> +{
> +    error_setg(errp, "Not implemented in --disable-kvm configuration");
> +    return NULL;
> +}
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index e69abe48e3..d69d46c5c6 100644
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
> @@ -1540,6 +1542,44 @@ static Error *invtsc_mig_blocker;
>   
>   #define KVM_MAX_CPUID_ENTRIES  100
>   
> +struct kvm_cpuid2 *cpuid_data_cached;
> +
> +
> +CpuidEntryList *qmp_query_x86_cpuid(Error **errp)
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
> @@ -1923,6 +1963,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
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
> index c98b78d033..bd883f7f52 100644
> --- a/tests/qtest/qmp-cmd-test.c
> +++ b/tests/qtest/qmp-cmd-test.c
> @@ -46,6 +46,7 @@ static int query_error_class(const char *cmd)
>           { "query-balloon", ERROR_CLASS_DEVICE_NOT_ACTIVE },
>           { "query-hotpluggable-cpus", ERROR_CLASS_GENERIC_ERROR },
>           { "query-vm-generation-id", ERROR_CLASS_GENERIC_ERROR },
> +        { "query-x86-cpuid", ERROR_CLASS_GENERIC_ERROR },
>           { NULL, -1 }
>       };
>       int i;
> 


-- 
Best regards,
Vladimir

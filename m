Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA5B650479
	for <lists+kvm@lfdr.de>; Sun, 18 Dec 2022 20:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiLRTNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Dec 2022 14:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLRTNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Dec 2022 14:13:13 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E0B85E
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 11:13:11 -0800 (PST)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BIIFA0K011019;
        Sun, 18 Dec 2022 11:12:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=99ULaTVnvK/JM1kwDk7a3HXnntvqsRaAwWO8AtbBdhY=;
 b=lpuIytx60cSzQP3ZAfl/4VbZZYPpNA0DhGKx/QIOgq1HIWntHcx4RKqV/E9uuCjNer0R
 Epqtbia6v06Z55soDIF99ryAPZTvQO7T+y4BnFwfe3sff/RnK6XW45lAKlibinsZrpSI
 oor8Nr1lfuQ1+lNrKf3ExLT7136eyl0UkhYaJrYYDZ6vT321VQH+MAg3o49HFvohOnKK
 hPC7Yi5cCRitAcIqOG5vmvnUtpwvThGz51qyh4v7LfBU/WHgrxTw8PYuL6JeXfe3F5lS
 QUQzbZs8VtGbNnuvfF6dne+so/QEXE+rgbbOcWLetbtNM+4ZwVjPQnJHCi0bcu58il2c 0Q== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3mhcrq9t48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 18 Dec 2022 11:12:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoszLjacWuLuM56VC9DD2jmWTTvzMJvvEPQvLagLAWWpIsA9F8tJXkimC421W+qFdmduKBL4P2mDcNGrJkNBP0rZLPUz7PMY1bHrh3LqAgMmHM5pi9OfivBmO5jWZBX0kJmnJHsOQRhE5UL0LJTiPsC26cU81PsoUZvq0wjXautJ92JKaZfHb2gRtY6TOsIx6e3pToYTMGAUTJB+L38xWvWMSo6X2p9YUE/qz2zJU4KRpC8WXOl7jVXvWUrIRHIoxZY8vc3wTGiC4gqjeQvPBtC2F2mFJzbT5I8uQOdYQ5oVJ2DUS5BhsA7cDHxp834tNfYmNIcBKlw4WqVLPj5nAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99ULaTVnvK/JM1kwDk7a3HXnntvqsRaAwWO8AtbBdhY=;
 b=n3KJOrEXo+f+P1faCxKYdrKz2HDpVjnvnoxsPGUFL3JCiSEUAGqXTPfzn+dDDgAfnYlJIEwaEOnwY7CSi/GNTL9oJzPopQQOgFqv7Mgio5zkILtAwyCJzi7fdhNkCrTJTzM4JVH4KcuoHATibULAOoR/JKFlr4Q33Lh6tz2ZKXHB7NdTWupMkliLLdzMTeJPAlqcnlnLJ2cKcK20sbNByFPPmH4xJzO0oK/Znxxsf0AMCeeCwujFLWxvQTuhUBj/rBzaG5SeffSSnlgQoT6P5NF2NtHxwjhSHE4BiB7R0/Fu1dpi4/ggKpML02LDeKtj/Zs6lS495W7YTnyCOGdwhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99ULaTVnvK/JM1kwDk7a3HXnntvqsRaAwWO8AtbBdhY=;
 b=OItrHwyttC5R/6jZ6Tqsx3hrkka6YhiZ7urRiiQxhj6aWKG8/E/1t0QPf/J9WmCERIrguB4IkRXx3o9mLzaYVo3oYoSb7y1CdQGtV+d0EbDHg9Tkd8zPdrimJU3t8+QaP0PCXGXjXi/i81ga1u0l99+jUuHYjTa9rLflmsyscwGD8RUfJHIBYzdS4qmKnRbuMhYF55bI15/0FsK4l6vl252hz6x/2cI4BHovFFxTxGBc1mlPUYBa7XnzY+2G4hbkFKyN6k+TFzpYklxhDlZ2X5VhGmpyR7EHw0ceRO1eQjv0ceA+F71kUZ/pOUsaC/MD6MG9ppdrUbF+8oCHxQGI9A==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DS0PR02MB9273.namprd02.prod.outlook.com (2603:10b6:8:14b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sun, 18 Dec
 2022 19:12:40 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%5]) with mapi id 15.20.5924.016; Sun, 18 Dec 2022
 19:12:40 +0000
Message-ID: <53735f4b-a2fb-8fd3-3103-e96350867e40@nutanix.com>
Date:   Mon, 19 Dec 2022 00:42:27 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [RFC PATCH 0/1] QEMU: Dirty quota-based throttling of vcpus
To:     Hyman Huang <huangy81@chinatelecom.cn>,
        Peter Xu <peterx@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
 <0cde1cb7-7fce-c443-760c-2bb244e813fe@nutanix.com> <Y49nAjrD0uxUp+Ll@x1n>
 <8d245f68-e830-2566-2a33-b99f206c6773@chinatelecom.cn>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <8d245f68-e830-2566-2a33-b99f206c6773@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::19) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|DS0PR02MB9273:EE_
X-MS-Office365-Filtering-Correlation-Id: f3aab371-5622-41dd-a5ee-08dae12bd4ad
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIn3vt+3mL5ZXs4JMCCSZQ/ku9oTbwXTvw8EFEtJFseyGRD3CZXLtkt7Y2rDwgUprwZKReK67dj5Onp8sMRM7ijmWoH6cbUyog+N3y9C6JuEGwFC6Fdrs38JxwBiS6IqCyMF/4tn2uUhHttrOrk9o8vE30ACUcBMsUOs42/UMwMlcMxO2haXdBj2lfKIGcYQ37W8iRLz2verRnq0mLkcAEcmd76yx1kTzOaTt8TFbNrh9bCMshblsfZ2SxLBQoBU/lSFrrYOjtPAHtv2GOJ46R8GADXMZ04M1Isw8INRKf2Iq3hYIQvorU3HxEfsJ7RVx+fAeYrTsPARvhyJaD8EEFVdGr9MEJUiBuG2qwuVjpUtLOFd5DOCKNabFlfGabpBI15RhJQUBFeH0fLciBdCvgggCa9OGy2itGLI9QfLNIvhEI4iCSAOkJioi5yy779x90ZOWaRoJsAz5cdmjEIh6TGwHSpBL6hHDsaSxGzjWQu/G/lcrYxFg5RA+TQpdCMQArqqzUTGlXDiDskq37bIzhpeJUG3IQVD72kNZEQL6zqJuKCzT/T86uep/zxNH0pEefWbXD70Dr1PVEkE1XxZvhzLFUv/u1ut4tYcwnegOFF+iHnJmpe4nLPZI0XxvhdayTaJ4VIqTyzgpQrPXICLQp0kCtvRn9BW/DT+IGLZyy7jl7XvhHlegXVe4EvsK9HwLq3xLEjmmAZsF5zsebx6ozwQU2Tr+ybds3jS8u6H1K1vtxWgkCKvp00j6Yj5YoOwR7MAom2AKV9olsUxMuhLmeZchfVSsz+iMqU40FeqI8qomqbjTkXJqqkYMUkl8P1jDlUB2iBtN1kTuN6k2ueXEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199015)(31686004)(8676002)(5660300002)(4326008)(110136005)(15650500001)(66556008)(66946007)(2906002)(66476007)(6486002)(966005)(478600001)(6512007)(186003)(26005)(41300700001)(6506007)(6666004)(53546011)(86362001)(31696002)(83380400001)(2616005)(36756003)(8936002)(316002)(38100700002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkprNDhuZzhEUEI3MFkvcllaRGlXODl0NFI3RFdwbzQycWd4My9kTVNTb3V2?=
 =?utf-8?B?ZjR2aDNaOG9FZ1J4aGpoVU1DWk85RFhKUnZOU1VDTXZadk9XbDZ4NXN4K0kv?=
 =?utf-8?B?Zk1TaDRwQmJSUXczbmRmRjU4ZkJQNkVtZTdDT1k3WGMxUkgzR29OcnBvL1pG?=
 =?utf-8?B?UDFNYmVRbTN1WHpuT2NoeGpSQk1zTFZEUUEyQUY4NitwT2xGaHhJb3lZUEt5?=
 =?utf-8?B?bk83b3dLM0hnNE5XWUh6ekc5NldJclkxSUhhQmh2cWpBYVlRR0NrYzhtU0tt?=
 =?utf-8?B?VEl0ampxL2VsTTQyOXBRazFQSCtvZzB1SEViQklTZFRGc3hnbkVIeTBkazVs?=
 =?utf-8?B?bS9Gb1Q5MnZUUGRoc2dCWEZsbnc5NGxTN3RhbENjS3hWaUd0c3FFTmFYMUpB?=
 =?utf-8?B?VDJDdGRxOU1BT0l0c0wzekxMTnIzTXVqcUp6a2tlUk0vNzFTUm44MTBwRENi?=
 =?utf-8?B?cDlKOURHcUhpUm9zQVhWRlVjVUs2MzUrT0Z0VU1pbUVnS2RFdWRzM2FmUnVJ?=
 =?utf-8?B?RnhYQlZINzlnendOMFRPbGdHUHdQV3U3cmZwZitSN2MrVHlTeVBDL1o1Z3ZT?=
 =?utf-8?B?S2FsZkpaSTV5Ukw3N3o1dG1pdVJFVVlMd0xZZ0VvSkc3SUNuTTZ0aC9lZzlp?=
 =?utf-8?B?VGd4dWRnNm5SWHMwcnMwRDJmSllpeEs4Rnk4OGQ5emlCQ2xOdE4xN2VGbi9h?=
 =?utf-8?B?eEdvVlR6bmxzMjR5NmJkUExuZ1YycXA2SWZOdFdFcnYwOHJEa3dCWGhWeDJp?=
 =?utf-8?B?MUIwdEkxQ0ZFNDBRZ0VOMWsvVDVrM3NrVDhxWmxTbzJacUd3TjFoMHRIVFA1?=
 =?utf-8?B?TDB4Wmg2ZnhxRjAwNml4WkhrQlhRQWpqYWs3azFUL2RubXQxS0VYVE5OSmZw?=
 =?utf-8?B?VUFtOUh3SjZyQUlSNHV2ZU9qZmVxNC9uaUlIZTlka0NLeGI0MmgxT0RzcDJ6?=
 =?utf-8?B?a3NENDhjZ1FqN2xsUWhXdVdLQWNTYjZPZ1lEMnJ4RGJVZ2xzVWpyZlhxcTNY?=
 =?utf-8?B?dHBtd1kyNHFtdHlrS2JFNU5zUEN3WU40QUpkd2VKa1IzZzlVWkx6NTJGUGZF?=
 =?utf-8?B?Z3VYR3RLdUNpekNjSUZVQWs5cTZHQThqSTBYRk42bHNiR1JtNVZuSlV2SHJX?=
 =?utf-8?B?SkVMYVo5WElLUTg1ZWpyT3g5ckV1RzhNc1Vjcmtqai9YeEFNSUpqN291MWlj?=
 =?utf-8?B?QktpcDM3T1F0ejhDYWhUaXU4dUdoRjltQmZNeGNUbFNMVzF0MWxFbS9SZDI1?=
 =?utf-8?B?WjQzZ0UyMjBIWHVzR2lDWjZCUUdyOVdpSGdRNTQ5N25nNldxZmd4R2t3MFN6?=
 =?utf-8?B?anNMRTZFRHdGZllMbHNHbmY1cnNEREVnUzF2bmVQbWgxd2NwVnoxamw2Zklo?=
 =?utf-8?B?MTl6UmMzSkJWMlBnZWU4SDVRaUpjZjFHZFhWY2c1eXoxL0dhL0w3Qmd1NFpk?=
 =?utf-8?B?K0ZWS0xUOEFyKzFNVWl4TjJmQWVjU05SOEZSYkM1cHRzUjYvNUZJdDZHT1J3?=
 =?utf-8?B?bThPNEdkZTdJRzNWRGJxS0daemU4bUpjc0ZCMnEwZXhma2VRdnlZZ3c4Nklp?=
 =?utf-8?B?SU5mWDBGUzNwU2lmUnhQZ0dnMTY5aHpFcnRhaFdMQ21EWEo1bW8xWVhMMzZI?=
 =?utf-8?B?ZEowZWJjajRwWUY0RVFPeC83dWJkRkQwZ00rNlhQZzByV3MyRkREYVhucjY1?=
 =?utf-8?B?N0U3emlrYVlGVHZVcmFPZGVsNDgwbmo5NGJDYTlYNEFiOW01Ty9IU2x4Wit2?=
 =?utf-8?B?WXV3ZlBQTmRlMTRHeDRhalRnT2RjZEhwZWZhK2R1M2ljM2swdzdlbGFjbUZV?=
 =?utf-8?B?cVZXYVBhdkw2dUswSmRzOGFWZ2RhK1ZwQUQ2RGdHM05SOHVCa2xFdmxHRWx2?=
 =?utf-8?B?VjFxOWlxKzRFTmhzVmI3VFBZZUI5Yld0WWxZMnBjVUdqSmNPQU1iVklXZXdZ?=
 =?utf-8?B?SzNsMnZwc3dTS3RTSU5sWEsyZkJENFVkdWkyQXlISlc0eHZNZFd6emdSZFVL?=
 =?utf-8?B?N2VJTDhxbGJESGcyRkZkaWh4NWtxQkNrb2plaGNlY2Y1RUFJek5wdTBpdTZZ?=
 =?utf-8?B?U0JYSTl3aDJOaG1CWmpRV3htUmNvNkt6TGZzaG1PVXEzaW9WQ0x4MlNWNEdz?=
 =?utf-8?B?enkvSUR3dVdTWUxBbU5vdE40WHhCVFl1SVk5cnlCb0VHZm5UM1VCVVNYeXpC?=
 =?utf-8?B?SUE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3aab371-5622-41dd-a5ee-08dae12bd4ad
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2022 19:12:39.8882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63foukvRSA8AHWM0EUqp/+FqUworn7rOYhrUYj4uV0P9odAL/LrU0vmuVfz1am+WQjEeDVxP039YXCArRCeF3gFd08LThrkzS3Y2lq8XGpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9273
X-Proofpoint-ORIG-GUID: -UOjN-n7jBXWGWhBCQpdCkvmkx_4jPE_
X-Proofpoint-GUID: -UOjN-n7jBXWGWhBCQpdCkvmkx_4jPE_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-18_02,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/12/22 10:59 pm, Hyman Huang wrote:
> 
> 
> 在 2022/12/7 0:00, Peter Xu 写道:
>> Hi, Shivam,
>>
>> On Tue, Dec 06, 2022 at 11:18:52AM +0530, Shivam Kumar wrote:
>>
>> [...]
>>
>>>> Note
>>>> ----------
>>>> ----------
>>>>
>>>> We understand that there is a good scope of improvement in the current
>>>> implementation. Here is a list of things we are working on:
>>>> 1) Adding dirty quota as a migration capability so that it can be 
>>>> toggled
>>>> through QMP command.
>>>> 2) Adding support for throttling guest DMAs.
>>>> 3) Not enabling dirty quota for the first migration iteration.
>>
>> Agreed.
>>
>>>> 4) Falling back to current auto-converge based throttling in cases 
>>>> where dirty
>>>> quota throttling can overthrottle.
>>
>> If overthrottle happens, would auto-converge always be better?
>>
>>>>
>>>> Please stay tuned for the next patchset.
>>>>
>>>> Shivam Kumar (1):
>>>>     Dirty quota-based throttling of vcpus
>>>>
>>>>    accel/kvm/kvm-all.c       | 91 
>>>> +++++++++++++++++++++++++++++++++++++++
>>>>    include/exec/memory.h     |  3 ++
>>>>    include/hw/core/cpu.h     |  5 +++
>>>>    include/sysemu/kvm_int.h  |  1 +
>>>>    linux-headers/linux/kvm.h |  9 ++++
>>>>    migration/migration.c     | 22 ++++++++++
>>>>    migration/migration.h     | 31 +++++++++++++
>>>>    softmmu/memory.c          | 64 +++++++++++++++++++++++++++
>>>>    8 files changed, 226 insertions(+)
>>>>
>>>
>>> It'd be great if I could get some more feedback before I send v2. 
>>> Thanks.
>>
>> Sorry to respond late.
>>
>> What's the status of the kernel patchset?
>>
>>  From high level the approach looks good at least to me.  It's just 
>> that (as
>> I used to mention) we have two similar approaches now on throttling the
>> guest for precopy.  I'm not sure what's the best way to move forward if
>> without doing a comparison of the two.
>>
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_all_cover.1669047366.git.huangy81-40chinatelecom.cn_&d=DwIDaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=CuJmsk4azThm0mAIiykxHz3F9q4xRCxjXeS5Q00YL6-FSnPF_BKSyW1y8LIiXqRA&s=QjAcViWNO5THFQvljhrWbDX30yTipTb7KEKWKkc2kDU&e=
>> Sorry to say so, and no intention to create a contention, but merging the
>> two without any thought will definitely confuse everybody.  We need to
>> figure out a way.
>>
>>  From what I can tell..
>>
>> One way is we choose one of them which will be superior to the other and
>> all of us stick with it (for either higher possibility of migrate, less
>> interference to the workloads, and so on).
>>
>> The other way is we take both, when each of them may be suitable for
>> different scenarios.  However in this latter case, we'd better at 
>> least be
>> aware of the differences (which suites what), then that'll be part of
>> documentation we need for each of the features when the user wants to use
>> them.
>>
>> Add Yong into the loop.
>>
>> Any thoughts?
>>
> This is quite different from "dirtylimit capability of migration". IMHO, 
> quota-based implementation seems a little complicated, because it 
> depends on correctness of dirty quota and the measured data, which 
> involves the patchset both in qemu and kernel. It seems that dirtylimit 
> and quota-based are not mutually exclusive, at least we can figure out
> which suites what firstly depending on the test results as Peter said.
> 
Thank you for sharing the link to this alternate approach towards 
throttling - "dirtylimit capability of migration". I am sharing key 
points from my understanding and some questions below:

1) The alternate approach is exclusively for the dirty ring interface. 
The dirty quota approach is orthogonal to the dirty logging interface. 
It works both with the dirty ring and the dirty bitmap interface.

2) Can we achieve micro-stunning with the alternate approach? Can we say 
with good confidence that for most of the time, we stun the vcpu only 
when it is dirtying the memory? Last time when I checked, dirty ring 
size could be a multiple of 512 which makes it difficult to stun the 
vcpu in microscopic intervals.

3) Also, are we relying on the system administrator to select a limit on 
the dirty rate for "dirtylimit capability of migration"?

4) Also, does "dirtylimit capability of migration" play with the dirty 
ring size in a way that it uses a larger ring size for higher dirty rate 
limits and smaller ring size for smaller dirty rate limits? I think the 
dirty rate limit is good information to choose a good-enough dirty ring 
size.


Thanks,
Shivam

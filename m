Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58733B7310
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhF2NTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:19:52 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47468 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232487AbhF2NTv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:19:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TDBRcE026319;
        Tue, 29 Jun 2021 13:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RcDXZ6dApNEvP5P1J98c0u3zOdAqbR1j7wW5ikV1PvI=;
 b=hEtLQw2JTFbA601SKN5ARYjbp492g71tlFS5xN3Bwd8QzUPeA5kcJx/FPDkzttgFpXSx
 QdDIzOHo36NbREpKkBzCHUrM9sFfqMWi+XuUHaTY6o7X3HaktzSWenMcT6wPrpcT+Tn9
 eZZ7kMB3urVhpijgdP3iXU3/l3GSXMX43Oqe7FFjph45HNiQzoivJ/V1OvVNvWqK8PN8
 nrMrwzz6ipkeXtnG/RcoI5/eHO08VCQ/VEtm0D6Xtnh9yIUeudeKnA299bVUodTDJZZS
 FZgOM2EMV71Ttp1ncnqHnG4M6yBzkl5Q/26M59I7pau1hL2KqsO6l8gFBOi9V9itAtyJ vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f1hckwt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:17:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TDBia7117919;
        Tue, 29 Jun 2021 13:17:09 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3030.oracle.com with ESMTP id 39dsbxu572-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:17:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnF6P32LnJKGjCE14DlJhA1TqVJuJhE/a9lqTP2lX/u59+YYMQ97lfuz+SABVlQFkUGEb+kwHuLuSekks3p2Q1BOQ4fusMH9581j79sZawPdu6NHcfRLH0jCiEeoIH44LMoCurgK4binyIVT9C9g73y/MXlpmc47XBWWhyDb5VW0RG+ZORZuuWArEIRXG+EAIOdqzodtLQhkBy04j3zBPRY+LAmeFEkhJDjy3+OqHU7RVTrEczGcZAuhl2C22OmQ0f7iurlwfn2UPDXzjo6iWlUJPsMNcunX9B5SXlRsDhhsz9TbJ6CdzKS/hjce/82b5L7lP8obWZjN60QIBgKw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcDXZ6dApNEvP5P1J98c0u3zOdAqbR1j7wW5ikV1PvI=;
 b=abo/goLWIul1cUlc7L5iH0tBMn6ENl8/tbDkJ/Q6GFPvPgUkwHvl3Zm1tjNH+SlFnuQZdtayKpsaejD2+pjl9dInSTWJVKV63o/dxi56UdbmYEvpYUMFtYsOrp/zst1/9inFcv1jA1LLUychqvflo33AKjxhmpoxzf2H8r4ctJgGaauEtgs5wHrcR8GFPHpLFToU5/a1lNe96cPniAiDUKg6CPhZTyfvl5+2KbcIgpddaavImg2ibiLSB10pUUXUbwcOprIcSC8h5xjML2hz06pih5U/MO6p4iAQ+Xo4B8mULLQbH+30riYSmsE+QUXYrywHp5DUl1lVOIzXMNT+iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcDXZ6dApNEvP5P1J98c0u3zOdAqbR1j7wW5ikV1PvI=;
 b=i68ubukuX76YicjD9Ymt82LGxrSmypJ06+9SZbC2JDZKqz1uVvDlsir/fpqUCNHHEP+Dqi8YoO79TihFHmIvUccjqXDarNmvUuj/M7fQPwfJ6ylparMGrHYvdAt6kAZrbcOlMH6Rqn3zvB/YoHUXdi/707OHmjOabjPftMDVYf4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH2PR10MB3991.namprd10.prod.outlook.com (2603:10b6:610:e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Tue, 29 Jun
 2021 13:17:07 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::9490:e23f:3d15:9cd6%9]) with mapi id 15.20.4264.027; Tue, 29 Jun 2021
 13:17:07 +0000
Subject: Re: [PATCH] KVM: arm64: Disabling disabled PMU counters wastes a lot
 of time
To:     Marc Zyngier <maz@kernel.org>
Cc:     will@kernel.org, catalin.marinas@arm.com, alexandru.elisei@arm.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, konrad.wilk@oracle.com
References: <20210628161925.401343-1-alexandre.chartre@oracle.com>
 <878s2tavks.wl-maz@kernel.org>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Message-ID: <e3843c2c-e20a-ef58-c795-1ba8f1d91ff6@oracle.com>
Date:   Tue, 29 Jun 2021 15:16:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <878s2tavks.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2.7.202.103]
X-ClientProxiedBy: SG2PR04CA0141.apcprd04.prod.outlook.com
 (2603:1096:3:16::25) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2.7.202.103) by SG2PR04CA0141.apcprd04.prod.outlook.com (2603:1096:3:16::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 13:17:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c868bfb6-23a7-469d-197d-08d93b0031f0
X-MS-TrafficTypeDiagnostic: CH2PR10MB3991:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR10MB3991539A2E93E12C016118729A029@CH2PR10MB3991.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jo76veCOYMBTbNTvxb9piJSB7+3hy0cnW7gzU8oYC7I6r14VnCkbSqGtI/kSVe7VvUm6A2vO3+WsLsTLbrGgHfl6rAPm7M5KlvbJWKoo/C499IjiZVeN48e4/hnY0CwXsGOLtrEhS21M3YuM0y7k50HWOUptMTL9Z9qorRr9zzZyoI2a+ncT7Yl4Ds1lkjkjIDsDb5zA62sfld5GNZDx/Oxj6I2E5B6xU28w0y8PKXWdT9mLJeIfsqk2Zvc1qhacf96RytyeyeXWYt+CRbhD5QYv3KHR35AwDWrxcXw4amAA5ykTARe0gvl0P/iKIQV/zWjBprH31H+iUZ6q1bK6MMVOtfdfGs4dW9ULyifadnxLQlgBv1pXK4kbAfopRJjrepMb22NVtAi1TABj553NmKr8JHs2xSyeTf4aLUNU953Ys7HUSo8I474OLT4bCHXDAfKU0p9vkZLi5W0N0Rql6FgAE+bOtt/eAANdpzWHcr0/5WBd3FLqkvYDCf+wb5zuToPKdGevrCLMo8HlIEadMA8CeX29gjVTNG+96xvF6uQrGcRCQxqsWaONIa04/GhDCfaL2bQW9KlgzuqBtWhtN7htIOUQ8kavS0kIJUtxhU00pP0FovgfTP8TjAKLK29vW8VIRzaWegJPR/hfAYvpB7gl+oHrcjp+wEAqfCeN1fnLbriOk+dieAL8gEIpulAarnvheQ+sEweONUWSgha+D9tO4TrlRm9BGPMaLBwPrlU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(39860400002)(366004)(8936002)(4326008)(316002)(6916009)(5660300002)(6506007)(6512007)(8676002)(16526019)(107886003)(83380400001)(186003)(6666004)(6486002)(26005)(36756003)(38100700002)(53546011)(956004)(66946007)(478600001)(31696002)(86362001)(66556008)(31686004)(2906002)(66476007)(44832011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0hWTkp5eTZjUHNuNHFXdFcvQ0lSQTg1VjVsb2dZN3ZybkxoMmE4UW1KQStu?=
 =?utf-8?B?cmJQaldGWFFFV2hLeFZkR2RCL3ZZZzViYStlREs1eElZNnNsTnVPTXhVdzZB?=
 =?utf-8?B?NWVOUkZEclJJVWhodFBvT1RWOVo0RTU0RVhYVk1CZXhVVGpQZm5BSXl5eTNW?=
 =?utf-8?B?Q3lxZ2hOa3AwUmtma1lWWXFIQkNKUi9jRlUrOXBzRmthd1NPN1JEN3BOWkdm?=
 =?utf-8?B?enRYZVVOWTlYVXlWL2Z4c3R4b081czlQQ3htcGZFWnQ5bTM3aGIzKzduOHcw?=
 =?utf-8?B?MEQxOElHZ3p2a2VTczg3MDR3MzRnVHdwck5nbTQ0bkp6SkVyTnpuYUcxaGUy?=
 =?utf-8?B?MzJTcG1TTy9pNy8xN1p6RjlUK2Q3TkF3WTlhNDRORE0yMENvbTF5dlorZldV?=
 =?utf-8?B?d2ppSE80a1RnTThtZ0MvaCtPM2h6eGRKSVNxR3FNTXV1dE1mcjExNGZPaVl0?=
 =?utf-8?B?M3FBWTZxZzY0ZHdqN1RPZnp2WklKNDNacHJvaHZ3Vmo3ME1mTXp3YVZzVExU?=
 =?utf-8?B?Ynh5RXhUVlRib3d6aWhiQXF4UmhYWlFvMGJ1blpTeTBQV1BzZWN0VG9UODBp?=
 =?utf-8?B?M29YeG9MUWUzOEhkT29oNXo4MkFTYlY1bmh0QTRBOTYzR2pHTVhabjhFZzZP?=
 =?utf-8?B?b0c1eEw0UTFKMVU3aFZaTTFGSnIrV3drMjJCLzY5RE1ZTUR4eHV6eUc0bWVH?=
 =?utf-8?B?bTZHbjV6SWlTMXkxdDdBRERmRzF3eUswZG9uQzZaeitEL2Vla0IyTWxyODlG?=
 =?utf-8?B?ZVppY2s0YW81MlpEQkQ1d2JyK2pLUmtMS3lMUS9aVG1zZFFjM1EzZDArWEFN?=
 =?utf-8?B?TVhRZGkxU0w0a25NWHRmNVhVUlozUzFYdWlhK0RMZnl2RXZ3dmRqMHUyRnRX?=
 =?utf-8?B?dnNXNysyZm8weGlGYzMyUzJlZUlTQ3RzUEFxTmFBNlNtcTBrVE5nUmVFVGNL?=
 =?utf-8?B?MGNYZHRURTQwckxMdUJzb0w5WVBaYysxL0pvKzI0V1hHWTJKaGdlRnA1QzlJ?=
 =?utf-8?B?Rjhuc0dOU2VHTyswVWI1aTZONkt4TXNqN2pNWDlBcTYvVWt5b0lEWnRrcnI2?=
 =?utf-8?B?eUxvc0Z2eWVjUkRqWHZsOXUzOGVWVDhhVlI4dXJZZi90RzEvOFR3ZStkdUxP?=
 =?utf-8?B?VmRiSnJpWDhwemRDVWR1OWNMelJJZTMxVmdVNy9tNEVQbTd2ZDNkU0J1ZlRB?=
 =?utf-8?B?dVFraUFpMjNTWjZLY2tGY0UrS0JCM2EzYS9maTc2T2RKdWY2dUEzdE5lQm94?=
 =?utf-8?B?Y3pzQmpzYlgrc3FBdFhzRm9tZHJlUGRsTVIrRE41WGxDMFZSNkVkR0xvaHU3?=
 =?utf-8?B?M1BTMUdyWC9NMEt3TzViYU8reVBkcUgzQmRJbERXcUhYaE9saVFBS0lDQk1p?=
 =?utf-8?B?SkJNU011QlJCa1ovUWFCU1NtWkJUcG9BL1dEMVpUWkV2UDROS3NaZmdiRm8v?=
 =?utf-8?B?alJRVlRRZkJRaXllL1JvNXpFdzRYVnhJelIwcWVIeGVkR1I3UmR5ZHhmVE9q?=
 =?utf-8?B?aU9jRm12TTVKNDIyYVZ4ejRvV2l1TlFyTzVHUmR3Z0ZsSWZlQm5WdUJGM1VV?=
 =?utf-8?B?dzRqR3RqcUdMYW1uTTJWQ2ozZ2JDYXA4Tm5WWiswOVpyWG5OdlcvcVcxcUF2?=
 =?utf-8?B?eU4yTVp2TFY2Vlo1VUJ5dy9DQm53SVR6b1hYelgwMTBwc285QWZxVHEwRk9Y?=
 =?utf-8?B?MWhXR0d1ZGtMd2Z0VkkrLzhiT0hzenBQOVJuZ3lqVUNhNHU2ZTk4bFNPMHJw?=
 =?utf-8?Q?QeSp+/HUfBeLD4TE4vhfsB5Xyhmt2C355IhBj32?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c868bfb6-23a7-469d-197d-08d93b0031f0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 13:17:07.5265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBrCm7RWRkLNNJeJUYK7vuW2gtiZzbFReX7W7WwQ9sR88MbcU5eRW3qGLZ3mCysCHbi57hO8OVjV78mEyQOEPeU6R7fM4ccysvLW2d/hRg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3991
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290089
X-Proofpoint-ORIG-GUID: BVQy4lbUMyB5LMpJWyO_MX6YwnkYugXg
X-Proofpoint-GUID: BVQy4lbUMyB5LMpJWyO_MX6YwnkYugXg
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 6/29/21 11:06 AM, Marc Zyngier wrote:
> Hi Alexandre,
> 
> Thanks for looking into this.
> 
> On Mon, 28 Jun 2021 17:19:25 +0100,
> Alexandre Chartre <alexandre.chartre@oracle.com> wrote:
>>
>> In a KVM guest on ARM, performance counters interrupts have an
> 
> nit: arm64. 32bit ARM never had any working KVM PMU emulation.
>
>> unnecessary overhead which slows down execution when using the "perf
>> record" command and limits the "perf record" sampling period.
>>
>> The problem is that when a guest VM disables counters by clearing the
>> PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
>> PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.
>>
>> KVM disables a counter by calling into the perf framework, in particular
>> by calling perf_event_create_kernel_counter() which is a time consuming
>> operation. So, for example, with a Neoverse N1 CPU core which has 6 event
>> counters and one cycle counter, KVM will always disable all 7 counters
>> even if only one is enabled.
>>
>> This typically happens when using the "perf record" command in a guest
>> VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
>> uses the cycle counter. And when using the "perf record" -F option with
>> a high profiling frequency, the overhead of KVM disabling all counters
>> instead of one on every counter interrupt becomes very noticeable.
>>
>> The problem is fixed by having KVM disable only counters which are
>> enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
>> then KVM will not enable it when setting PMCR_EL0.E and it will remain
>> disable as long as it is not enabled in PMCNTENSET_EL0. So there is
> 
> nit: disabled
> 
>> effectively no need to disable a counter when clearing PMCR_EL0.E if it
>> is not enabled PMCNTENSET_EL0.
>>
>> Fixes: 76993739cd6f ("arm64: KVM: Add helper to handle PMCR register bits")
> 
> This isn't a fix (the current behaviour is correct per the
> architecture), "only" a performance improvement. We reserve "Fixes:"
> for things that are actually broken.
> 

Ok, I will change everything you mentioned about the commit message.


>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> ---
>>   arch/arm64/kvm/pmu-emul.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index fd167d4f4215..bab4b735a0cf 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -571,7 +571,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>>   		kvm_pmu_enable_counter_mask(vcpu,
>>   		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
>>   	} else {
>> -		kvm_pmu_disable_counter_mask(vcpu, mask);
>> +		kvm_pmu_disable_counter_mask(vcpu,
>> +		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
> 
> This seems to perpetuate a flawed pattern. Why do we need to work out
> the *valid* PMCTENSET_EL0 bits? They should be correct by construction,
> and the way the shadow sysreg gets populated already enforces this:
> 
> <quote>
> static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> 			   const struct sys_reg_desc *r)
> {
> [...]
> 	mask = kvm_pmu_valid_counter_mask(vcpu);
> 	if (p->is_write) {
> 		val = p->regval & mask;
> 		if (r->Op2 & 0x1) {
> 			/* accessing PMCNTENSET_EL0 */
> 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
> 			kvm_pmu_enable_counter_mask(vcpu, val);
> 			kvm_vcpu_pmu_restore_guest(vcpu);
> </quote>
> 
> So the sysreg is the only thing we should consider, and I think we
> should drop the useless masking. There is at least another instance of
> this in the PMU code (kvm_pmu_overflow_status()), and apart from
> kvm_pmu_vcpu_reset(), only the sysreg accessors should care about the
> masking to sanitise accesses.
> 
> What do you think?
> 

I think you are right. PMCNTENSET_EL0 is already masked with kvm_pmu_valid_counter_mask()
so there's effectively no need to mask it again when we use it. I will send an additional
patch (on top of this one) to remove useless masking. Basically, changes would be:

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index bab4b735a0cf..e0dfd7ce4ba0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -373,7 +373,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
                 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
                 reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
                 reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
-               reg &= kvm_pmu_valid_counter_mask(vcpu);
         }
  
         return reg;
@@ -564,21 +563,22 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
   */
  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
  {
-       unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
+       unsigned long mask;
         int i;
  
         if (val & ARMV8_PMU_PMCR_E) {
                 kvm_pmu_enable_counter_mask(vcpu,
-                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
+                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
         } else {
                 kvm_pmu_disable_counter_mask(vcpu,
-                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
+                      __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
         }
  
         if (val & ARMV8_PMU_PMCR_C)
                 kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
  
         if (val & ARMV8_PMU_PMCR_P) {
+               mask = kvm_pmu_valid_counter_mask(vcpu);
                 for_each_set_bit(i, &mask, 32)
                         kvm_pmu_set_counter_value(vcpu, i, 0);
         }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1a7968ad078c..2e406905760e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -845,7 +845,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
                         kvm_pmu_disable_counter_mask(vcpu, val);
                 }
         } else {
-               p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+               p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
         }
  
         return true;


Thanks,

alex.

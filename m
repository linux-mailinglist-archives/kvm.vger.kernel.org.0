Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E86047BDE1
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 11:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhLUKHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 05:07:48 -0500
Received: from mail-co1nam11on2106.outbound.protection.outlook.com ([40.107.220.106]:44193
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230018AbhLUKHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 05:07:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3mlJqxUJzE47s/VChg281IzhjdtxRSRP3zpGK657k9TjApec5zbSs45uPea7hqkF7IlSR6OH7kndDhAIFy6TCobVRX0LpFWxdNFZ+KzIXecJKotlfxs4yuFoNCh9ICjqU7RYWxk2I4kRhPTlyUUOUzwuVEaIbOlLsPzu4dB9otKjb+ba/+q+XRDB75p1/xnstgZtjTgAxHZxUe8aGJH+v+allyZ2d8iU9+DcuYnLNZJth5/SKKX6Qz292mR1breEsamb8BrpQELyUnaGY5nYdp+VGBLtRYkzAx/yBAexNPEGS21alt7Mojf9U3op3DcMGHl5p+ZcSe3OPuReyQ3hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Q4hF2QHJZ4cfkiBIZGalcEkvaCqA7RVpZdxRW/Tkyk=;
 b=e+VXJAdBYNJIyV4JbOg26E8yphoDhumAAutcarsAw0ckj38dYI1AsBKFYtF9iRFiy/ZMDHVA9mVc2ESP17AqzrQP6P54ICUiA7WTzzWuCboZ69OSrKvCsHvDO+ChOBdotJ3Zbc/Zz31YL89KI/zuG4+mIjrMiYAHKvhjAzUh6JGkupg58FD2QzE9IlQ7PuyddJzM3h19cYvz2b+4XYXkDG/ZNj4RM1vOai7V31PqkB9KB8ErSB1TkwuIIYOjXn+v/rc/37W1pghD4BKFNIIXTKWEpoXLDiSV1uP1BdwZ73F1M+hFCjlh1QoeE64OJvr6/+5gUL/r66Y694oX/muXpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q4hF2QHJZ4cfkiBIZGalcEkvaCqA7RVpZdxRW/Tkyk=;
 b=nFPDSfFr/PE5ML0rGbYHeLAy5Kf3oPz9dGygcU7FvB6dDlOErNFN+LOlCrwuIGDvKYMUfskGZdZ4nNwGKPmW+jA2thgFbayDJR9RI80sxilbVqqUsduNrJEyuekRuqtw3zJja2OLm2UP+MClYZbspr9wLjpGx55ihTp4JdamUoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR0102MB3560.prod.exchangelabs.com (2603:10b6:4:a3::39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Tue, 21 Dec 2021 10:07:45 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 10:07:44 +0000
Message-ID: <59c7280d-0e09-a5b5-b566-41771919e031@os.amperecomputing.com>
Date:   Tue, 21 Dec 2021 15:37:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 36/69] KVM: arm64: nv: Filter out unsupported features
 from ID regs
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-37-maz@kernel.org>
 <e850857c-9cab-8e16-0568-acb513514ae8@os.amperecomputing.com>
 <87h7b3wqe9.wl-maz@kernel.org>
 <ef667048-7fbe-55dc-9856-546fd9d3c690@os.amperecomputing.com>
 <87zgouuxvy.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87zgouuxvy.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:610:119::16) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46426eda-fff1-4177-0c84-08d9c469bba3
X-MS-TrafficTypeDiagnostic: DM5PR0102MB3560:EE_
X-Microsoft-Antispam-PRVS: <DM5PR0102MB3560AA246DDBEE0779E03E1D9C7C9@DM5PR0102MB3560.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTKg7z4+KkPDPhj/Tsi9OjPugumrHsKJchIVSI0Y5Gj/dLAKchsluAWPgLHmqQMJQDeE9aTjhPSEis6B60rp+g0NeIQ2ULT2FyHd9s6m8iLgZRS7BVj4AZOwTOWfzNU6LlLp/v0YmcnkAhSmastGoLCmDnoHDRnIITa1NjaZ8l2eEsOg2ySB5l9/L8PuWZpZ+uf9j8vthyVPhuGBejD4RZ7ptyvCBIbBtJ1lSsXfdB3FXeRw/bSVdIZFPsDy5DQJs6Wb5choW86eiVt7EBH+JXjJr6JDEtdlqW3IRSJy+Ni13jpDs1LgOcR/JtTu3igHPILaBOLiCFcOK6MXzvVPEUwlC6GhJLP4A8A3a4MAXOHrHkaKDOSXpC2rXUCcX5i4j0Ssu5xSZVrhvBwV5D8fCJh2Hd1CtTFIi5/I9zF6AnMgXeLp7OfZQuACcxoK4M9Nuk4GirfiPvCNR4M6gE5637jesmEOA+hwZFu85OT5IVQihCO8v5Gq9twem+HdQQomKby9uE25PMaHm1J74xByt7mv15F99NNwZ7gMZOWZzLbHC4SHY2nfC7K2MmTuc+LztD5NfcGbnZTlC+IxyTtlcy4qma+RY0eaVRAvJrG5SyQi9/wTVjMroeG+HSh7IEGgC/z79yEG0DXMxzJ0Idp29ebidaOCN+kI8EOBNMs1ioycerKTGiegWHT4RBj5C1eOuVALBKUKr5VNmFbwpdgGPFkNJKqSMmbHEcJvyF+znAA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(4326008)(6666004)(55236004)(31696002)(52116002)(31686004)(186003)(83380400001)(8936002)(508600001)(66476007)(6506007)(54906003)(53546011)(66946007)(8676002)(86362001)(2906002)(66556008)(5660300002)(6916009)(38350700002)(38100700002)(6512007)(316002)(6486002)(26005)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1k5WENwN3ZrL082TWpZV2VGbFRWNjFnMjdOa1JQMitLaXNDNSs5Vlo0RmFD?=
 =?utf-8?B?aWVsU1phMHpOaVR2d202RGxlMk9iNjlGcjRrZjM0clRRZ1dDWCt0S2c5cjFP?=
 =?utf-8?B?R2NrV0lRbkZTZUpJL2FlV2ZhTzY2Q0pLQU41U1YxRDBmYlkzZEdvRUtXeWsv?=
 =?utf-8?B?ZlhseGIxQkdpT0dLN1gxcGo0UjVFK2pKd3pFeDlLTFRjZGVHV2VqZnFkT1dq?=
 =?utf-8?B?MjlhRUo5cGRLR3YrZXZoMUpFVXdhWmZUajl4c1J6OFFwbUdyTlJUd2pkb0V2?=
 =?utf-8?B?dkN0QXNRWWtMc0lwT0g4K2plSzJucWFnTjNFM2Vmb3ZwRUtERFA1cWNkK1Ar?=
 =?utf-8?B?aHNvc1FjS09HL1p4YnNNTUd5dWZzSytHUFlRczZjc20xMjUwVmxxVno5OG5z?=
 =?utf-8?B?eFM5Z0dpeTZmRS9ONStRR1JibWhwdHJoMFpuazB0TlhUdlFuQUNzL0xQc1FK?=
 =?utf-8?B?TXlKSWZoQ1czNlRXOVdEZ29GRDMyOWRtYUVsdzJ0WHEvOHBTRnNzckpXTFN2?=
 =?utf-8?B?VnZhd2NTdVRSSld1V2RHTGE3dUFJdUNsWm9aeEwvK20xdkFsdU1vMnA0NWpE?=
 =?utf-8?B?Z3d5NVFvODVVbHNWSlhtUGtxOG1YeGlHY1VOSmJOam5iV2lSanR5MWM2cjJF?=
 =?utf-8?B?eW12aTdWdTZCQXRuWCs4TXRnNlRWSHFTbTNudkxCTUduYURocHF6MXQwVUxV?=
 =?utf-8?B?RnpDWDV0N20vSGdqUEJ4MjAwZzhxM3NRWm5BdStPZ3UwYkVMZzRud2dndFFZ?=
 =?utf-8?B?bGlJVmU1ZGdPYjhyMjZWdTdwd3BOTVh0dUs0QzFqaWZ2dnpZYktTdXVDcDBE?=
 =?utf-8?B?TnVZQ2ZyYmwvMkhFTno1MDlyYnh3aFZCWWZ2bjZwUjU3bDduZXZtV1F1UU5U?=
 =?utf-8?B?RkNOdmUrdkpJbG5obUpodE56QmlZOVFPZVBVc1J4cXk0N2NaaWp1T3NDcVR4?=
 =?utf-8?B?cjNCZ2U1dG9NaUMxYU5pRkJjOGNVaHR6clZpc2hLaVgxbEJXcXA3c05NTEUv?=
 =?utf-8?B?OE9ZRzJLNGxITytSVVhIcDk1V3c1anNaZnBFbmpiamE5c3l3U1JpaEZuM0hN?=
 =?utf-8?B?RGVMWVJoUVF2aFRDMVhhaFhVQzhQaktyM2hGT0VJb25UeHBOemNnZkFoYUF0?=
 =?utf-8?B?bUNBVHJvTzROT0E0eTJHelhGekRDbTF0N1dTR3llM05iMGJzTEt1UzVCYzJi?=
 =?utf-8?B?MllRclluS1RGM3k1TVpiM05nWUk0bzZZWFZhV1ZSVEZFc29lMlpCN0dlbll2?=
 =?utf-8?B?RFNkU1BvZXNJSnVyMjNyRXpDZ3Y3QU9EeVZzMzBmL0JFUUdsalRKclV4TzVx?=
 =?utf-8?B?RnlCK3BnekF0dlpKako1QzNVSERnZGYzOUk0dDJLTVJONDFLeGxkVnFLaGo3?=
 =?utf-8?B?Nkk5SUdpdGFiekxwL056d0xLbXE5eWZONnRwak9LdExodXZKSFVSK3NTeFVw?=
 =?utf-8?B?bFlkdElSNTljR1NvaTllZCtUd3IzcWViSFllTTRsWFV5WXJST3Q2NkQxR1Mz?=
 =?utf-8?B?aTFZUjBTT1UxaEtuU1M4TUEveTRmMEVyTlVvT0VOaExvRVNQM3BzN0VxdDZH?=
 =?utf-8?B?bXZzNHpCT2dWVCtJU2xkUW9EVTZIazZkdWRjN210SFVFWHR1Y2tkQk1ma3Nw?=
 =?utf-8?B?ZTlkRmVZc2ZwUHJPYzRYblNRMUJ2ZHQ4MkkwbGRtdXNySEo3R2U1cGJwTjR6?=
 =?utf-8?B?dnlHNlF3aDZpdHJ6NFlDS3o3VUlaRFZldExtL0g0bGMrQ0xBR2o5VENwUmZL?=
 =?utf-8?B?MUJWNTBHSkNpY3dNd1V6YVJZakcyRHlacElQak1Bc2dSZGZIZWZidDlmcnVE?=
 =?utf-8?B?MWd5Vkg2VEJ0QWtJbWd3U0E5eGtVTDQ2cDFlcFM5OStjWFRCUkliT1lpMzR0?=
 =?utf-8?B?ek1EMWxCZHJDbGF4V1pRTnVHYUZYQkZMVGNwWWg0UDBaeGFlVkM1MGhDbEx0?=
 =?utf-8?B?UStHQkx2KzU0M2JvaFhxRGMrcldLT0g4eUpTUk1EbDNuOU81WVZMaEQwQXlB?=
 =?utf-8?B?Y1VBa1lZVzFiVHV4RGNhN0s2T285TEFHN2YyMlc1UWV1NngyNEZ1U3dTWFJL?=
 =?utf-8?B?dkdjTmE0S3g0aFc5ZEZIMXZPdEhkQWNJYmI2NGVBWXBQSDIxSzBPUGk0U3ZF?=
 =?utf-8?B?S0tDSXhkWmVCOGJjeEZMdnhpWFhvQ0JtUFdLNGFDZjhLaG83TTkzWjd0QWdk?=
 =?utf-8?B?RHJ5R1EwYlZsQnlmU3hBSTcwS1lNUUZyV3VreDNBMjRyY3g3YXdUTHpmam5P?=
 =?utf-8?B?ZDNUT1RoVWlPM0R4U2preVRMWW5VZVZlNVV4OXhQSXRNMEFiNkt0RGo1SWE2?=
 =?utf-8?B?eUZiNFg0RVREQ3dEaVZsaDl5RGV0MVlzVXpaS2Z3MkhxbGpTVUo1Zz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46426eda-fff1-4177-0c84-08d9c469bba3
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 10:07:44.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibOSlTFH74DZDgPpQR3YCKt4NAABKxB6xQwNaszLR5xQB3l52liwjw1eZD7ofoQ3bV9W5avtUYDsTYjg46Cyf9+g7+QYQ9yrAh4TZVGpfxdzGISoX09LBhYhPRD1rYCU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0102MB3560
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21-12-2021 02:40 pm, Marc Zyngier wrote:
> On Tue, 21 Dec 2021 06:03:49 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 20-12-2021 03:26 pm, Marc Zyngier wrote:
>>> On Mon, 20 Dec 2021 07:26:50 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>> On 30-11-2021 01:31 am, Marc Zyngier wrote:
>>>>> As there is a number of features that we either can't support,
>>>>> or don't want to support right away with NV, let's add some
>>>>> basic filtering so that we don't advertize silly things to the
>>>>> EL2 guest.
>>>>>
>>>>> Whilst we are at it, avertize ARMv8.4-TTL as well as ARMv8.5-GTG.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>>     arch/arm64/include/asm/kvm_nested.h |   6 ++
>>>>>     arch/arm64/kvm/nested.c             | 152 ++++++++++++++++++++++++++++
>>>>>     arch/arm64/kvm/sys_regs.c           |   4 +-
>>>>>     arch/arm64/kvm/sys_regs.h           |   2 +
>>>>>     4 files changed, 163 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>>>>> index 07c15f51cf86..026ddaad972c 100644
>>>>> --- a/arch/arm64/include/asm/kvm_nested.h
>>>>> +++ b/arch/arm64/include/asm/kvm_nested.h
>>>>> @@ -67,4 +67,10 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>>>>>     extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>>>>>     extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>>>>>     +struct sys_reg_params;
>>>>> +struct sys_reg_desc;
>>>>> +
>>>>> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>>>>> +			  const struct sys_reg_desc *r);
>>>>> +
>>>>>     #endif /* __ARM64_KVM_NESTED_H */
>>>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>>>> index 42a96c8d2adc..19b674983e13 100644
>>>>> --- a/arch/arm64/kvm/nested.c
>>>>> +++ b/arch/arm64/kvm/nested.c
>>>>> @@ -20,6 +20,10 @@
>>>>>     #include <linux/kvm_host.h>
>>>>>       #include <asm/kvm_emulate.h>
>>>>> +#include <asm/kvm_nested.h>
>>>>> +#include <asm/sysreg.h>
>>>>> +
>>>>> +#include "sys_regs.h"
>>>>>       /*
>>>>>      * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>>>>> @@ -38,3 +42,151 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>>>>>       	return -EINVAL;
>>>>>     }
>>>>> +
>>>>> +/*
>>>>> + * Our emulated CPU doesn't support all the possible features. For the
>>>>> + * sake of simplicity (and probably mental sanity), wipe out a number
>>>>> + * of feature bits we don't intend to support for the time being.
>>>>> + * This list should get updated as new features get added to the NV
>>>>> + * support, and new extension to the architecture.
>>>>> + */
>>>>> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>>>>> +			  const struct sys_reg_desc *r)
>>>>> +{
>>>>> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>>>>> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>>>>> +	u64 val, tmp;
>>>>> +
>>>>> +	if (!nested_virt_in_use(v))
>>>>> +		return;
>>>>> +
>>>>> +	val = p->regval;
>>>>> +
>>>>> +	switch (id) {
>>>>> +	case SYS_ID_AA64ISAR0_EL1:
>>>>> +		/* Support everything but O.S. and Range TLBIs */
>>>>> +		val &= ~(FEATURE(ID_AA64ISAR0_TLB)	|
>>>>> +			 GENMASK_ULL(27, 24)		|
>>>>> +			 GENMASK_ULL(3, 0));
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64ISAR1_EL1:
>>>>> +		/* Support everything but PtrAuth and Spec Invalidation */
>>>>> +		val &= ~(GENMASK_ULL(63, 56)		|
>>>>> +			 FEATURE(ID_AA64ISAR1_SPECRES)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_GPI)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_GPA)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_API)	|
>>>>> +			 FEATURE(ID_AA64ISAR1_APA));
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64PFR0_EL1:
>>>>> +		/* No AMU, MPAM, S-EL2, RAS or SVE */
>>>>> +		val &= ~(GENMASK_ULL(55, 52)		|
>>>>> +			 FEATURE(ID_AA64PFR0_AMU)	|
>>>>> +			 FEATURE(ID_AA64PFR0_MPAM)	|
>>>>> +			 FEATURE(ID_AA64PFR0_SEL2)	|
>>>>> +			 FEATURE(ID_AA64PFR0_RAS)	|
>>>>> +			 FEATURE(ID_AA64PFR0_SVE)	|
>>>>> +			 FEATURE(ID_AA64PFR0_EL3)	|
>>>>> +			 FEATURE(ID_AA64PFR0_EL2));
>>>>> +		/* 64bit EL2/EL3 only */
>>>>> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
>>>>> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), 0b0001);
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64PFR1_EL1:
>>>>> +		/* Only support SSBS */
>>>>> +		val &= FEATURE(ID_AA64PFR1_SSBS);
>>>>> +		break;
>>>>> +
>>>>> +	case SYS_ID_AA64MMFR0_EL1:
>>>>> +		/* Hide ECV, FGT, ExS, Secure Memory */
>>>>> +		val &= ~(GENMASK_ULL(63, 43)			|
>>>>> +			 FEATURE(ID_AA64MMFR0_TGRAN4_2)		|
>>>>> +			 FEATURE(ID_AA64MMFR0_TGRAN16_2)	|
>>>>> +			 FEATURE(ID_AA64MMFR0_TGRAN64_2)	|
>>>>> +			 FEATURE(ID_AA64MMFR0_SNSMEM));
>>>>> +
>>>>> +		/* Disallow unsupported S2 page sizes */
>>>>> +		switch (PAGE_SIZE) {
>>>>> +		case SZ_64K:
>>>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
>>>>> +			fallthrough;
>>>>> +		case SZ_16K:
>>>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
>>>>> +			fallthrough;
>>>>> +		case SZ_4K:
>>>>> +			/* Support everything */
>>>>> +			break;
>>>>> +		}
>>>>
>>>> It seems to me that Host hypervisor(L0) has to boot with 4KB page size
>>>> to support all (4, 16 and 64KB) page sizes at L1, any specific reason
>>>> for this restriction?
>>>
>>> Well, yes.
>>>
>>> If you have a L0 that has booted with (let's say) 64kB page size, how
>>> do you provide S2 mappings with 4kB granularity so that you can
>>> implement the permissions that a L1 guest hypervisor can impose on its
>>> own guest, given that KVM currently mandates S1 and S2 to use the same
>>> page sizes?
>>>
>>> You can't. That's why we tell the guest hypervisor how much we
>>> support, and the guest hypervisor can decide to go ahead or not
>>> depending on what it does.
>>>
>>> If one day we can support S2 mappings that are smaller than the host
>>> page sizes, then we'll be able to allow to advertise all page sizes.
>>> But I wouldn't hold my breath for this to happen.
>>
>> Thanks for the detailed explanation!.
>> Can we put one line comment that explains why this manipulation?
>> It would be helpful to see a comment like S2 PAGE_SIZE should be
>> at-least the size of Host PAGE_SIZE?
> 
> Can do, but we need to get the terminology straight, because this is
> very quickly becoming confusing. Something like:
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7c9dd1edf011..d35a947f5679 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -850,7 +850,12 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>   			/* Support everything */
>   			break;
>   		}
> -		/* Advertize supported S2 page sizes */
> +		/*
> +		 * Since we can't support a guest S2 page size smaller than
> +		 * the host's own page size (due to KVM only populating its
> +		 * own S2 using the kernel's page size), advertise the
> +		 * limitation using FEAT_GTG.

Thanks this helps!.
> +		 */
>   		switch (PAGE_SIZE) {
>   		case SZ_4K:
>   			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
> 
> So not quite a one line comment! ;-)
Indeed, thanks.
> 
> Ultimately, all there is to know is in the description of FEAT_GTG in
> the ARMv8 ARM.
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

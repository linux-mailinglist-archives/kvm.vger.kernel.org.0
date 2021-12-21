Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2747B9D4
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 07:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhLUGEB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 01:04:01 -0500
Received: from mail-dm6nam10on2126.outbound.protection.outlook.com ([40.107.93.126]:31137
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229698AbhLUGEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 01:04:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or1vPFUAAP+321Bqvsg/0f6wBTNy26Xxqf8NxUxt3oJJvX0iapn5ySSod2dZnQ47i1uR3XFvq6qvgi0l6iq8lIZ4Z1rXiw4at4RNH27+oNri2wBQ93PE70yQUdyojwXlXiqHHNBfrFrHV5Xsw2fyw/WFW/aEAaPpbO9TC89UoalnA0x7y+wJXIVZEdRDTOVDgxsSVNSTbPNc3BZ18F8ow0Qdh8wE88crL50NqY0Nqt/eFkLndbz98fIgOQ1ndOQiLII5sxF1a7FqCizGQAi03F7C0tYyVdm5tE74y0uXNl50rCCholsfJLXJvewNtqNVbLFnJ+/1Ks6Yj2QCGMKBgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wC/PgYAXA4OesG27brlcqFG7c2R4NEwXwymaJ07Aqg=;
 b=U7Jdf+S152fAusxBQ0qqGAIwVGZ6meps8R28LhEHYyjsV5t3DozhKxYH94sdQWg/kayp3t5N7WLzttDTAmcYOQ0waCSYQT6cKkIBxWqh/5fxjIasfC3w+DLWEyNnQT7t5ozXo4NSynfclP7jLH+YBIguEaIOukHn0fx70Ns88Noyh1hiHUcA8F1RidbUtTPwGIjBPKVhRBNAQUjaGDb8XiuYIx+/xts+BzBi2VfbBUMO0BccOqnHvKBhUUrXCdNSD3wRgDbimtzlPej2QG/xvBAPpSMLG7aoFHHEI71fgnei216ru91hevUGaVcbnG0mZOKC9P0gzBJp5TSLbXyOIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wC/PgYAXA4OesG27brlcqFG7c2R4NEwXwymaJ07Aqg=;
 b=I/cosRlmBXv0cDWbXSrDOwBwUitJfynEIkkqyYNa40qEW8RPMA2R2IY0FrXlDmCJR6rctZmamdTweoco3pGcNaQXS1fgI/2E1grI7oL1OYEYr37U0Dv0P/VjH3AvbMi3cRqq8vtLAl2Hf4fu8KqSqAKzqxjmIvPN5FsODvfYr/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB4665.prod.exchangelabs.com (2603:10b6:5:64::14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.20; Tue, 21 Dec 2021 06:03:58 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 06:03:57 +0000
Message-ID: <ef667048-7fbe-55dc-9856-546fd9d3c690@os.amperecomputing.com>
Date:   Tue, 21 Dec 2021 11:33:49 +0530
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
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87h7b3wqe9.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY5PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:930:1c::30) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a174ff5e-e96d-4091-253d-08d9c447ad1f
X-MS-TrafficTypeDiagnostic: DM6PR01MB4665:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB4665B290BBD7C28E19BF26969C7C9@DM6PR01MB4665.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UKfShkcphLznKVmB/lkgSBnliPPDq9LwlJk9wbB13phdBJLIUuyLunNvtcK/K07S5GvZaqDdVUNMI7eLLntzQbUJB1cq5NdZ/V57HHB4LWlAnTiBV5CGHeWmApLvtm7kY6Fu+xHLx4tJ5+ofNeaOjlCgJMrgL0GgyI8fiVQ3UurgGnzLeSC8LGayHisdn/6NJh27Ti0onG3//RRUm/Ne7j66+6ij/zOxOpoT4UP+/CHor6FpMmaMM9aDrTp90DZrWxYy2eWCI0U3V9myXtfyRRCVjZ3J8KAeDbUT5CKZkin4wnjC7QGKNZSxT0AlDE2s097F7+OJJnymwE94xwG5/vCCxDErn8Ysct3r8ZbO/irR6JC3DDe0iWRzvf07arz4Y2QcPmK3wJus+pd5i5vDBDVWL+NwnwTwDamkrvvSRebNvPYOrqVN5dornZUc4aBtyLSXFVkrn9Pr0ktUCPqGVJmcwnhNmv9JxC9l8bNthj/2NH8uDNawDtX3En+FgXWonl7ar68SADgGuLTVEplbfMn+iIAiXxvjF/3UYyLsakpeKitYR4cthgc/wAkVaf5ktzPGYKw2wXNOUSgu49+MboHNRRLCv2jTNTR5o8WX6REu9U7+XvAJZ1NGmbMD6wyiPapUG7sJvs+vEnJEGsC6JcWu1br04TeY96GIXicAaYTreVKmp1zKyUhjJpigP5ZGrcB9Jiz6I2eqI+ltOcM7lkSK7Ab5MU9nQO9mhTaGRTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(86362001)(8936002)(2616005)(54906003)(6486002)(186003)(83380400001)(53546011)(31686004)(508600001)(5660300002)(2906002)(31696002)(6506007)(4326008)(38100700002)(7416002)(8676002)(52116002)(6512007)(38350700002)(6666004)(66556008)(66476007)(26005)(6916009)(55236004)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEc2SEtJdkFFOWdtdGI5ZUYvUkdFczJxZHQ2aGlpcWJWQ0E3U3BsV3NneENB?=
 =?utf-8?B?VXlMdElscmtZU0hMaCtQOTlmTEFiMEtKNHZwYXFvMnc3SEN5WVZuVTMyNmdV?=
 =?utf-8?B?Y0JVVVpKK3VrNXJDNnR5RHFNNUgzemxLMlFIdVVXQmhqSzJ1S2RXdWhQNEIr?=
 =?utf-8?B?d043ZXJyMXFJZ3NXZHpYZTB6SmRFLy9jTkM4SFZ1disyY0o5a21IeFNMc1Uy?=
 =?utf-8?B?YU56a3RiNE80VjFHaGhwdFhncWJMWmQ0cDZMY0Q3T3grVW54d2kwVTVpNnNS?=
 =?utf-8?B?eHBpeEo4S1FmMVJBOE1KY0J4RXlod0xPZnorbWd2Z2ZuRHBmZGx6VHJGNGhL?=
 =?utf-8?B?QllScGtJT09YVEtHTXRvb05RYk5kb1NVUmhlM3I5QUNyVEQzbTFXZitFd1Jk?=
 =?utf-8?B?U1Njd1lKa1lzRE9SQUtqMnp2QUlqWk5hN1pLQ3d4UVBuNmV0R1RWOWU3NkVu?=
 =?utf-8?B?S2lRWTNGZzM2RTgvSC9EWE5vUzY3b2ZoVVdPc3NVSFlCK1JxcktWcStwVlFN?=
 =?utf-8?B?ellVaTkzelNRRkFTZmJWaFB2S21DWGpPMG5yakM0WVhHc0hVTlVKNHpscitp?=
 =?utf-8?B?MFhzbElOeGk3RlpyMWJUYitHditFVjV2ZjkrU01WMHNhZ3VLSnV1UVhGT0Vq?=
 =?utf-8?B?MXN1UVNRMkswQ0VjMGdTSHhkWnc2NSt2QzlOSGR4VzFRRXI5TGk4K1ozL0o4?=
 =?utf-8?B?VlR5bjllMmZPUHFXTU1GbFVHamh3bDJrV1hKR1BQZE5hTmd3elIxd1JlSVNV?=
 =?utf-8?B?a211bGFOMUJaV01Icm85T3Q1YnNLNnRtT2JQRmlNaFRnbDVSdERqZjRFNU5a?=
 =?utf-8?B?YStuVDc2WDNleUUzQ3FjbnFoQm4rQUJFQU9VbkkwaWpoUndyZHdGbXRyUFdQ?=
 =?utf-8?B?bEluMm1oTmhzcjl5YjBNY0tNdkI0eWJrY0VFU3NSQk15ekozaXVmTEFiUVBR?=
 =?utf-8?B?NGtqTWRlUm5QK2RrRWNKOGNBd0Y1d093aDhUbm1ua2xXY0t5bmExeVRpOTE4?=
 =?utf-8?B?cWZaS2tTSU1CZDJWT0RvSTRZZ1J0ak00SHJGaWYySWdLdlA2eGwyM0JiQkNK?=
 =?utf-8?B?OG0rL3VOSW5NaXRVbURTM1BoVStlOWFRa29vdkRrTW4wWTlsb2MrdVp2WERH?=
 =?utf-8?B?NXFYaFduYnBUMitVbk1xNVd4SFNSMmkvdGxTQzRTNHIxdFVydkszajRzb3Iv?=
 =?utf-8?B?TS82RXlrTDFNQzAzOUNITGVBckVwelI5MlgwWlRSZWxnRmlVYldQQUcwMnFr?=
 =?utf-8?B?bUtvcmplQVhzWE1MSEhxMDY2VHdQVzIzVzZ0U2JXSHdQY0IyemVvQ0Jaam4z?=
 =?utf-8?B?QlR5emNjcXJUbjExbWtLY0NYRjBSYkpUUnIvQVFUUDYyam9PSytmWFRGNzEv?=
 =?utf-8?B?VkJmbDRxK1UxNmRnUkpMc0JZa28vTjIybTY2MVdjcUxabW5sZkx1bVF1VGFw?=
 =?utf-8?B?bjd1UWJuQXQzVEswTitGUDc1dGswWjBVQjJQYUs4U21YTVhaaFlvbm1PcW9t?=
 =?utf-8?B?aHJhdDdRZjRucVUyVGhqUzFRYXBPMWlDeXR0Z0p3L3Jyd0I5VUdmL0JFTmY3?=
 =?utf-8?B?blF3N0dtUzlCSVVZRnJYTHE4SmRYYWhxNW83R0U0VXI0dENMd29IdTVxa1ZT?=
 =?utf-8?B?UmNkTWFFNXh3dTdQN3Y0NXVzRUdBOCtCLzZSZGtXL0tNU2tuN0hNQTZ5N0dN?=
 =?utf-8?B?cVZta0NDMlowRmlaYlVCUVFlS0hwcE5SWmVkM05jZWZZWkRJOHNEcjhjTWRY?=
 =?utf-8?B?ZW1hL2lsMHBmU0NRY2V4MUNLU1ZIM3B6Y1FTNTJpbHJxdlRTWFNCWFpjR05w?=
 =?utf-8?B?WVBpczYyaWZwMXp0bkJRdjZrUUtlZ2xmTmtEUHlZaE5kaXZLU28rVHBTTTNC?=
 =?utf-8?B?VVlsbHlleGIvUVFyRUh3YzRTZkY5NVlIMktzMExXUTQ1Y05tMkg5NnNXSk9Y?=
 =?utf-8?B?SDE3QzZKd1BnUjhQYVp3RkhqL1pJMFE4T3MyempVZXpSTXFBMXJqQVpoM2hM?=
 =?utf-8?B?K3NsVDhXVHEwQWRrc010SDRXTlJNWERyTy9vUGdMNlU2YklNOC9FcURhQ29U?=
 =?utf-8?B?U2ZoL2JTZUlDWmpnanRzUTVISEdDNllPaUZKWEhtcnJvak14aDExSVdtSnlQ?=
 =?utf-8?B?WGdnSytJYU1UVVNvYWU1Z0E1WFYya1dZRkdVV0FYbEVNMy82bkhUSnErNDl1?=
 =?utf-8?B?RXVDQmZiSzExQW9HUERiMXNWU2hpbGVoQWNmdFFST3RaeVM2WjR3blZscWRa?=
 =?utf-8?B?OWd5dWtVODlsOGhoY1ZqL1JFQ2U3bTlLRTMwbUxhdkJ0ek9kbk5NOFNOeFFX?=
 =?utf-8?B?OWd0NjBJKzg5Q0dJaGpSYjEydkRTN0xXcXg2SWhMMGFFNlNaUlFDUT09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a174ff5e-e96d-4091-253d-08d9c447ad1f
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 06:03:57.7732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WB4miYaA71pdyVGjkCdOoJT1X7t08AIX7pPpvKUVewSIJJ1rqzYKaDkXeYmLY0TZmhJpZINCko922nhI+r5p7MAhW5e1kdj+S1x2CObqF94Ye5ZkPNCNl7RPsP7O6Ki
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4665
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20-12-2021 03:26 pm, Marc Zyngier wrote:
> On Mon, 20 Dec 2021 07:26:50 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> Hi Marc,
>>
>> On 30-11-2021 01:31 am, Marc Zyngier wrote:
>>> As there is a number of features that we either can't support,
>>> or don't want to support right away with NV, let's add some
>>> basic filtering so that we don't advertize silly things to the
>>> EL2 guest.
>>>
>>> Whilst we are at it, avertize ARMv8.4-TTL as well as ARMv8.5-GTG.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>    arch/arm64/include/asm/kvm_nested.h |   6 ++
>>>    arch/arm64/kvm/nested.c             | 152 ++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/sys_regs.c           |   4 +-
>>>    arch/arm64/kvm/sys_regs.h           |   2 +
>>>    4 files changed, 163 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
>>> index 07c15f51cf86..026ddaad972c 100644
>>> --- a/arch/arm64/include/asm/kvm_nested.h
>>> +++ b/arch/arm64/include/asm/kvm_nested.h
>>> @@ -67,4 +67,10 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>>>    extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>>>    extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>>>    +struct sys_reg_params;
>>> +struct sys_reg_desc;
>>> +
>>> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>>> +			  const struct sys_reg_desc *r);
>>> +
>>>    #endif /* __ARM64_KVM_NESTED_H */
>>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>>> index 42a96c8d2adc..19b674983e13 100644
>>> --- a/arch/arm64/kvm/nested.c
>>> +++ b/arch/arm64/kvm/nested.c
>>> @@ -20,6 +20,10 @@
>>>    #include <linux/kvm_host.h>
>>>      #include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_nested.h>
>>> +#include <asm/sysreg.h>
>>> +
>>> +#include "sys_regs.h"
>>>      /*
>>>     * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
>>> @@ -38,3 +42,151 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>>>      	return -EINVAL;
>>>    }
>>> +
>>> +/*
>>> + * Our emulated CPU doesn't support all the possible features. For the
>>> + * sake of simplicity (and probably mental sanity), wipe out a number
>>> + * of feature bits we don't intend to support for the time being.
>>> + * This list should get updated as new features get added to the NV
>>> + * support, and new extension to the architecture.
>>> + */
>>> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>>> +			  const struct sys_reg_desc *r)
>>> +{
>>> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>>> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>>> +	u64 val, tmp;
>>> +
>>> +	if (!nested_virt_in_use(v))
>>> +		return;
>>> +
>>> +	val = p->regval;
>>> +
>>> +	switch (id) {
>>> +	case SYS_ID_AA64ISAR0_EL1:
>>> +		/* Support everything but O.S. and Range TLBIs */
>>> +		val &= ~(FEATURE(ID_AA64ISAR0_TLB)	|
>>> +			 GENMASK_ULL(27, 24)		|
>>> +			 GENMASK_ULL(3, 0));
>>> +		break;
>>> +
>>> +	case SYS_ID_AA64ISAR1_EL1:
>>> +		/* Support everything but PtrAuth and Spec Invalidation */
>>> +		val &= ~(GENMASK_ULL(63, 56)		|
>>> +			 FEATURE(ID_AA64ISAR1_SPECRES)	|
>>> +			 FEATURE(ID_AA64ISAR1_GPI)	|
>>> +			 FEATURE(ID_AA64ISAR1_GPA)	|
>>> +			 FEATURE(ID_AA64ISAR1_API)	|
>>> +			 FEATURE(ID_AA64ISAR1_APA));
>>> +		break;
>>> +
>>> +	case SYS_ID_AA64PFR0_EL1:
>>> +		/* No AMU, MPAM, S-EL2, RAS or SVE */
>>> +		val &= ~(GENMASK_ULL(55, 52)		|
>>> +			 FEATURE(ID_AA64PFR0_AMU)	|
>>> +			 FEATURE(ID_AA64PFR0_MPAM)	|
>>> +			 FEATURE(ID_AA64PFR0_SEL2)	|
>>> +			 FEATURE(ID_AA64PFR0_RAS)	|
>>> +			 FEATURE(ID_AA64PFR0_SVE)	|
>>> +			 FEATURE(ID_AA64PFR0_EL3)	|
>>> +			 FEATURE(ID_AA64PFR0_EL2));
>>> +		/* 64bit EL2/EL3 only */
>>> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
>>> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), 0b0001);
>>> +		break;
>>> +
>>> +	case SYS_ID_AA64PFR1_EL1:
>>> +		/* Only support SSBS */
>>> +		val &= FEATURE(ID_AA64PFR1_SSBS);
>>> +		break;
>>> +
>>> +	case SYS_ID_AA64MMFR0_EL1:
>>> +		/* Hide ECV, FGT, ExS, Secure Memory */
>>> +		val &= ~(GENMASK_ULL(63, 43)			|
>>> +			 FEATURE(ID_AA64MMFR0_TGRAN4_2)		|
>>> +			 FEATURE(ID_AA64MMFR0_TGRAN16_2)	|
>>> +			 FEATURE(ID_AA64MMFR0_TGRAN64_2)	|
>>> +			 FEATURE(ID_AA64MMFR0_SNSMEM));
>>> +
>>> +		/* Disallow unsupported S2 page sizes */
>>> +		switch (PAGE_SIZE) {
>>> +		case SZ_64K:
>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
>>> +			fallthrough;
>>> +		case SZ_16K:
>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
>>> +			fallthrough;
>>> +		case SZ_4K:
>>> +			/* Support everything */
>>> +			break;
>>> +		}
>>
>> It seems to me that Host hypervisor(L0) has to boot with 4KB page size
>> to support all (4, 16 and 64KB) page sizes at L1, any specific reason
>> for this restriction?
> 
> Well, yes.
> 
> If you have a L0 that has booted with (let's say) 64kB page size, how
> do you provide S2 mappings with 4kB granularity so that you can
> implement the permissions that a L1 guest hypervisor can impose on its
> own guest, given that KVM currently mandates S1 and S2 to use the same
> page sizes?
> 
> You can't. That's why we tell the guest hypervisor how much we
> support, and the guest hypervisor can decide to go ahead or not
> depending on what it does.
> 
> If one day we can support S2 mappings that are smaller than the host
> page sizes, then we'll be able to allow to advertise all page sizes.
> But I wouldn't hold my breath for this to happen.

Thanks for the detailed explanation!.
Can we put one line comment that explains why this manipulation?
It would be helpful to see a comment like S2 PAGE_SIZE should be
at-least the size of Host PAGE_SIZE?

> 
>>
>>> +		/* Advertize supported S2 page sizes */
>>> +		switch (PAGE_SIZE) {
>>> +		case SZ_4K:
>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
>>> +			fallthrough;
>>> +		case SZ_16K:
>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0010);
>>> +			fallthrough;
>>> +		case SZ_64K:
>>> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64_2), 0b0010);
>>> +			break;
>>> +		}
>>> +		/* Cap PARange to 40bits */
>>
>> Any specific reasons for the 40 bit cap?
> 
> The only platform this currently runs on is a model, and 1TB of
> address space is what it supports. At some point, this will require
> userspace involvement to set it up, but we're not quite ready for that
> either. And given that there is no HW, the urge for changing this is
> extremely limited.
Makes sense, thanks.

Please feel free to add.
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

> 
> 	M.
> 

Thanks,
Ganapat

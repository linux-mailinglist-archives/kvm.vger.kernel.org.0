Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D53483FD5
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 11:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiADKYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 05:24:17 -0500
Received: from mail-bn1nam07on2134.outbound.protection.outlook.com ([40.107.212.134]:29797
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229983AbiADKYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 05:24:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ky83k/wH0OPdMAiD66xHP5Oc9em1jHaSA759ru00IbfgyEmHgciD9SCPkhyVnVSOfkQt+dFvkjwDrzuUVqwDVX/C9RQgmQ5Cn/vl5lp+SBZxubqRIX5+1smYzkmFvzBI92F0vIZf87b57f+dTqYNyUAyaQ1HmJ/bRTZ0fiUK+MMiSUBxHJUKNAX0GVEoxXP1vg+ilbva07xEAduaaF/mMKQKiYlo9odHfPucpdLPTGo4KLLGppnM55G0lDvjKFJfILGRk5NgoW9gXLuv34X712a9xyK80EMrepMnWxETDuTG3UdgrUTqe0e8EjQknWLn/VCQdZqGCgPTlFzQZMQFMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVRK5jJSmmOEHseEeSBgSLEWlrRFMWhU+up5hTKwuk0=;
 b=PdsgEdUOYz2ddltlInYWLGzdXefdNNYs7y/bHt/rqDZqHmVswhKzQDGDCPwtCVvV8SD5dG5hflIErC3Ggi/xKHV9njlb+AZclF8lSuTiFvRPa39Ymv4RX3ht4rvPU+3yOkxaCsKjQLqzj6no3NCDA5wBehBCqKhM1N/xIBHb981q4z6QYykxoY43RzzK+eK38aCrvX8qoezqlW/V4lIo5P0HclkqvHayTm+T8/S8YYmqlb5XvcMMKqxFXecUIpoI64i9aMkzyjDGHl37zTTxqcY8ywlnoXu+jHVp6cmVDLo6Yhol8R0xnuj3kmPMxwyABxIh6LLTaHMcNuynz3r/9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVRK5jJSmmOEHseEeSBgSLEWlrRFMWhU+up5hTKwuk0=;
 b=gdBKs6OLq3yve3rBTkxO/gQqZEo/6OM4a+rGHr5i8TgZ7YJIbbqzFWUbXyaIIjNckysobMq2Pjp1zLs73dCxQFW30+6C3iQxfgpPbnOsQGDGv+miS6hZ5o72WNOPhN7SyP86pCMCGHpVHhdIJ76ROJJ0YJb2eecRb7EemKN9VVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM6PR01MB3674.prod.exchangelabs.com (2603:10b6:5:8b::12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.16; Tue, 4 Jan 2022 10:24:11 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4867.007; Tue, 4 Jan 2022
 10:24:11 +0000
Message-ID: <8102049c-7dad-e52b-482b-c1a1fd6b53fd@os.amperecomputing.com>
Date:   Tue, 4 Jan 2022 15:54:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 36/69] KVM: arm64: nv: Filter out unsupported features
 from ID regs
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-37-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20211129200150.351436-37-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:610:76::25) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44fdfb48-c9ae-4480-c768-08d9cf6c596b
X-MS-TrafficTypeDiagnostic: DM6PR01MB3674:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB3674F813DAFED4BFCA6CA7969C4A9@DM6PR01MB3674.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CQNUDbdZhIQxfB0f1KThnsnaWwxrJc4r7JEHXV7Djc6PSuJmoKbbQJjpUxuTqsIAYerWVohZYQY/e//kjz5O+tZJSMrqwXWSri3x4g5Q4QYQj3W83hao5Ww51ZtuP2zTRTM62KaRCrZrp3bgh/GxA8jhky3x9c+lm/mlYtkKXekKAVFPrmS7Yy/qin1wrmkjyYja4SxGI5tt8w2Dc4F9Su4zv3IOxZguiDEOaFJajSOasjvazPvRDKDWK4R9/g7qtKmvm0k3V1rIYx8/f9oDOxxL3md4qcjVO4rnmuJPvmlVobNE2/EMoakEWveRknfmDwRnp3hGLDQRYO6R8XTQsEWPrbtcVfhs2N9NccYhLz9jPpoXdyK3F+jacMI1pbSnydxp25Dg77FKiaI5ujVtFkaDQUB5pWVpBiW4JRhIB0KTptCXO1jqdwZYZF8v3GXdWnw/+5D+IgUh9QZlDFetzupcLZANnyjHA9cFYZ/FfEXxLnkgZEN1QK/yBdRHp9FG/KTfJrC9yviB7uniKFfBZy3heW4ovhUq4Ce92IePfsglsABMA73raIU9l2uCv0oVyFMvSZ4NXoCXnRKmKbPJYOvNald/HT1muW8+80/6vplTsIQi4Y1WIQ5tizlcbu5ImchB+8dD+5q2YR+Uwp6R1IXiGoHA54iAC7nDYUojaQbA8LyMEqIb8Fx5behaZPudcenoNpXbnTnEfo99pHAJ+tOk9hy4CUbftu86UoOS/jg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(83380400001)(4326008)(6512007)(5660300002)(38100700002)(31686004)(54906003)(26005)(7416002)(52116002)(6486002)(38350700002)(8676002)(2616005)(2906002)(53546011)(86362001)(6506007)(8936002)(186003)(66476007)(31696002)(66946007)(66556008)(6666004)(508600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUtwQlJKYWwvZE81cmFVUi9WTVpwa29ySk5LcTRNMUQ1VUVFMFNCT3ZyTlZX?=
 =?utf-8?B?MVdIUEp6N3FuL3FIcUhFMnltZnFUanlrbFByMG1RWnE5K1pwUVlzZGx6M1NR?=
 =?utf-8?B?a0dMWmtkR1cwR2Q0T01nNjR4djg0ajVNMjZrSXRCeE5zRlptZjN4QlNEazJt?=
 =?utf-8?B?UHgzN211NTdyN2JZQ1kreEZkYVZjZ1IrVmdJUlZDNnNkbXFTRC9HZXE4OEJt?=
 =?utf-8?B?cElDTjFlYkhXRGZydjB5OFhjUjM4Wkg4ZS9naDJ1dDRFbHpFOVRjZzdJTWhD?=
 =?utf-8?B?VWRqbEs0cnV3V0JmMU5JbStvbzF3STZVYVhlVEduODB6TEhDVloyZlhxalMw?=
 =?utf-8?B?V0RkZ21CNzVlZTRnTllYamNzTFkxSXNVaXd0OUxGY3R3QlJzandua0lrRGc5?=
 =?utf-8?B?U0V3dTAxT2p1bmY0SDlDYjd2RVVLeDM1cUVVVllLL2JGYk03TzZOaTJVdjV5?=
 =?utf-8?B?a1hBdFZlTTlPNXN3dEVvOHFROFJsbkZDV3JGSTJOTldCOVIvWUJMRkFIbG1Z?=
 =?utf-8?B?V2FMa3pBZjA1TnFsU2dIdndoQmtCOHpmcXlvTVdvRVFzQWNCNmQvcGNjK1ds?=
 =?utf-8?B?RllWL0IyVEpFcFdEVDhRTDZuK20zbkVhS3EwTHphQkdTSW1Xbm9odERrdHZ1?=
 =?utf-8?B?SlNJU0dqQ0ZEdkJ5MDRtMGw2MklBVEJ2bTNKc05waEJzLzlDSGd3MWhmdDFE?=
 =?utf-8?B?V2JMdTRzVmxuSHA2eGMvTjIvVTZRRmgyMnI1WmNRVGRLY2l1Wjd5Wk0wOUkw?=
 =?utf-8?B?MFBXNnl0OCt1Nno5VU8zS2FWdkY2V1Rub2dOdmtlWkxnbElDdktOcmtoVkxv?=
 =?utf-8?B?L2NsNitsNjBmTm45SnNvZUV1UFNlUGdBdG5MZ1AzemFRb1NsM3Q3cUtpNDUv?=
 =?utf-8?B?cVZsQStwQi81VHRFUzladzFZV2VyUkh6K3Jwa0xjVk1hY3hTb1V2Zm1nQU1o?=
 =?utf-8?B?M3ZWcHh4a2o3ZDVXUk5JVEIraXZoQUw3THJOOEpYTi8vZ1pDdHVVMmFZUzla?=
 =?utf-8?B?dnJHaXlNc3N1RHU0aSszYm5NVjNuL1EzbGw1ZTZJeVhhVUZUL1VjZEpVQ214?=
 =?utf-8?B?OUdEcFZMZERGY0ZOOWJISmdBWEpTWXJTbEZVbHkyZitxMzZmUTdvMVlkay9Q?=
 =?utf-8?B?Rjg3ZkVNQ1gyUjVKd3R6VVZiREZ2YmkyWlZZdUR4U0krRXBIVjd5M3VDeGFm?=
 =?utf-8?B?eEdHODRldk5KL1FqVlI5UUd0TzlUcmVDNTJYTHFETVBtTkc1eFphT1k0UUlN?=
 =?utf-8?B?MTV5bWJvK1VkdkF0M3dxL3pJc2ltNFN1VHVGa1JKNjJJL0puZm4yODl5czdi?=
 =?utf-8?B?VkJ1WFFnemU0OGVub1QvaHhoa2FWbmdOZyt4amVPS1RRbW1FS2Z0ZEFPL0dw?=
 =?utf-8?B?NGh1MmZ4aFRhMkhyWXR4aVhkMkh0WjNPVk5QZnlhTlNHbEVTNXVQV1Zrdk8w?=
 =?utf-8?B?WGRtY2xpeDFhN2dRNDlqRG5DeTdrV0tRaTN4NEpYWUpxSDBWRHFOMk1ONlR3?=
 =?utf-8?B?Z2luM0xUQmludFVlL2lUTG85VmpvQ2pJRzlpVGRGYTNSNWNsa0NMalU1QWNq?=
 =?utf-8?B?ckxiZVcyYlNIRVFkWFYzNUdwOG85N3FGOS83V3hBdkExZFVONWJiWGhVZW9E?=
 =?utf-8?B?cWhxd0owbDY4eW9tS1Q3aU04ZVBUMzd6aENUZGovQzROVHV0dzVxN3RmMkN1?=
 =?utf-8?B?K0NESmtvN1hrN21LUkdyOUtxNGZtRm9Rc0hkbXlCY25oOU1RU2tlUzI2dDFH?=
 =?utf-8?B?QWRQNGs5T1pVSXdIdGI2L0JaaWk3NzFhWEF2QUxvQTBQOXJMbDFnbUJDeW5N?=
 =?utf-8?B?TDZyY3lFdC9Qd092aGp2UXlwZVNPK1QwM0NCYm1pNjQweUgrMS84UmsrUUxv?=
 =?utf-8?B?cy9HOXNzTGJMT2xwN3N4emU5eTRBRCs5Mk9odEdpQW0zbk9NU09NVXBSd3Fm?=
 =?utf-8?B?eHJySUsyM3JwZzB4cjFJZ3RGeldmREpOMnhlOWVqMklmanppb1FEQk9aNjU4?=
 =?utf-8?B?cWtweFlmdnZ1L3MzS3Z3aFJMNWxqOVBhRUtlUFNuclp3WHgvQklCZTRNSi8x?=
 =?utf-8?B?YnFjMkJsVUxsNkcwdHIxL3krQ04vbHJtOTlIQXBxOUx4YS91bEpEZ2o0Q3Mv?=
 =?utf-8?B?cnhMM2tkdXltV2NNOHo3RExLQUg0Y2ViUEJpVHF6OTRlZWlWbENBdURNakpV?=
 =?utf-8?B?dEpBTThUdTdEV25wUVhocVMyRytBaFRmY21Xb0NvRzdtbW9qWkNhWXB0a1dY?=
 =?utf-8?B?VFgrOHNKL1kxYm5aT3Z0T2g2NTVpZ3NTcG5IWjBIaElyZVJLNk5DWDA3dnFM?=
 =?utf-8?B?V1JvQU5BeHltSTN1cEdBNmRLNDY4RTdHdDg5aHMzVzI0MWQrMU5ydz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fdfb48-c9ae-4480-c768-08d9cf6c596b
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 10:24:11.4539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDgk+2D7K1u1O9CxS8OHcjjc7l0xkOA7cc+KNdM60Fy6V9sEeFBaoTovtxlMix9AuqIyjQ8TWGk5eMA0c1QrLWRwCqjxgk7ERRMhAg1rx0siT7dvHeXq/fSLkamTlans
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3674
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30-11-2021 01:31 am, Marc Zyngier wrote:
> As there is a number of features that we either can't support,
> or don't want to support right away with NV, let's add some
> basic filtering so that we don't advertize silly things to the
> EL2 guest.
> 
> Whilst we are at it, avertize ARMv8.4-TTL as well as ARMv8.5-GTG.
> 

Typo: advertize.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_nested.h |   6 ++
>   arch/arm64/kvm/nested.c             | 152 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c           |   4 +-
>   arch/arm64/kvm/sys_regs.h           |   2 +
>   4 files changed, 163 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 07c15f51cf86..026ddaad972c 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -67,4 +67,10 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
>   extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>   extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>   
> +struct sys_reg_params;
> +struct sys_reg_desc;
> +
> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r);
> +
>   #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 42a96c8d2adc..19b674983e13 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -20,6 +20,10 @@
>   #include <linux/kvm_host.h>
>   
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
> +#include <asm/sysreg.h>
> +
> +#include "sys_regs.h"
>   
>   /*
>    * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
> @@ -38,3 +42,151 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>   
>   	return -EINVAL;
>   }
> +
> +/*
> + * Our emulated CPU doesn't support all the possible features. For the
> + * sake of simplicity (and probably mental sanity), wipe out a number
> + * of feature bits we don't intend to support for the time being.
> + * This list should get updated as new features get added to the NV
> + * support, and new extension to the architecture.
> + */
> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> +	u64 val, tmp;
> +
> +	if (!nested_virt_in_use(v))
> +		return;
> +
> +	val = p->regval;
> +
> +	switch (id) {
> +	case SYS_ID_AA64ISAR0_EL1:
> +		/* Support everything but O.S. and Range TLBIs */
> +		val &= ~(FEATURE(ID_AA64ISAR0_TLB)	|
> +			 GENMASK_ULL(27, 24)		|
> +			 GENMASK_ULL(3, 0));
> +		break;
> +
> +	case SYS_ID_AA64ISAR1_EL1:
> +		/* Support everything but PtrAuth and Spec Invalidation */
> +		val &= ~(GENMASK_ULL(63, 56)		|
> +			 FEATURE(ID_AA64ISAR1_SPECRES)	|
> +			 FEATURE(ID_AA64ISAR1_GPI)	|
> +			 FEATURE(ID_AA64ISAR1_GPA)	|
> +			 FEATURE(ID_AA64ISAR1_API)	|
> +			 FEATURE(ID_AA64ISAR1_APA));
> +		break;
> +
> +	case SYS_ID_AA64PFR0_EL1:
> +		/* No AMU, MPAM, S-EL2, RAS or SVE */
> +		val &= ~(GENMASK_ULL(55, 52)		|
> +			 FEATURE(ID_AA64PFR0_AMU)	|
> +			 FEATURE(ID_AA64PFR0_MPAM)	|
> +			 FEATURE(ID_AA64PFR0_SEL2)	|
> +			 FEATURE(ID_AA64PFR0_RAS)	|
> +			 FEATURE(ID_AA64PFR0_SVE)	|
> +			 FEATURE(ID_AA64PFR0_EL3)	|
> +			 FEATURE(ID_AA64PFR0_EL2));
> +		/* 64bit EL2/EL3 only */
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), 0b0001);
> +		break;
> +
> +	case SYS_ID_AA64PFR1_EL1:
> +		/* Only support SSBS */
> +		val &= FEATURE(ID_AA64PFR1_SSBS);
> +		break;
> +
> +	case SYS_ID_AA64MMFR0_EL1:
> +		/* Hide ECV, FGT, ExS, Secure Memory */
> +		val &= ~(GENMASK_ULL(63, 43)			|
> +			 FEATURE(ID_AA64MMFR0_TGRAN4_2)		|
> +			 FEATURE(ID_AA64MMFR0_TGRAN16_2)	|
> +			 FEATURE(ID_AA64MMFR0_TGRAN64_2)	|
> +			 FEATURE(ID_AA64MMFR0_SNSMEM));
> +
> +		/* Disallow unsupported S2 page sizes */
> +		switch (PAGE_SIZE) {
> +		case SZ_64K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
> +			fallthrough;
> +		case SZ_16K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
> +			fallthrough;
> +		case SZ_4K:
> +			/* Support everything */
> +			break;
> +		}
> +		/* Advertize supported S2 page sizes */
> +		switch (PAGE_SIZE) {
> +		case SZ_4K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
> +			fallthrough;
> +		case SZ_16K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0010);
> +			fallthrough;
> +		case SZ_64K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64_2), 0b0010);
> +			break;
> +		}
> +		/* Cap PARange to 40bits */
> +		tmp = FIELD_GET(FEATURE(ID_AA64MMFR0_PARANGE), val);
> +		if (tmp > 0b0010) {
> +			val &= ~FEATURE(ID_AA64MMFR0_PARANGE);
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), 0b0010);
> +		}
> +		break;
> +
> +	case SYS_ID_AA64MMFR1_EL1:
> +		val &= (FEATURE(ID_AA64MMFR1_PAN)	|
> +			FEATURE(ID_AA64MMFR1_LOR)	|
> +			FEATURE(ID_AA64MMFR1_HPD)	|
> +			FEATURE(ID_AA64MMFR1_VHE)	|
> +			FEATURE(ID_AA64MMFR1_VMIDBITS));
> +		break;
> +
> +	case SYS_ID_AA64MMFR2_EL1:
> +		val &= ~(FEATURE(ID_AA64MMFR2_EVT)	|
> +			 FEATURE(ID_AA64MMFR2_BBM)	|
> +			 FEATURE(ID_AA64MMFR2_TTL)	|
> +			 GENMASK_ULL(47, 44)		|
> +			 FEATURE(ID_AA64MMFR2_ST)	|
> +			 FEATURE(ID_AA64MMFR2_CCIDX)	|
> +			 FEATURE(ID_AA64MMFR2_LVA));
> +
> +		/* Force TTL support */
> +		val |= FIELD_PREP(FEATURE(ID_AA64MMFR2_TTL), 0b0001);
> +		break;
> +
> +	case SYS_ID_AA64DFR0_EL1:
> +		/* Only limited support for PMU, Debug, BPs and WPs */
> +		val &= (FEATURE(ID_AA64DFR0_PMSVER)	|
> +			FEATURE(ID_AA64DFR0_WRPS)	|
> +			FEATURE(ID_AA64DFR0_BRPS)	|
> +			FEATURE(ID_AA64DFR0_DEBUGVER));
> +
> +		/* Cap PMU to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), val);
> +		if (tmp > 0b0100) {
> +			val &= ~FEATURE(ID_AA64DFR0_PMUVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 0b0100);
> +		}
> +		/* Cap Debug to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_DEBUGVER), val);
> +		if (tmp > 0b0111) {
> +			val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 0b0111);
> +		}
> +		break;
> +
> +	default:
> +		/* Unknown register, just wipe it clean */
> +		val = 0;
> +		break;
> +	}
> +
> +	p->regval = val;
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9deedd5a058f..19b33ccb61b8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1431,8 +1431,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
>   			  const struct sys_reg_desc *r)
>   {
>   	bool raz = sysreg_visible_as_raz(vcpu, r);
> +	bool ret = __access_id_reg(vcpu, p, r, raz);
>   
> -	return __access_id_reg(vcpu, p, r, raz);
> +	access_nested_id_reg(vcpu, p, r);
> +	return ret;
>   }
>   
>   static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index cc0cc95a0280..d260c26b1834 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -201,4 +201,6 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
>   	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
>   	Op2(sys_reg_Op2(reg))
>   
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> +
>   #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */

Thanks,
Ganapat

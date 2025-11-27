Return-Path: <kvm+bounces-64872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB9BC8E737
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 14:25:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 12FB534E43D
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 13:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5E826E6F5;
	Thu, 27 Nov 2025 13:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="YL5fV4xE"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7A7257830;
	Thu, 27 Nov 2025 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764249898; cv=none; b=HupOVs7jo73JTkUTI22vd93NaPVarmXc9XJeFXa6Mt2CGTyX6SCaVV66Er9Gsg7JKjnDvY5IbJyZDE1Hg/OfPfSqzwYp/q+pETZQwiHtiraVHIyMvvmvj89T5ffHaVtDuG18PJVIdOoJlp4lgvOSgcPnFPo1rOQZFZT9cmavsfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764249898; c=relaxed/simple;
	bh=T22MT9sNX0B7VhOc3iByahuQoPBWnd3sIX3AcLzNiq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=B9fDSMKl3JgcaSzu9KaP3ibMe3crkPAWNnvsEWSezPiyXgnudjFDR4VG8gU+nOdYiHnOevmK5zvcpw9twHP0X60pD+YaxmKT1mmXlvPvAbue5zeqnuAlfZc8lb+Lc8M1ZPgmUC/xiCXRkv2m37aQTDFEfwOgsM3ALDGkzuOncj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=YL5fV4xE; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Cr+5Rr5BPGPR1wepA4s78G0eot3R+UDHLBx6NzzwIjI=;
	b=YL5fV4xE2L/eeoILrrBxV1N7dJlTDocQg0tVtTBqhVHiGJrFZMev0VDQVSkZDLhAl5URyZjV6
	VQCw6nI6aUOb4X9C0BIMdUaw/4AdNcInkYZSSv1Kdl5IBbQh+bdShVt+y1tS1SvduD4FKY51aMv
	3Z8zAxjGW7zojq71QEmAais=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dHHDQ5hXhzKm4J;
	Thu, 27 Nov 2025 21:23:02 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 1009E1401F4;
	Thu, 27 Nov 2025 21:24:52 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 27 Nov 2025 21:24:51 +0800
Message-ID: <694b6f79-8306-46fb-9f4b-c30afd114210@huawei.com>
Date: Thu, 27 Nov 2025 21:24:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] KVM: arm64: Add support for FEAT_HDBSS
To: Marc Zyngier <maz@kernel.org>, Tian Zheng <zhengtian10@huawei.com>
CC: <oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<pbonzini@redhat.com>, <will@kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-4-zhengtian10@huawei.com>
 <86tsymqjwb.wl-maz@kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <86tsymqjwb.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 2025/11/22 21:25, Marc Zyngier wrote:
> On Fri, 21 Nov 2025 09:23:40 +0000,
> Tian Zheng <zhengtian10@huawei.com> wrote:
>>
>> From: eillon <yezhenyu2@huawei.com>
>>
>> Armv9.5 introduces the Hardware Dirty Bit State Structure (HDBSS) feature,
>> indicated by ID_AA64MMFR1_EL1.HAFDBS == 0b0100.
>>
>> Add the Kconfig for FEAT_HDBSS and support detecting and enabling the
>> feature. A CPU capability is added to notify the user of the feature.
>>
>> Add KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl and basic framework for
>> ARM64 HDBSS support. Since the HDBSS buffer size is configurable and
>> cannot be determined at KVM initialization, an IOCTL interface is
>> required.
>>
>> Actually exposing the new capability to user space happens in a later
>> patch.
>>
>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/Kconfig                  | 14 ++++++++++++++
>>   arch/arm64/include/asm/cpucaps.h    |  2 ++
>>   arch/arm64/include/asm/cpufeature.h |  5 +++++
>>   arch/arm64/include/asm/kvm_host.h   |  4 ++++
>>   arch/arm64/include/asm/sysreg.h     | 12 ++++++++++++
>>   arch/arm64/kernel/cpufeature.c      |  9 +++++++++
>>   arch/arm64/tools/cpucaps            |  1 +
>>   include/uapi/linux/kvm.h            |  1 +
>>   tools/include/uapi/linux/kvm.h      |  1 +
>>   9 files changed, 49 insertions(+)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 6663ffd23f25..1edf75888a09 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -2201,6 +2201,20 @@ config ARM64_GCS
>>
>>   endmenu # "ARMv9.4 architectural features"
>>
>> +menu "ARMv9.5 architectural features"
>> +
>> +config ARM64_HDBSS
>> +	bool "Enable support for Hardware Dirty state tracking Structure (HDBSS)"
>> +	help
>> +	  Hardware Dirty state tracking Structure(HDBSS) enhances tracking
>> +	  translation table descriptors' dirty state to reduce the cost of
>> +	  surveying for dirtied granules.
>> +
>> +	  The feature introduces new assembly registers (HDBSSBR_EL2 and
>> +	  HDBSSPROD_EL2), which are accessed via generated register accessors.
> 
> This last but means nothing to most people.
> 
> But more importantly, I really don't want to see this as a config
> option. KVM comes with "battery included", and all features should be
> available at all times.
HDBSS is only designed for KVM, and I agree that it shouldn't be
controlled by a config option. I will remove it.

By the way, I would like to ask for your advice. I have been a bit
confused about when exactly it is necessary to add a config option in
Kconfig for a feature.
> 
>> +
>> +endmenu # "ARMv9.5 architectural features"
>> +
>>   config ARM64_SVE
>>   	bool "ARM Scalable Vector Extension support"
>>   	default y
>> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
>> index 9d769291a306..5e5a26f28dec 100644
>> --- a/arch/arm64/include/asm/cpucaps.h
>> +++ b/arch/arm64/include/asm/cpucaps.h
>> @@ -48,6 +48,8 @@ cpucap_is_possible(const unsigned int cap)
>>   		return IS_ENABLED(CONFIG_ARM64_GCS);
>>   	case ARM64_HAFT:
>>   		return IS_ENABLED(CONFIG_ARM64_HAFT);
>> +	case ARM64_HAS_HDBSS:
>> +		return IS_ENABLED(CONFIG_ARM64_HDBSS);
>>   	case ARM64_UNMAP_KERNEL_AT_EL0:
>>   		return IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0);
>>   	case ARM64_WORKAROUND_843419:
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index e223cbf350e4..b231415a2b76 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -856,6 +856,11 @@ static inline bool system_supports_haft(void)
>>   	return cpus_have_final_cap(ARM64_HAFT);
>>   }
>>
>> +static inline bool system_supports_hdbss(void)
>> +{
>> +	return cpus_have_final_cap(ARM64_HAS_HDBSS);
>> +}
>> +
>>   static __always_inline bool system_supports_mpam(void)
>>   {
>>   	return alternative_has_cap_unlikely(ARM64_MPAM);
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 64302c438355..d962932f0e5f 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -60,6 +60,10 @@
>>
>>   #define KVM_HAVE_MMU_RWLOCK
>>
>> +/* HDBSS entry field definitions */
>> +#define HDBSS_ENTRY_VALID BIT(0)
>> +#define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
>> +
> 
> None of this is used here. Move it to the patch where it belongs.
I will move HDBSS_ENTRY_VALID and HDBSS_ENTRY_IPA to next patch.
> 
>>   /*
>>    * Mode of operation configurable with kvm-arm.mode early param.
>>    * See Documentation/admin-guide/kernel-parameters.txt for more information.
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index c231d2a3e515..3511edea1fbc 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -1129,6 +1129,18 @@
>>   #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
>>   #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
>>
>> +/*
>> + * Definitions for the HDBSS feature
>> + */
>> +#define HDBSS_MAX_SIZE		HDBSSBR_EL2_SZ_2MB
>> +
>> +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & GENMASK(55, 12 + sz)) | \
>> +				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
>> +#define HDBSSBR_BADDR(br)	((br) & GENMASK(55, (12 + HDBSSBR_SZ(br))))
>> +#define HDBSSBR_SZ(br)		FIELD_GET(HDBSSBR_EL2_SZ_MASK, br)
> 
> This is a bit backward. When would you need to read-back and mask
> random bits off the register?
I will delete the definitions of HDBSSBR_BADDR and HDBSSBR_SZ.
> 
>> +
>> +#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
>> +
> 
> As previously said, these definitions don't serve any purpose here,
> and would be better in the following patch.
I will move all the HDBSS definitions to the next patch where they
are actually used.
> 
>>   #define ARM64_FEATURE_FIELD_BITS	4
>>
>>   #ifdef __ASSEMBLY__
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index e25b0f84a22d..f39973b68bdb 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2710,6 +2710,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>>   		.matches = has_cpuid_feature,
>>   		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HAFT)
>>   	},
>> +#endif
>> +#ifdef CONFIG_ARM64_HDBSS
>> +	{
>> +		.desc = "Hardware Dirty state tracking structure (HDBSS)",
>> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>> +		.capability = ARM64_HAS_HDBSS,
>> +		.matches = has_cpuid_feature,
>> +		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HDBSS)
>> +	},
> 
> I think this is one of the features we should restrict to VHE. I don't
> imagine pKVM ever making use of this, and no non-VHE HW will ever
> build this.
> 
> Thanks,
I will add a new helper function that checks both VHE and the CPUID
feature, and use it in place of has_cpuid_feature in the .matches field.
> 
> 	M.
> 



Return-Path: <kvm+bounces-59281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 861B1BB0141
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 13:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6CD91942743
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 11:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00A82C3259;
	Wed,  1 Oct 2025 11:00:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607C12C21F8;
	Wed,  1 Oct 2025 11:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759316427; cv=none; b=ImSyUbzUBoV52tNp5xsy02a/K6MsJq+V3oU7GbPYaECMWitulSZqIeb8UemWLSiyt2rK4LovbkRNSew15jHXwyEy+ySJioVvfC5XUlbFBNNhiIwSjMfiNOBuYmeMbYRKFv02SufUlJm0crT+F8h6yQj20ooqtdqNsY0760D8bys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759316427; c=relaxed/simple;
	bh=3ru9c1ecAoC6W72Wb/VITcP/ZIDp+n1MNRQULN/BlhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j4U7SVha5Tm9ppFaKfc/eR3xuotDtihN7XL/e8IqSq8gOHFsCTNZUrJT5tilFPIfF9//0PIlaM/JD8e7bDvJ0bK76yoqa6IAylXlGCfku5iMAv8QkIXC1CAmGOAXVSs60Z2XpZBsbH4aK79akfqtkTR6vUdMhE/K2SFsUukw0yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8995816F2;
	Wed,  1 Oct 2025 04:00:15 -0700 (PDT)
Received: from [10.57.0.204] (unknown [10.57.0.204])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06CB33F59E;
	Wed,  1 Oct 2025 04:00:18 -0700 (PDT)
Message-ID: <747ab990-d02d-4e7c-9007-a7ac73bb1062@arm.com>
Date: Wed, 1 Oct 2025 12:00:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/43] arm64: RME: Add SMC definitions for calling the
 RMM
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-4-steven.price@arm.com> <86o6qrym2b.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86o6qrym2b.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 01/10/2025 11:05, Marc Zyngier wrote:
> On Wed, 20 Aug 2025 15:55:23 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by SMC calls from the host.
>>
>> The SMC definitions are based on DEN0137[1] version 1.0-rel0
>>
>> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v9:
>>  * Corrected size of 'ripas_value' in struct rec_exit. The spec states
>>    this is an 8-bit type with padding afterwards (rather than a u64).
>> Changes since v8:
>>  * Added RMI_PERMITTED_GICV3_HCR_BITS to define which bits the RMM
>>    permits to be modified.
>> Changes since v6:
>>  * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
>>    these are flag values.
>> Changes since v5:
>>  * Sorted the SMC #defines by value.
>>  * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>>    RMI calls.
>>  * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>>    number of available list registers could be lower.
>>  * Provided a define for the reserved fields of FeatureRegister0.
>>  * Fix inconsistent names for padding fields.
>> Changes since v4:
>>  * Update to point to final released RMM spec.
>>  * Minor rearrangements.
>> Changes since v3:
>>  * Update to match RMM spec v1.0-rel0-rc1.
>> Changes since v2:
>>  * Fix specification link.
>>  * Rename rec_entry->rec_enter to match spec.
>>  * Fix size of pmu_ovf_status to match spec.
>> ---
>>  arch/arm64/include/asm/rmi_smc.h | 269 +++++++++++++++++++++++++++++++
>>  1 file changed, 269 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>>
>> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
>> new file mode 100644
>> index 000000000000..1000368f1bca
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rmi_smc.h
> 
> [...]
> 
>> +#define RMI_PERMITTED_GICV3_HCR_BITS	(ICH_HCR_EL2_UIE |		\
>> +					 ICH_HCR_EL2_LRENPIE |		\
>> +					 ICH_HCR_EL2_NPIE |		\
>> +					 ICH_HCR_EL2_VGrp0EIE |		\
>> +					 ICH_HCR_EL2_VGrp0DIE |		\
>> +					 ICH_HCR_EL2_VGrp1EIE |		\
>> +					 ICH_HCR_EL2_VGrp1DIE |		\
>> +					 ICH_HCR_EL2_TDIR)
> 
> Why should KVM care about what bits the RMM wants to use? Also, why
> should KVM be forbidden to use the TALL0, TALL1 and TC bits? If
> interrupt delivery is the host's business, then the RMM has no
> business interfering with the GIC programming.

The RMM receives the guest's GIC state in a field within the REC entry
structure (enter.gicv3_hcr). The RMM spec states that the above is the
list of fields that will be considered and that everything else must be
0[1]. So this is used to filter the configuration to make sure it's
valid for the RMM.

In terms of TALL0/TALL1/TC bits: these control trapping to EL2, and when
in a realm guest the RMM is EL2 - so it's up to the RMM to configure
these bits appropriately as it is the RMM which will have to deal with
the trap.

[1] RWVGFJ in the 1.0 spec from
https://developer.arm.com/documentation/den0137/latest

>> +
>> +struct rec_enter {
>> +	union { /* 0x000 */
>> +		u64 flags;
>> +		u8 padding0[0x200];
>> +	};
>> +	union { /* 0x200 */
>> +		u64 gprs[REC_RUN_GPRS];
>> +		u8 padding1[0x100];
>> +	};
>> +	union { /* 0x300 */
>> +		struct {
>> +			u64 gicv3_hcr;
>> +			u64 gicv3_lrs[REC_MAX_GIC_NUM_LRS];
>> +		};
>> +		u8 padding2[0x100];
>> +	};
>> +	u8 padding3[0x400];
>> +};
>> +
>> +#define RMI_EXIT_SYNC			0x00
>> +#define RMI_EXIT_IRQ			0x01
>> +#define RMI_EXIT_FIQ			0x02
>> +#define RMI_EXIT_PSCI			0x03
>> +#define RMI_EXIT_RIPAS_CHANGE		0x04
>> +#define RMI_EXIT_HOST_CALL		0x05
>> +#define RMI_EXIT_SERROR			0x06
>> +
>> +struct rec_exit {
>> +	union { /* 0x000 */
>> +		u8 exit_reason;
>> +		u8 padding0[0x100];
>> +	};
>> +	union { /* 0x100 */
>> +		struct {
>> +			u64 esr;
>> +			u64 far;
>> +			u64 hpfar;
>> +		};
>> +		u8 padding1[0x100];
>> +	};
>> +	union { /* 0x200 */
>> +		u64 gprs[REC_RUN_GPRS];
>> +		u8 padding2[0x100];
>> +	};
>> +	union { /* 0x300 */
>> +		struct {
>> +			u64 gicv3_hcr;
>> +			u64 gicv3_lrs[REC_MAX_GIC_NUM_LRS];
>> +			u64 gicv3_misr;
> 
> Why do we care about ICH_MISR_EL2? Surely we get everything in the
> registers themselves, right? I think this goes back to my question
> above: why is the RMM getting in the way of ICH_*_EL2 accesses?

As mentioned above, the state of the guest's GIC isn't passed through
the CPU's registers, but instead using the rec_enter/rec_exit
structures. So unlike a normal guest entry we don't set all the CPU's
register state before entering, but instead hand over a shared data
structure and the RMM is responsible for actually programming the
registers on the CPU. Since many of the registers are (deliberately)
unavailable to the host (e.g. all the GPRs) it makes some sense the RMM
also handles the GIC registers save/restore.

Thanks,
Steve

>> +			u64 gicv3_vmcr;
>> +		};
> 
> Thanks,
> 
> 	M.
> 



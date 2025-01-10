Return-Path: <kvm+bounces-34981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89204A08648
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 05:47:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E05A188CB15
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 04:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AED4205E05;
	Fri, 10 Jan 2025 04:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hJM+AfBa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F47E290F;
	Fri, 10 Jan 2025 04:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736484437; cv=none; b=CjyOFtMFRJcV19UnmQMOARlJvbh6EKIgXP5V6bezj4o+ycu34MXrclGzL7PT6j5ejqoEjGEq2C+yD3LMcJ8OibTOMhY64sNyKW11vuH5kNxt/ZVVhrYT3URvQjMMgoPo6W+Ws4u/Nk6lXEfX5LjlxA9mVP7d6MhhSZKo4gW8UAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736484437; c=relaxed/simple;
	bh=Pd2/0UPBg8cDbKdRW+tKf4P0ax2K1l7aoxcHx7DSEG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLzka47Urxrye2exlsGiMaTOgIY6X4V0829HAHvyRHv5Mr0OL+luVFXxzI9g1mP9/6QaigxDAehN8sZRFfTRD54fvkEqZ/PrwSsfUU/jqQOwDjmItBHbpzdyMzf7xlU/1PkOJbxJTmiY+JWbYtDZRBNPwseYAPUHRh2eRpqcZxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hJM+AfBa; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736484435; x=1768020435;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pd2/0UPBg8cDbKdRW+tKf4P0ax2K1l7aoxcHx7DSEG0=;
  b=hJM+AfBaxWEqgf4pS4sbQjZz8XiVMsZ4OwihBuMGSEBU2AX9AvbiNdDh
   M9LO2cDfnhM2VuWOj4wEO4nAVWji6Dmzzeqh5YiiNqAijjPBV6u0SWzZf
   tWxvv5+LsdatF0drTjVVJ3N/GTkIu1JjdSHc2mFe/OxS2oiMdrNhcVQ1O
   fN9URiHeyuoSlrL8NBzCBcii9Sv0fxk3FuOa1z31v3pyZPBP/L3eCCI/I
   oTxV1Omx+tuNMI8w9xGmY6Am7jP+kddMt0wXMyloW6ORAXCVBI9fRM1ge
   l0spc5zKxJ3xhqz1nxlTGU71JiJlglQttYVdfO2v50OCb5dHlNqtcCdnT
   A==;
X-CSE-ConnectionGUID: t4R7nOL1TUaVXNxEnXjsfw==
X-CSE-MsgGUID: /ISj5EfDT3SbC0kR3defZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="36792896"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="36792896"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 20:47:15 -0800
X-CSE-ConnectionGUID: tGFzLeBpQ+ybLQwfUny1Ug==
X-CSE-MsgGUID: pkIzvumUTUWG/UaYVVik7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="103675577"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 20:47:12 -0800
Message-ID: <9e7d3f5c-156b-4257-965d-aae03beb5faa@intel.com>
Date: Fri, 10 Jan 2025 12:47:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: yan.y.zhao@intel.com, isaku.yamahata@gmail.com, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 tony.lindgren@linux.intel.com, reinette.chatre@intel.com
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-25-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241030190039.77971-25-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Implement an IOCTL to allow userspace to read the CPUID bit values for a
> configured TD.
> 
> The TDX module doesn't provide the ability to set all CPUID bits. Instead
> some are configured indirectly, or have fixed values. But it does allow
> for the final resulting CPUID bits to be read. This information will be
> useful for userspace to understand the configuration of the TD, and set
> KVM's copy via KVM_SET_CPUID2.
> 
> To prevent userspace from starting to use features that might not have KVM
> support yet, filter the reported values by KVM's support CPUID bits.

This sentence is not implemented, we need drop it.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v2:
>   - Improve error path for tdx_vcpu_get_cpuid() (Xu)
>   - Drop unused cpuid in struct kvm_tdx (Xu)
>   - Rip out cpuid bit filtering
>   - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
>     wrappers (Kai)
>   - Add mmu.h for kvm_gfn_direct_bits() (Binbin)
>   - Drop unused nr_premapped (Tao)
>   - Fix formatting for tdx_vcpu_get_cpuid_leaf() (Tony)
>   - Use helpers for phys_addr_bits (Paolo)
> 
> uAPI breakout v1:
>   - New patch
> ---
>   arch/x86/include/uapi/asm/kvm.h |   1 +
>   arch/x86/kvm/vmx/tdx.c          | 167 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx_arch.h     |   5 +
>   arch/x86/kvm/vmx/tdx_errno.h    |   1 +
>   4 files changed, 174 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 2cfec4b42b9d..36fa03376581 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -931,6 +931,7 @@ enum kvm_tdx_cmd_id {
>   	KVM_TDX_CAPABILITIES = 0,
>   	KVM_TDX_INIT_VM,
>   	KVM_TDX_INIT_VCPU,
> +	KVM_TDX_GET_CPUID,
>   
>   	KVM_TDX_CMD_NR_MAX,
>   };
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9008db6cf3b4..1feb3307fd70 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2,6 +2,7 @@
>   #include <linux/cpu.h>
>   #include <asm/tdx.h>
>   #include "capabilities.h"
> +#include "mmu.h"
>   #include "x86_ops.h"
>   #include "tdx.h"
>   
> @@ -857,6 +858,94 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>   	return ret;
>   }
>   
> +static u64 tdx_td_metadata_field_read(struct kvm_tdx *tdx, u64 field_id,
> +				      u64 *data)
> +{
> +	u64 err;
> +
> +	err = tdh_mng_rd(tdx->tdr_pa, field_id, data);
> +
> +	return err;
> +}
> +
> +#define TDX_MD_UNREADABLE_LEAF_MASK	GENMASK(30, 7)
> +#define TDX_MD_UNREADABLE_SUBLEAF_MASK	GENMASK(31, 7)
> +
> +static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
> +			  bool sub_leaf_set, struct kvm_cpuid_entry2 *out)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	u64 field_id = TD_MD_FIELD_ID_CPUID_VALUES;
> +	u64 ebx_eax, edx_ecx;
> +	u64 err = 0;
> +
> +	if (sub_leaf & TDX_MD_UNREADABLE_LEAF_MASK ||
> +	    sub_leaf_set & TDX_MD_UNREADABLE_SUBLEAF_MASK)
> +		return -EINVAL;
> +
> +	/*
> +	 * bit 23:17, REVSERVED: reserved, must be 0;
> +	 * bit 16,    LEAF_31: leaf number bit 31;
> +	 * bit 15:9,  LEAF_6_0: leaf number bits 6:0, leaf bits 30:7 are
> +	 *                      implicitly 0;
> +	 * bit 8,     SUBLEAF_NA: sub-leaf not applicable flag;
> +	 * bit 7:1,   SUBLEAF_6_0: sub-leaf number bits 6:0. If SUBLEAF_NA is 1,
> +	 *                         the SUBLEAF_6_0 is all-1.
> +	 *                         sub-leaf bits 31:7 are implicitly 0;
> +	 * bit 0,     ELEMENT_I: Element index within field;
> +	 */
> +	field_id |= ((leaf & 0x80000000) ? 1 : 0) << 16;
> +	field_id |= (leaf & 0x7f) << 9;
> +	if (sub_leaf_set)
> +		field_id |= (sub_leaf & 0x7f) << 1;
> +	else
> +		field_id |= 0x1fe;
> +
> +	err = tdx_td_metadata_field_read(kvm_tdx, field_id, &ebx_eax);
> +	if (err) //TODO check for specific errors
> +		goto err_out;
> +
> +	out->eax = (u32) ebx_eax;
> +	out->ebx = (u32) (ebx_eax >> 32);
> +
> +	field_id++;
> +	err = tdx_td_metadata_field_read(kvm_tdx, field_id, &edx_ecx);
> +	/*
> +	 * It's weird that reading edx_ecx fails while reading ebx_eax
> +	 * succeeded.
> +	 */
> +	if (WARN_ON_ONCE(err))
> +		goto err_out;
> +
> +	out->ecx = (u32) edx_ecx;
> +	out->edx = (u32) (edx_ecx >> 32);
> +
> +	out->function = leaf;
> +	out->index = sub_leaf;
> +	out->flags |= sub_leaf_set ? KVM_CPUID_FLAG_SIGNIFCANT_INDEX : 0;
> +
> +	/*
> +	 * Work around missing support on old TDX modules, fetch
> +	 * guest maxpa from gfn_direct_bits.
> +	 */
> +	if (leaf == 0x80000008) {
> +		gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
> +		unsigned int g_maxpa = __ffs(gpa_bits) + 1;
> +
> +		out->eax = tdx_set_guest_phys_addr_bits(out->eax, g_maxpa);
> +	}
> +
> +	return 0;
> +
> +err_out:
> +	out->eax = 0;
> +	out->ebx = 0;
> +	out->ecx = 0;
> +	out->edx = 0;
> +
> +	return -EIO;
> +}
> +
>   static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -1055,6 +1144,81 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>   	return ret;
>   }
>   
> +/* Sometimes reads multipple subleafs. Return how many enties were written. */
> +static int tdx_vcpu_get_cpuid_leaf(struct kvm_vcpu *vcpu, u32 leaf, int max_cnt,
> +				   struct kvm_cpuid_entry2 *output_e)
> +{
> +	int i;
> +
> +	if (!max_cnt)
> +		return 0;
> +
> +	/* First try without a subleaf */
> +	if (!tdx_read_cpuid(vcpu, leaf, 0, false, output_e))
> +		return 1;
> +
> +	/*
> +	 * If the try without a subleaf failed, try reading subleafs until
> +	 * failure. The TDX module only supports 6 bits of subleaf index.
> +	 */
> +	for (i = 0; i < 0b111111; i++) {
> +		if (i > max_cnt)
> +			goto out;
> +
> +		/* Keep reading subleafs until there is a failure. */
> +		if (tdx_read_cpuid(vcpu, leaf, i, true, output_e))
> +			return i;
> +
> +		output_e++;
> +	}
> +
> +out:
> +	return i;
> +}
> +
> +static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_cpuid2 __user *output, *td_cpuid;
> +	struct kvm_cpuid_entry2 *output_e;
> +	int r = 0, i = 0, leaf;
> +
> +	output = u64_to_user_ptr(cmd->data);
> +	td_cpuid = kzalloc(sizeof(*td_cpuid) +
> +			sizeof(output->entries[0]) * KVM_MAX_CPUID_ENTRIES,
> +			GFP_KERNEL);
> +	if (!td_cpuid)
> +		return -ENOMEM;
> +
> +	for (leaf = 0; leaf <= 0x1f; leaf++) {

0x1f needs clarification here.

If it's going to use the maximum leaf KVM can support, it should be 0x24 
to align with __do_cpuid_func().

alternatively, it can use the EAX value of leaf 0 returned by TDX 
module. That is the value TDX module presents to the TD guest.

> +		output_e = &td_cpuid->entries[i];
> +		i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
> +					     KVM_MAX_CPUID_ENTRIES - i - 1,
> +					     output_e);
> +	}
> +
> +	for (leaf = 0x80000000; leaf <= 0x80000008; leaf++) {
> +		output_e = &td_cpuid->entries[i];
> +		i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
> +					     KVM_MAX_CPUID_ENTRIES - i - 1,
> +					     output_e);

Though what gets passed in for max_cnt is

   KVM_MAX_CPUID_ENTRIES - i - 1

tdx_vcpu_get_cpuid_leaf() can return "max_cnt+1", i.e., 
KVM_MAX_CPUID_ENTRIES - i.

Then, it makes next round i to be KVM_MAX_CPUID_ENTRIES, and

   output_e = &td_cpuid->entries[i];

will overflow the buffer and access illegal memory.

Similar issue inside tdx_vcpu_get_cpuid_leaf() as I replied in [*]

[*] 
https://lore.kernel.org/all/7574968a-f0e2-49d5-b740-2454a0f70bb6@intel.com/

> +	}
> +
> +	td_cpuid->nent = i;
> +
> +	if (copy_to_user(output, td_cpuid, sizeof(*output))) {
> +		r = -EFAULT;
> +		goto out;
> +	}
> +	if (copy_to_user(output->entries, td_cpuid->entries,
> +			 td_cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
> +		r = -EFAULT;
> +
> +out:
> +	kfree(td_cpuid);
> +
> +	return r;
> +}
> +
>   static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>   {
>   	struct msr_data apic_base_msr;
> @@ -1108,6 +1272,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>   	case KVM_TDX_INIT_VCPU:
>   		ret = tdx_vcpu_init(vcpu, &cmd);
>   		break;
> +	case KVM_TDX_GET_CPUID:
> +		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
> +		break;
>   	default:
>   		ret = -EINVAL;
>   		break;
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index 9d41699e66a2..d80ec118834e 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -157,4 +157,9 @@ struct td_params {
>   
>   #define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
>   
> +/*
> + * TD scope metadata field ID.
> + */
> +#define TD_MD_FIELD_ID_CPUID_VALUES		0x9410000300000000ULL
> +
>   #endif /* __KVM_X86_TDX_ARCH_H */
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> index dc3fa2a58c2c..f9dbb3a065cc 100644
> --- a/arch/x86/kvm/vmx/tdx_errno.h
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -23,6 +23,7 @@
>   #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
>   #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
>   #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
> +#define TDX_METADATA_FIELD_NOT_READABLE		0xC0000C0200000000ULL
>   
>   /*
>    * TDX module operand ID, appears in 31:0 part of error code as



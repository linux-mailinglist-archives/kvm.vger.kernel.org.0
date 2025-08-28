Return-Path: <kvm+bounces-56109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 388BEB39DEB
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 14:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E569B16E006
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D5A30FF13;
	Thu, 28 Aug 2025 12:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mimfz4vH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0242D46C0;
	Thu, 28 Aug 2025 12:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756385900; cv=none; b=LlperH5O5i5c5Xh0ZxJ0kEJiruMxrWvvrmI/KUtWHGEFLOhysT7PwCc2TeL9Un7WuN6hq8KNQmCdiPEuMg21wLHqlZhwv1GidOk1cAi/RgEKM3YsT+RmlFZo07o+Iy7VaOZMtvwGSmFUodwMWLTittK9gYoTUI7CvTIujmNegGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756385900; c=relaxed/simple;
	bh=Z3OvKAB1+2yNUXUobtDoYmPJCLCwq9048JEZk/NmtFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p5wOvmYTNjY3cN/mmpQGMOeisDlZxmE9TRmmYCnWHFPvZK5lY74vIr7TPHod2ehq1aWb9U3G4yDfDqSrnvrsJ+iEX4ZEwxGljLJqU/aLUd/2b6tWOeQryceMPffvd7fdEJEUCgU7iX5Z43kBLAnYlm0JixdvP1/tQ21o0s7Nk+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mimfz4vH; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756385899; x=1787921899;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z3OvKAB1+2yNUXUobtDoYmPJCLCwq9048JEZk/NmtFs=;
  b=Mimfz4vHN3dA5EEvzDq34nQzhT2NFBS8tD2FSOP5YEi+ACSozgxhAp1L
   4E6/4AzEU5CaEcq0gEqVhzECoeA52N11qJ48lv3Iqz4I0JsPKD/p9hJ4X
   Cr/Z667kZOpPdUf40eyIGN2VLwyRlfHnHb5bbj4HzS2IaNc8Ec/MIl74K
   UetiYmsQ/H8Avy4jN5basjtquZgCafwgonl5FAIbyJPfW4nMv1EGySlPM
   OWZQwkI9di9cnSAMCq+StLRwB7XsEUwyR+CDm0JZAq91UrG279SClIOCV
   D2S4Z6ni+oh068+WelHHX9t/H30VT+fqITu4JOi7Ivw7vI3e35oTHLJlB
   A==;
X-CSE-ConnectionGUID: 5Gvv9rLNS1m6p2E6893N5Q==
X-CSE-MsgGUID: nWX/t08aTr2XWnksmyuatg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81247057"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81247057"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 05:58:18 -0700
X-CSE-ConnectionGUID: woa8vA/jRSCVAqi0SO5slQ==
X-CSE-MsgGUID: t+v9EyQESdq7nFIJY34v2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169697571"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 05:58:11 -0700
Message-ID: <402d79e7-f229-4caa-8150-6061e363da4f@intel.com>
Date: Thu, 28 Aug 2025 20:58:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 01/21] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs
 support
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@redhat.com, minipli@grsecurity.net,
 mlevitsk@redhat.com, pbonzini@redhat.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, tglx@linutronix.de, weijiang.yang@intel.com,
 x86@kernel.org, xin@zytor.com
References: <20250821133132.72322-1-chao.gao@intel.com>
 <20250821133132.72322-2-chao.gao@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250821133132.72322-2-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/2025 9:30 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
> 
> Enable KVM_{G,S}ET_ONE_REG uAPIs so that userspace can access HW MSR or
> KVM synthetic MSR through it.
> 
> In CET KVM series [1], KVM "steals" an MSR from PV MSR space and access
> it via KVM_{G,S}ET_MSRs uAPIs, but the approach pollutes PV MSR space
> and hides the difference of synthetic MSRs and normal HW defined MSRs.
> 
> Now carve out a separate room in KVM-customized MSR address space for
> synthetic MSRs. The synthetic MSRs are not exposed to userspace via
> KVM_GET_MSR_INDEX_LIST, instead userspace complies with KVM's setup and
> composes the uAPI params. KVM synthetic MSR indices start from 0 and
> increase linearly. Userspace caller should tag MSR type correctly in
> order to access intended HW or synthetic MSR.

The old feedback[*] was to introduce support for SYNTHETIC registers 
instead of limiting it to MSR.

As in patch 09, it changes to name guest SSP as

   #define KVM_SYNTHETIC_GUEST_SSP 0

Nothing about MSR.

[*] https://lore.kernel.org/all/ZmelpPm5YfGifhIj@google.com/

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Link: https://lore.kernel.org/all/20240219074733.122080-18-weijiang.yang@intel.com/ [1]
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> 
> ---
> v13:
>   - Add vendor and size fields to the register ID to align with other
>     architectures. (Sean)
>   - Avoid exposing the struct overlay of the register ID to in uAPI
>     headers (Sean)
>   - Advertise KVM_CAP_ONE_REG
> ---
>   arch/x86/include/uapi/asm/kvm.h | 21 +++++++++
>   arch/x86/kvm/x86.c              | 82 +++++++++++++++++++++++++++++++++
>   2 files changed, 103 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0f15d683817d..969a63e73190 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -411,6 +411,27 @@ struct kvm_xcrs {
>   	__u64 padding[16];
>   };
>   
> +#define KVM_X86_REG_TYPE_MSR		2
> +#define KVM_X86_REG_TYPE_SYNTHETIC_MSR	3
> +
> +#define KVM_X86_REG_TYPE_SIZE(type)						\
> +({										\
> +	__u64 type_size = (__u64)type << 32;					\
> +										\
> +	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
> +		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
> +		     0;								\
> +	type_size;								\
> +})
> +
> +#define KVM_X86_REG_ENCODE(type, index)				\
> +	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)
> +
> +#define KVM_X86_REG_MSR(index)					\
> +	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
> +#define KVM_X86_REG_SYNTHETIC_MSR(index)			\
> +	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_SYNTHETIC_MSR, index)

BTW, do we need to add some doc of the IDs, e.g., to

4.68 KVM_SET_ONE_REG in Documentation/virt/kvm/api.rst ?

>   #define KVM_SYNC_X86_REGS      (1UL << 0)
>   #define KVM_SYNC_X86_SREGS     (1UL << 1)
>   #define KVM_SYNC_X86_EVENTS    (1UL << 2)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7ba2cdfdac44..31a7e7ad310a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2254,6 +2254,31 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
>   }
>   
> +static int kvm_get_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
> +{
> +	u64 val;
> +	int r;
> +
> +	r = do_get_msr(vcpu, msr, &val);
> +	if (r)
> +		return r;
> +
> +	if (put_user(val, value))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int kvm_set_one_msr(struct kvm_vcpu *vcpu, u32 msr, u64 __user *value)
> +{
> +	u64 val;
> +
> +	if (get_user(val, value))
> +		return -EFAULT;
> +
> +	return do_set_msr(vcpu, msr, &val);
> +}
> +
>   #ifdef CONFIG_X86_64
>   struct pvclock_clock {
>   	int vclock_mode;
> @@ -4737,6 +4762,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_IRQFD_RESAMPLE:
>   	case KVM_CAP_MEMORY_FAULT_INFO:
>   	case KVM_CAP_X86_GUEST_MODE:
> +	case KVM_CAP_ONE_REG:
>   		r = 1;
>   		break;
>   	case KVM_CAP_PRE_FAULT_MEMORY:
> @@ -5915,6 +5941,20 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>   	}
>   }
>   
> +struct kvm_x86_reg_id {
> +	__u32 index;
> +	__u8  type;
> +	__u8  rsvd;
> +	__u8  rsvd4:4;

why naming it rsvd4? because it's 4-bit bit-field ?

> +	__u8  size:4;
> +	__u8  x86;
> +};
> +
> +static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
> +{
> +	return -EINVAL;
> +}
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg)
>   {
> @@ -6031,6 +6071,48 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>   		break;
>   	}
> +	case KVM_GET_ONE_REG:
> +	case KVM_SET_ONE_REG: {
> +		struct kvm_x86_reg_id *id;
> +		struct kvm_one_reg reg;
> +		u64 __user *value;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&reg, argp, sizeof(reg)))
> +			break;
> +
> +		r = -EINVAL;
> +		if ((reg.id & KVM_REG_ARCH_MASK) != KVM_REG_X86)
> +			break;
> +
> +		id = (struct kvm_x86_reg_id *)&reg.id;
> +		if (id->rsvd || id->rsvd4)
> +			break;
> +
> +		if (id->type != KVM_X86_REG_TYPE_MSR &&
> +		    id->type != KVM_X86_REG_TYPE_SYNTHETIC_MSR)
> +			break;
> +
> +		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
> +			break;
> +
> +		if (id->type == KVM_X86_REG_TYPE_SYNTHETIC_MSR) {
> +			r = kvm_translate_synthetic_msr(id);
> +			if (r)
> +				break;
> +		}
> +
> +		r = -EINVAL;
> +		if (id->type != KVM_X86_REG_TYPE_MSR)
> +			break;
> +
> +		value = u64_to_user_ptr(reg.addr);
> +		if (ioctl == KVM_GET_ONE_REG)
> +			r = kvm_get_one_msr(vcpu, id->index, value);
> +		else
> +			r = kvm_set_one_msr(vcpu, id->index, value);
> +		break;
> +	}
>   	case KVM_TPR_ACCESS_REPORTING: {
>   		struct kvm_tpr_access_ctl tac;
>   



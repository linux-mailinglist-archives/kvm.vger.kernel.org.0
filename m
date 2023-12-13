Return-Path: <kvm+bounces-4306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B0D810C74
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 09:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45A73281CFB
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 08:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5091EB2B;
	Wed, 13 Dec 2023 08:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PmwYGScm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE36F4;
	Wed, 13 Dec 2023 00:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702456192; x=1733992192;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I6fYYnPqRckfY4Rb+ihD3QNPkzsJczlQfdOs+BmvvqM=;
  b=PmwYGScmdfkLiAG6FJDiiOnEGj4QzDl2CH/RhDPwj0V0KHw/ZNl/ycZx
   iWFYavHydC1nlvs++XTVYJmjhRF8rxTnt5SspJ1mf0281RPPrUpIULhA3
   7VXAqxfvhfo5frACfvUELGMUsjOxtWlDcyR/94xCThUDvHMmTGw9mIeT6
   hGWDn44kw0orlvcJqGHis+bdhVuPLdiYk4lGFvtY25LELy9OGA7WtMe5S
   3gzFg0RHfVN+/jfQz+w3yhcvURfG7ilcv2H93j0JwS6gs70X2xmzmzd36
   iIKFDgQ8NIAqpoRYFhmQkYWMelCa4Bx9ZCgIKM2lO6RGbMgokQ7n05SGb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="461406357"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="461406357"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 00:29:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="777409496"
X-IronPort-AV: E=Sophos;i="6.04,272,1695711600"; 
   d="scan'208";a="777409496"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.2.128]) ([10.238.2.128])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2023 00:29:47 -0800
Message-ID: <73dadd10-0b67-4338-a3e8-38c174c04f59@linux.intel.com>
Date: Wed, 13 Dec 2023 16:29:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 025/116] KVM: TDX: allocate/free TDX vcpu structure
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <2d8b9860be7fac4b43264b68dc413a228d3e979e.1699368322.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2d8b9860be7fac4b43264b68dc413a228d3e979e.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
> structures, initialize it that doesn't require TDX SEAMCALL.
Didn't see any allocation happens for TDX in this patch.


>   TDX specific
> vcpu initialization will be implemented as independent KVM_TDX_INIT_VCPU
> so that when error occurs it's easy to determine which component has the
> issue, KVM or TDX.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v15 -> v16:
> - Add AMX support as the KVM upstream supports it.
> ---
>   arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/tdx.c     | 49 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h | 10 ++++++++
>   arch/x86/kvm/x86.c         |  2 ++
>   4 files changed, 101 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index c8213d6ea301..f60de0232f7f 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -98,6 +98,42 @@ static void vt_vm_free(struct kvm *kvm)
>   		tdx_vm_free(kvm);
>   }
>   
> +static int vt_vcpu_precreate(struct kvm *kvm)
> +{
> +	if (is_td(kvm))
> +		return 0;
> +
> +	return vmx_vcpu_precreate(kvm);
> +}
> +
> +static int vt_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_create(vcpu);
> +
> +	return vmx_vcpu_create(vcpu);
> +}
> +
> +static void vt_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_free(vcpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_free(vcpu);
> +}

I'm wondering for such wrapper functions without a return value,
is the following style cleaner?
It can save two lines of code.

+static void vt_vcpu_free(struct kvm_vcpu *vcpu)
+{
+    if (is_td_vcpu(vcpu))
+        tdx_vcpu_free(vcpu);
+    else
+        vmx_vcpu_free(vcpu);
+}


> +
> +static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_reset(vcpu, init_event);
> +		return;
> +	}
> +
> +	vmx_vcpu_reset(vcpu, init_event);
> +}
> +
ditto

>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -136,10 +172,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vm_destroy = vt_vm_destroy,
>   	.vm_free = vt_vm_free,
>   
> -	.vcpu_precreate = vmx_vcpu_precreate,
> -	.vcpu_create = vmx_vcpu_create,
> -	.vcpu_free = vmx_vcpu_free,
> -	.vcpu_reset = vmx_vcpu_reset,
> +	.vcpu_precreate = vt_vcpu_precreate,
> +	.vcpu_create = vt_vcpu_create,
> +	.vcpu_free = vt_vcpu_free,
> +	.vcpu_reset = vt_vcpu_reset,
>   
>   	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
>   	.vcpu_load = vmx_vcpu_load,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 51aa114feb86..b7f8ac4b9f95 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -335,6 +335,55 @@ int tdx_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +
> +	/*
> +	 * On cpu creation, cpuid entry is blank.  Forcibly enable
> +	 * X2APIC feature to allow X2APIC.
> +	 * Because vcpu_reset() can't return error, allocation is done here.
> +	 */
> +	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
> +	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> +
> +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> +	if (!vcpu->arch.apic)
> +		return -EINVAL;
> +
> +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> +
> +	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> +
> +	vcpu->arch.cr0_guest_owned_bits = -1ul;
> +	vcpu->arch.cr4_guest_owned_bits = -1ul;
> +
> +	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
> +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> +	vcpu->arch.guest_state_protected =
> +		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
> +
> +	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
> +		vcpu->arch.xfd_no_write_intercept = true;
> +
> +	return 0;
> +}
> +
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	/* This is stub for now.  More logic will come. */
> +}
> +
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> +{
> +
> +	/* Ignore INIT silently because TDX doesn't support INIT event. */
> +	if (init_event)
> +		return;
> +
> +	/* This is stub for now. More logic will come here. */
> +}
> +
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index ffba64008682..ebb963848316 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -144,7 +144,12 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>   int tdx_vm_init(struct kvm *kvm);
>   void tdx_mmu_release_hkid(struct kvm *kvm);
>   void tdx_vm_free(struct kvm *kvm);
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> +
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_free(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   #else
>   static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
>   static inline void tdx_hardware_unsetup(void) {}
> @@ -158,7 +163,12 @@ static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>   static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
>   static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
>   static inline void tdx_vm_free(struct kvm *kvm) {}
> +
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
> +
> +static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
> +static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 191ac1e0d96d..0414822e7a03 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -502,6 +502,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	kvm_recalculate_apic_map(vcpu->kvm);
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(kvm_set_apic_base);
>   
>   /*
>    * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
> @@ -12430,6 +12431,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
>   {
>   	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
>   }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
>   
>   bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
>   {



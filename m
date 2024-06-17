Return-Path: <kvm+bounces-19761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A129090A81F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 10:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D7491F2470D
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 08:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18D0190049;
	Mon, 17 Jun 2024 08:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDNnOtPK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E25618628D;
	Mon, 17 Jun 2024 08:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718611657; cv=none; b=Kvb3EuOzOGrRMxUOX69PBoVMjvSNcFfSkKLvfmlXmdFnfAEpdrqxYfxHnYA6uV+uAXmPQZDUiyjwbv2CxVW3q9bWoFw8occE1nio70EQxzHSdQY1Am8R6gX+RrFqGMn22kS7WLtpEHyNcPY+VganIXj8gSA36DtSwMP8yqse4OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718611657; c=relaxed/simple;
	bh=36kcjfNBQBQ7BrQRqoUTR+7LEakNMlF6+LyRwnMX5tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k24IroASq707ttC4A9kGTVmbMFXRnFo0CzK5a5Vzi1LG998kn7Oh+FO9ID8xdLVC0MBtNRXbf4dApRX8T9E/eyvR5jUmSYcD1AMVu6FHgkyiGW9Ykw29rEpLHdQlnU3ND5LQlVY4bIqFUe15ZV16f3NESrvgGMLdOdMt8e7sDWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDNnOtPK; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718611656; x=1750147656;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=36kcjfNBQBQ7BrQRqoUTR+7LEakNMlF6+LyRwnMX5tk=;
  b=jDNnOtPK4UUANfd07YB1A3Rb1tuo8DD18yRW4WXGWf5dErItnui8j8kY
   AG0HDn2yL1AVzq5OHL8qOdsCC4bbsfa7j6eg1flxs9iaPiCRAWIYIBcXY
   nGNkFKWGGed5XnNtMs4Fm4n867ulADBiYAYHlPvN81+HQRlpqKzdOl1Gk
   eboZdFFrOZWUxpjKMYHzS15WIX8Z0RjaG96VbFUB375Hlezp4kVUJduGQ
   ra3A3rapx/cyw7LtHDx6yOouf6pyv1ZLl9GUOc0d5dp413LrjcR2xQ9Jk
   OjJGDxep4xThOmcp9QnbD9TV210UD/s6H1kKFYN+lHlWPQtagZ7O7Ppoq
   Q==;
X-CSE-ConnectionGUID: WntByvsQRQ6Ecb5RFlCnbQ==
X-CSE-MsgGUID: 53Wvj70VQ2urVkHweMTvHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11105"; a="37952311"
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="37952311"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 01:07:35 -0700
X-CSE-ConnectionGUID: 8kKG7+d4RvqauFqpa3eQIw==
X-CSE-MsgGUID: Dk4GaEnPRH+Qn1mfBjt3UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,244,1712646000"; 
   d="scan'208";a="41253740"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa009.jf.intel.com with ESMTP; 17 Jun 2024 01:07:31 -0700
Date: Mon, 17 Jun 2024 16:07:29 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 085/130] KVM: TDX: Complete interrupts after tdexit
Message-ID: <20240617080729.j5nottky5bjmgdmf@yy-desk-7060>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa6a927214a5d29d5591a0079f4374b05a82a03f.1708933498.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215

On Mon, Feb 26, 2024 at 12:26:27AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> This corresponds to VMX __vmx_complete_interrupts().  Because TDX
> virtualize vAPIC, KVM only needs to care NMI injection.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> v19:
> - move tdvps_management_check() to this patch
> - typo: complete -> Complete in short log
> ---
>  arch/x86/kvm/vmx/tdx.c | 10 ++++++++++
>  arch/x86/kvm/vmx/tdx.h |  4 ++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 83dcaf5b6fbd..b8b168f74dfe 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -535,6 +535,14 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	 */
>  }
>
> +static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
> +{
> +	/* Avoid costly SEAMCALL if no nmi was injected */
> +	if (vcpu->arch.nmi_injected)
> +		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
> +							      TD_VCPU_PEND_NMI);
> +}

Looks this leads to NMI injection delay or even won't be
reinjected if KVM_REQ_EVENT is not set on the target cpu
when more than 1 NMIs are pending there.

On normal VM, KVM uses NMI window vmexit for injection
successful case to rasie the KVM_REQ_EVENT again for remain
pending NMIs, see handle_nmi_window(). KVM also checks
vectoring info after VMEXIT for case that the NMI is not
injected successfully in this vmentry vmexit round, and
raise KVM_REQ_EVENT to try again, see __vmx_complete_interrupts().

In TDX, consider there's no way to get vectoring info or
handle nmi window vmexit, below checking should cover both
scenarios for NMI injection:

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e9c9a185bb7b..9edf446acd3b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -835,9 +835,12 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
 {
        /* Avoid costly SEAMCALL if no nmi was injected */
-       if (vcpu->arch.nmi_injected)
+       if (vcpu->arch.nmi_injected) {
                vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
                                                              TD_VCPU_PEND_NMI);
+               if (vcpu->arch.nmi_injected || vcpu->arch.nmi_pending)
+                       kvm_make_request(KVM_REQ_EVENT, vcpu);
+       }
 }

> +
>  struct tdx_uret_msr {
>  	u32 msr;
>  	unsigned int slot;
> @@ -663,6 +671,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>  	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>  	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>
> +	tdx_complete_interrupts(vcpu);
> +
>  	return EXIT_FASTPATH_NONE;
>  }
>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 44eab734e702..0d8a98feb58e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -142,6 +142,8 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
>  			 "Invalid TD VMCS access for 16-bit field");
>  }
>
> +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
> +
>  #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
>  static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
>  							u32 field)		\
> @@ -200,6 +202,8 @@ TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
>  TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
>  TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
>
> +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
> +
>  static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
>  {
>  	struct tdx_module_args out;
> --
> 2.25.1
>
>


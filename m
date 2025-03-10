Return-Path: <kvm+bounces-40580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1340CA58C8E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:14:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AD3616A3CA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E838C1D7E41;
	Mon, 10 Mar 2025 07:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lXbTylMT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BF01D5AB6;
	Mon, 10 Mar 2025 07:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741590836; cv=none; b=tpuij8e2eBp2AFTK4LVrFquIrBZjApdb2z4wNezQyzMpxEqI7jUoC7x+Oe/TV/H+vlmw9IQf7PyZ1KVRLRMHwwCCq6dBPySXLehxbdJcsW0ruK/igGf0Kq1hiTmPJTw3NzTtQx6tpQSNmAja7HQmWFxacreC/g/tk7AvqRpekF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741590836; c=relaxed/simple;
	bh=lHW75yTA3XA3dsf1to4UbxMiP+xaDqbRX6878HQTwbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mFXTiH8H0uI72Rn55NSgiwBer4M6K1yvd2FPSdYMpjtJuRqK40qSrnUF8n+yzGtzrR3uw/eLe2Z1BL5tfd/mRdjY5TGAf75Vs4TY3UshyNV9YPt/kBAxrdDgHJI0EPDkr3UwbHU6LcwCJwaiHjsPxKBgaRMze/wPNr2OqDlV9hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lXbTylMT; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741590835; x=1773126835;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lHW75yTA3XA3dsf1to4UbxMiP+xaDqbRX6878HQTwbI=;
  b=lXbTylMTVIFsqpxO+lmkoU+8L50/RLUFOXRmeswvimkXixinkPc4dN1X
   Q7zwnbjm2NpCpSPGLtVsro1HQsVAlqZdmYViVlF6deN4dll/b7dC3A0Wu
   kOmV0OxzvBBTmaI3vvH46pa6wJWoP2QtQlKApblMHugSF0FLCDdAerL5u
   1R/j87UhH/1Mgi2uJpstsn10dqpWby2UKwIsIwfKFyzGm597Oe19pUbe2
   A0IZ5kYzwpPuksijVaRVyBFH2RnfWvnG8P7nSFX3kFFPftASCB5CWQnnb
   pgXVUw8LZNJ3J518tqa54lVb3YZqAPNWGbOWPYek15JtVe+SyXcnoi0t+
   w==;
X-CSE-ConnectionGUID: 6RRUWI6fRiWvfFXJQqgIig==
X-CSE-MsgGUID: vTC48RvXTHSDWwlht+B/Ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42479451"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42479451"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:13:53 -0700
X-CSE-ConnectionGUID: JSqgQkTwR7WwvQIHT+hVZQ==
X-CSE-MsgGUID: vIYzkIuuRSWYlPI47iz1EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150683026"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 00:13:50 -0700
Message-ID: <e51bf148-d447-4b9c-abe0-df06d4500f5c@intel.com>
Date: Mon, 10 Mar 2025 15:13:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] KVM: TDX: vcpu_run: save/restore host state(host
 kernel gs)
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: adrian.hunter@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
 <20250307212053.2948340-5-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250307212053.2948340-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> On entering/exiting TDX vcpu, preserved or clobbered CPU state is different
> from the VMX case. Add TDX hooks to save/restore host/guest CPU state.
> Save/restore kernel GS base MSR.


Reviewed-by: Xiayao Li <xiaoyao.li@intel.com>

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-ID: <20250129095902.16391-7-adrian.hunter@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 24 +++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 40 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   3 files changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 037590fc05e9..c0497ed0c9be 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -145,6 +145,26 @@ static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>   	vmx_update_cpu_dirty_logging(vcpu);
>   }
>   
> +static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_prepare_switch_to_guest(vcpu);
> +		return;
> +	}
> +
> +	vmx_prepare_switch_to_guest(vcpu);
> +}
> +
> +static void vt_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_put(vcpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_put(vcpu);
> +}
> +
>   static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -265,9 +285,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_free = vt_vcpu_free,
>   	.vcpu_reset = vt_vcpu_reset,
>   
> -	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
> +	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
>   	.vcpu_load = vt_vcpu_load,
> -	.vcpu_put = vmx_vcpu_put,
> +	.vcpu_put = vt_vcpu_put,
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
>   	.get_feature_msr = vmx_get_feature_msr,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f50565f45b6a..94e08fdcb775 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3,6 +3,7 @@
>   #include <linux/cpu.h>
>   #include <asm/cpufeature.h>
>   #include <linux/misc_cgroup.h>
> +#include <linux/mmu_context.h>
>   #include <asm/tdx.h>
>   #include "capabilities.h"
>   #include "mmu.h"
> @@ -12,6 +13,7 @@
>   #include "vmx.h"
>   #include "mmu/spte.h"
>   #include "common.h"
> +#include "posted_intr.h"
>   #include <trace/events/kvm.h>
>   #include "trace.h"
>   
> @@ -624,6 +626,44 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	local_irq_enable();
>   }
>   
> +/*
> + * Compared to vmx_prepare_switch_to_guest(), there is not much to do
> + * as SEAMCALL/SEAMRET calls take care of most of save and restore.
> + */
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vt *vt = to_vt(vcpu);
> +
> +	if (vt->guest_state_loaded)
> +		return;
> +
> +	if (likely(is_64bit_mm(current->mm)))
> +		vt->msr_host_kernel_gs_base = current->thread.gsbase;
> +	else
> +		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> +
> +	vt->guest_state_loaded = true;
> +}
> +
> +static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vt *vt = to_vt(vcpu);
> +
> +	if (!vt->guest_state_loaded)
> +		return;
> +
> +	++vcpu->stat.host_state_reload;
> +	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
> +
> +	vt->guest_state_loaded = false;
> +}
> +
> +void tdx_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	vmx_vcpu_pi_put(vcpu);
> +	tdx_prepare_switch_to_host(vcpu);
> +}
> +
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 578c26d3aec4..cd18e9b1e124 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -133,6 +133,8 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   
> @@ -164,6 +166,8 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
>   {
>   	return EXIT_FASTPATH_NONE;
>   }
> +static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   



Return-Path: <kvm+bounces-50441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA82AE5950
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 03:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BA887AE762
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C651D5CE5;
	Tue, 24 Jun 2025 01:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iQrno7Sg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446E03FE7;
	Tue, 24 Jun 2025 01:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750729277; cv=none; b=ZNuN4YU6HLUEQfDrBlYWYkQFFXmcS8HLasNh7oL/I0TlblIC4c3iCtBpZqgc/6+WcDQrVhv44bSj+o0KS5SCKQ41wujd0uE4noGkefUo6L/mjxQRuX/iTCbg7M0g5LBiuwwgePZOfGvhlbx/JXDe/1+eQXtd7ExtKp5w1GSh3G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750729277; c=relaxed/simple;
	bh=xTw8C4+9xWfpNpVUJzqazGEWhQRzloD/T24WRdD/EsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hfC21E80jMED5lRnEqUoMSAzVAD2Hff4g8wmiSzYD2QO9iy/CVvuA61/7lLsVtQAPCNk5zwWmdGJ+vELt76kDTeyDFd9VMFdkEK9sA+IYT3Dwu55UGLAtP9HF6RGIBXhBEtKaIfNEvoruUGqwXjErJTNxEYv/mU7tO6kUOMn9ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iQrno7Sg; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750729275; x=1782265275;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xTw8C4+9xWfpNpVUJzqazGEWhQRzloD/T24WRdD/EsM=;
  b=iQrno7SgEi8J/nwD7OC1hrHN2RecfAOv7ti7Ls22UZ/XGFrhFsLpUK8u
   xUuP9g9P+ges/mPU1KiJ+keyIx1g8VWlWweydO4xE4aLGNSkEo8Btrp/0
   1VI1zF2yt/y30vWl8hUXka8JdJio3BNccWFgyTzySxQPL5/+tojxIQyUy
   7LgPk/4cehJCWwWg73ok3RnlCb+T61dwfRtRfOGJA+S+INNIFQ9enWJvt
   NGgRQgM/WLvuxBdFY1SOrxYFc25SvBBaRvuctfJqFZOiyNKYi/yF8MiEY
   4gvQkz4/sYaEZbGv9owBgzH4pFEen7tmrCuVzWLZnAm/tVieD1bJyQy2M
   A==;
X-CSE-ConnectionGUID: j/aJpISrTLGedC1c3xaBVg==
X-CSE-MsgGUID: sRLVVrnGTp+g2DWEyi+Fdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11473"; a="78370852"
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="78370852"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 18:41:14 -0700
X-CSE-ConnectionGUID: g3d6drugTFOitUzpZgjjQA==
X-CSE-MsgGUID: lTRzyx2QRXWpUs4kfZb+Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,260,1744095600"; 
   d="scan'208";a="152274922"
Received: from unknown (HELO [10.238.128.162]) ([10.238.128.162])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 18:41:10 -0700
Message-ID: <c526eb25-571e-427a-93e9-3afdaa6ca413@linux.intel.com>
Date: Tue, 24 Jun 2025 09:41:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] x86/traps: Initialize DR7 by writing its
 architectural reset value
To: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
 sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
 fenghuay@nvidia.com
References: <20250620231504.2676902-1-xin@zytor.com>
 <20250620231504.2676902-3-xin@zytor.com>
From: Ethan Zhao <haifeng.zhao@linux.intel.com>
Autocrypt: addr=haifeng.zhao@linux.intel.com; keydata=
 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
 8TCx1OJHpvWFmL4Deq8=
In-Reply-To: <20250620231504.2676902-3-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/6/21 7:15, Xin Li (Intel) 写道:
> Initialize DR7 by writing its architectural reset value to always set
> bit 10, which is reserved to '1', when "clearing" DR7 so as not to
> trigger unanticipated behavior if said bit is ever unreserved, e.g. as
> a feature enabling flag with inverted polarity.
>
> Tested-by: Sohil Mehta <sohil.mehta@intel.com>
> Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Cc: stable@vger.kernel.org
> ---
>
> Change in v4:
> *) Cc stable for backporting, just in case bit 10 of DR7 has become
>     unreserved on new hardware, even though clearing it doesn't
>     currently cause any real issues (Dave Hansen).
>
> Changes in v3:
> *) Reword the changelog using Sean's description.
> *) Explain the definition of DR7_FIXED_1 (Sohil).
> *) Collect TB, RB, AB (PeterZ, Sohil and Sean).
>
> Changes in v2:
> *) Use debug register index 7 rather than DR_CONTROL (PeterZ and Sean).
> *) Use DR7_FIXED_1 as the architectural reset value of DR7 (Sean).
> ---
>   arch/x86/include/asm/debugreg.h | 19 +++++++++++++++----
>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kernel/cpu/common.c    |  2 +-
>   arch/x86/kernel/kgdb.c          |  2 +-
>   arch/x86/kernel/process_32.c    |  2 +-
>   arch/x86/kernel/process_64.c    |  2 +-
>   arch/x86/kvm/x86.c              |  4 ++--
>   7 files changed, 22 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
> index 363110e6b2e3..a2c1f2d24b64 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -9,6 +9,14 @@
>   #include <asm/cpufeature.h>
>   #include <asm/msr.h>
>   
> +/*
> + * Define bits that are always set to 1 in DR7, only bit 10 is
> + * architecturally reserved to '1'.
> + *
> + * This is also the init/reset value for DR7.
> + */
> +#define DR7_FIXED_1	0x00000400
> +
>   DECLARE_PER_CPU(unsigned long, cpu_dr7);
>   
>   #ifndef CONFIG_PARAVIRT_XXL
> @@ -100,8 +108,8 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
>   
>   static inline void hw_breakpoint_disable(void)
>   {
> -	/* Zero the control register for HW Breakpoint */
> -	set_debugreg(0UL, 7);
> +	/* Reset the control register for HW Breakpoint */
> +	set_debugreg(DR7_FIXED_1, 7);

Given you have it be adhere to SDM about the DR7 reversed bits setting,

then no reason to leave patch[1/2] to set_debugreg(0, 7) alone.

did I miss something here ?


Thanks,

Ethan


>   
>   	/* Zero-out the individual HW breakpoint address registers */
>   	set_debugreg(0UL, 0);
> @@ -125,9 +133,12 @@ static __always_inline unsigned long local_db_save(void)
>   		return 0;
>   
>   	get_debugreg(dr7, 7);
> -	dr7 &= ~0x400; /* architecturally set bit */
> +
> +	/* Architecturally set bit */
> +	dr7 &= ~DR7_FIXED_1;
>   	if (dr7)
> -		set_debugreg(0, 7);
> +		set_debugreg(DR7_FIXED_1, 7);
> +
>   	/*
>   	 * Ensure the compiler doesn't lower the above statements into
>   	 * the critical section; disabling breakpoints late would not
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b4a391929cdb..639d9bcee842 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -31,6 +31,7 @@
>   
>   #include <asm/apic.h>
>   #include <asm/pvclock-abi.h>
> +#include <asm/debugreg.h>
>   #include <asm/desc.h>
>   #include <asm/mtrr.h>
>   #include <asm/msr-index.h>
> @@ -249,7 +250,6 @@ enum x86_intercept_stage;
>   #define DR7_BP_EN_MASK	0x000000ff
>   #define DR7_GE		(1 << 9)
>   #define DR7_GD		(1 << 13)
> -#define DR7_FIXED_1	0x00000400
>   #define DR7_VOLATILE	0xffff2bff
>   
>   #define KVM_GUESTDBG_VALID_MASK \
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 0f6c280a94f0..27125e009847 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2246,7 +2246,7 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>   static void initialize_debug_regs(void)
>   {
>   	/* Control register first -- to make sure everything is disabled. */
> -	set_debugreg(0, 7);
> +	set_debugreg(DR7_FIXED_1, 7);
>   	set_debugreg(DR6_RESERVED, 6);
>   	/* dr5 and dr4 don't exist */
>   	set_debugreg(0, 3);
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index 102641fd2172..8b1a9733d13e 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -385,7 +385,7 @@ static void kgdb_disable_hw_debug(struct pt_regs *regs)
>   	struct perf_event *bp;
>   
>   	/* Disable hardware debugging while we are in kgdb: */
> -	set_debugreg(0UL, 7);
> +	set_debugreg(DR7_FIXED_1, 7);
>   	for (i = 0; i < HBP_NUM; i++) {
>   		if (!breakinfo[i].enabled)
>   			continue;
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index a10e180cbf23..3ef15c2f152f 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -93,7 +93,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
>   
>   	/* Only print out debug registers if they are in their non-default state. */
>   	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
> -	    (d6 == DR6_RESERVED) && (d7 == 0x400))
> +	    (d6 == DR6_RESERVED) && (d7 == DR7_FIXED_1))
>   		return;
>   
>   	printk("%sDR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index 8d6cf25127aa..b972bf72fb8b 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -133,7 +133,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
>   
>   	/* Only print out debug registers if they are in their non-default state. */
>   	if (!((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
> -	    (d6 == DR6_RESERVED) && (d7 == 0x400))) {
> +	    (d6 == DR6_RESERVED) && (d7 == DR7_FIXED_1))) {
>   		printk("%sDR0: %016lx DR1: %016lx DR2: %016lx\n",
>   		       log_lvl, d0, d1, d2);
>   		printk("%sDR3: %016lx DR6: %016lx DR7: %016lx\n",
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b58a74c1722d..a9d992d5652f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11035,7 +11035,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   
>   	if (unlikely(vcpu->arch.switch_db_regs &&
>   		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
> -		set_debugreg(0, 7);
> +		set_debugreg(DR7_FIXED_1, 7);
>   		set_debugreg(vcpu->arch.eff_db[0], 0);
>   		set_debugreg(vcpu->arch.eff_db[1], 1);
>   		set_debugreg(vcpu->arch.eff_db[2], 2);
> @@ -11044,7 +11044,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
>   			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
>   	} else if (unlikely(hw_breakpoint_active())) {
> -		set_debugreg(0, 7);
> +		set_debugreg(DR7_FIXED_1, 7);
>   	}
>   
>   	vcpu->arch.host_debugctl = get_debugctlmsr();

-- 
"firm, enduring, strong, and long-lived"



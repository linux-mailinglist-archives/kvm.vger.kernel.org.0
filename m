Return-Path: <kvm+bounces-58532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0B7B96291
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAE7B189BCF0
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A43CF22AE5D;
	Tue, 23 Sep 2025 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UUXXb9Sd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AFB2C18A;
	Tue, 23 Sep 2025 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758636785; cv=none; b=j5k/TPs9CHggHvVwUKFudGNqmypncrgkfcqlHy0Sv+INcDzC4gXZdtcbHurHaaDFnnp5ssYUaV2VE1x3PuEpSbc4xr89bZz8uDgM7DtsjvWMrttWCt/sOY87Rz/zSJvG5YyEuNgn2Y9hn1sONjOyPkzhnE0XfT53L84d4oHl3WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758636785; c=relaxed/simple;
	bh=hUTIfU8L5AUcG2pw9OBQy9QONqALNtj3I6ZR7ay12JA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxKBL7cWAKTYaffQSUOvU0xMmjG7aZvG/7YZSSEoULzcnQqg+sxSGdyIEGp9HHl9A25GaLUQWoOw1ZV6SStaoMp7gb+R/Okw5WdAouRV9zBbWE+vc3D0AzQUSIVpdjCzWsQMUfpqkHKGusInBO2ylZN75b9elYfrefTXUryDqo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UUXXb9Sd; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758636782; x=1790172782;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hUTIfU8L5AUcG2pw9OBQy9QONqALNtj3I6ZR7ay12JA=;
  b=UUXXb9Sd70zJC9nI3EwTeg3o5oLcPcuyHaMfcD/gYzRGeU5E4zrMXGLY
   V4FgmvFQVF9za/Wo+RvTIUHtxQHBcmLnxXP/46li+HQrOgRtebfmabspm
   UpUZSVai/Cs2JRSPjvg3J52t+aO10UxjY6MKhbU/980O482fKxbacYHtn
   vxRZ8JZ/Rf0dAssgKiOIcyn7I9vmP0SHWokqJ8FJ3jfW7/kEme2oRMa0S
   LppJK+L+jEYXZHIRg5srxHIMJ+cFCzspPq21s94z+wgZg87Ep2YLswtCE
   HRtou7CSdmUalme8fAhpY7tRx/iEvm/hIoevMmEtE4Ih9jnQUXcnHVD1F
   g==;
X-CSE-ConnectionGUID: qmMdGaZATTGQL5ixjNuQvQ==
X-CSE-MsgGUID: jeNs9YjYT0uB1PyVJ0bPHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61087386"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="61087386"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:13:01 -0700
X-CSE-ConnectionGUID: EF0SHR9YSqOb7GrucgJMAQ==
X-CSE-MsgGUID: 4KcYWrUfTGesRAGt0tWwFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="213919731"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:12:57 -0700
Message-ID: <287c2195-740c-4f2e-a545-c886962fc542@intel.com>
Date: Tue, 23 Sep 2025 22:12:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 18/51] KVM: x86: Don't emulate instructions affected
 by CET features
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-19-seanjc@google.com> <aNEkrlv1bdoRitoU@intel.com>
 <aNGrwzoYRC_a6d5D@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aNGrwzoYRC_a6d5D@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/2025 4:04 AM, Sean Christopherson wrote:
> From: Sean Christopherson<seanjc@google.com>
> Date: Fri, 19 Sep 2025 15:32:25 -0700
> Subject: [PATCH] KVM: x86: Don't emulate instructions affected by CET features
> 
> Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
> affected by Shadow Stacks and/or Indirect Branch Tracking when said
> features are enabled in the guest, as fully emulating CET would require
> significant complexity for no practical benefit (KVM shouldn't need to
> emulate branch instructions on modern hosts).  Simply doing nothing isn't
> an option as that would allow a malicious entity to subvert CET
> protections via the emulator.
> 
> To detect instructions that are subject to IBT or affect IBT state, use
> the existing IsBranch flag along with the source operand type to detect
> indirect branches, and the existing NearBranch flag to detect far JMPs
> and CALLs, all of which are effectively indirect.  Explicitly check for
> emulation of IRET, FAR RET (IMM), and SYSEXIT (the ret-like far branches)
> instead of adding another flag, e.g. IsRet, as it's unlikely the emulator
> will ever need to check for return-like instructions outside of this one
> specific flow.  Use an allow-list instead of a deny-list because (a) it's
> a shorter list and (b) so that a missed entry gets a false positive, not a
> false negative (i.e. reject emulation instead of clobbering CET state).
> 
> For Shadow Stacks, explicitly track instructions that directly affect the
> current SSP, as KVM's emulator doesn't have existing flags that can be
> used to precisely detect such instructions.  Alternatively, the em_xxx()
> helpers could directly check for ShadowStack interactions, but using a
> dedicated flag is arguably easier to audit, and allows for handling both
> IBT and SHSTK in one fell swoop.
> 
> Note!  On far transfers, do NOT consult the current privilege level and
> instead treat SHSTK/IBT as being enabled if they're enabled for User*or*
> Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
> can be in play for the target privilege level, i.e. checking the current
> privilege could get a false negative, and KVM doesn't know the target
> privilege level until emulation gets under way.
> 
> Note #2, FAR JMP from 64-bit mode to compatibility mode interacts with
> the current SSP, but only to ensure SSP[63:32] == 0.  Don't tag FAR JMP
> as SHSTK, which would be rather confusing and would result in FAR JMP
> being rejected unnecessarily the vast majority of the time (ignoring that
> it's unlikely to ever be emulated).  A future commit will add the #GP(0)
> check for the specific FAR JMP scenario.
> 
> Note #3, task switches also modify SSP and so need to be rejected.  That
> too will be addressed in a future commit.
> 
> Suggested-by: Chao Gao<chao.gao@intel.com>
> Originally-by: Yang Weijiang<weijiang.yang@intel.com>
> Cc: Mathias Krause<minipli@grsecurity.net>
> Cc: John Allen<john.allen@amd.com>
> Cc: Rick Edgecombe<rick.p.edgecombe@intel.com>
> Reviewed-by: Chao Gao<chao.gao@intel.com>
> Reviewed-by: Binbin Wu<binbin.wu@linux.intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Two nits besides,
> Link:https://lore.kernel.org/r/20250919223258.1604852-19-seanjc@google.com
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   arch/x86/kvm/emulate.c | 117 ++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 103 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 23929151a5b8..a7683dc18405 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -178,6 +178,7 @@
>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
> +#define ShadowStack ((u64)1 << 57)  /* Instruction affects Shadow Stacks. */
>   
>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>   
> @@ -4068,9 +4069,9 @@ static const struct opcode group4[] = {
>   static const struct opcode group5[] = {
>   	F(DstMem | SrcNone | Lock,		em_inc),
>   	F(DstMem | SrcNone | Lock,		em_dec),
> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
> +	I(SrcMem | NearBranch | IsBranch | ShadowStack, em_call_near_abs),
> +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack, em_call_far),
> +	I(SrcMem | NearBranch | IsBranch, em_jmp_abs),

The change of this line is unexpected, since it only changes the 
indentation of 'em_jmp_abs'
>   static unsigned imm_size(struct x86_emulate_ctxt *ctxt)
>   {
>   	unsigned size;
> @@ -4943,6 +4998,40 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   
>   	ctxt->execute = opcode.u.execute;
>   
> +	/*
> +	 * Reject emulation if KVM might need to emulate shadow stack updates
> +	 * and/or indirect branch tracking enforcement, which the emulator
> +	 * doesn't support.
> +	 */
> +	if ((is_ibt_instruction(ctxt) || is_shstk_instruction(ctxt)) &&
> +	    ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
> +		u64 u_cet = 0, s_cet = 0;
> +
> +		/*
> +		 * Check both User and Supervisor on far transfers as inter-
> +		 * privilege level transfers are impacted by CET at the target
> +		 * privilege level, and that is not known at this time.  The
> +		 * the expectation is that the guest will not require emulation

Dobule 'the'

> +		 * of any CET-affected instructions at any privilege level.
> +		 */
> +		if (!(ctxt->d & NearBranch))
> +			u_cet = s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
> +		else if (ctxt->ops->cpl(ctxt) == 3)
> +			u_cet = CET_SHSTK_EN | CET_ENDBR_EN;
> +		else
> +			s_cet = CET_SHSTK_EN | CET_ENDBR_EN;
> +
> +		if ((u_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_U_CET, &u_cet)) ||
> +		    (s_cet && ctxt->ops->get_msr(ctxt, MSR_IA32_S_CET, &s_cet)))
> +			return EMULATION_FAILED;
> +
> +		if ((u_cet | s_cet) & CET_SHSTK_EN && is_shstk_instruction(ctxt))
> +			return EMULATION_FAILED;
> +
> +		if ((u_cet | s_cet) & CET_ENDBR_EN && is_ibt_instruction(ctxt))
> +			return EMULATION_FAILED;
> +	}
> +
>   	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
>   	    likely(!(ctxt->d & EmulateOnUD)))
>   		return EMULATION_FAILED;
> 
> base-commit: 88539a6a25bc7a7ed96952775152e0c3331fdcaf



Return-Path: <kvm+bounces-57829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07D30B7D6DB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B8C31C05D50
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 08:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A0230BB8C;
	Wed, 17 Sep 2025 08:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RLWscEHa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0668303A39;
	Wed, 17 Sep 2025 08:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758098758; cv=none; b=WE//gmjGjdL5R+XIoRQZWWmKJoV9E2UDDY63s7Sle5r+I2beo/y0fP9uPgSMpym9FaOqlS5cbWcyzHnaAn5fpu9Vj6GmVklSkHC3othC8kO1I/CSutscLMYptggGAlPohvtw7PcdnHM1PbR/KGK4HyEqFyilLVgcjXJvkjChosA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758098758; c=relaxed/simple;
	bh=xarLFcXyydQ5ILVnCeJK6PKA/gvdUMhFl0C35luL524=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NKOCR3M5lCALPl5UWeBZAseHF/+V0FDwfD8EomYtIzSh/lT0MsZOxLVwASpm/aBOAxOG78BUPHnXfYAO3ogw7EDtoHfPQy7RNjv8c9iy08daEkpzRYNeHTTLdDcKYWY/fdlF1MUGucR3GPBdiVxkNrb6huHo+XE9PP8TEZSKw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RLWscEHa; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758098756; x=1789634756;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xarLFcXyydQ5ILVnCeJK6PKA/gvdUMhFl0C35luL524=;
  b=RLWscEHaulKlWwfWLCvCcwiNJv9R0+xKqbppCAqDPiIyxvLKl7PfQxw0
   2JT2wRgt3gL1XdDJwSmS73Vl1IKa/Ac0J0KPer26lLALRxHviMpJkAkwv
   GmZWe1cJ9WHA3nO18rSuB+N3j8ET5KvMeGHeUV9oRFlMW2OifAp2Ofbqs
   6BVLUOsA0SBLz15eTEiCmFPsoMnDRD8AM0XbKhWqYNTeB1TAie58thZnr
   jjOFAYhmh8IZNROFl8JjdiTXvKMmaDDwYyGwJcHIQ/XIs2au0xBB5zjBx
   mZSzFpX9OyQtofC5k+F+2RZTPCgdP6tGN/O2+eGutyFVWLmqvKJjFvP9P
   g==;
X-CSE-ConnectionGUID: ///ECKnLTpWaPhEI0vrGMQ==
X-CSE-MsgGUID: 5SkkVh1KTD6bl0TyMvc/gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="71023159"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="71023159"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:45:54 -0700
X-CSE-ConnectionGUID: ugKzPb4GSNC4ymPenkgTAw==
X-CSE-MsgGUID: ihfVchk5SZ2ibNh3GyyoPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="174988620"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 01:45:49 -0700
Message-ID: <819bd98b-2a60-4107-8e13-41f1e4c706b1@linux.intel.com>
Date: Wed, 17 Sep 2025 16:45:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 18/41] KVM: x86: Don't emulate instructions affected
 by CET features
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-19-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-19-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Don't emulate branch instructions, e.g. CALL/RET/JMP etc., that are
> affected by Shadow Stacks and/or Indirect Branch Tracking when said
> features are enabled in the guest, as fully emulating CET would require
> significant complexity for no practical benefit (KVM shouldn't need to
> emulate branch instructions on modern hosts).  Simply doing nothing isn't
> an option as that would allow a malicious entity to subvert CET
> protections via the emulator.
>
> Note!  On far transfers, do NOT consult the current privilege level and
> instead treat SHSTK/IBT as being enabled if they're enabled for User *or*
> Supervisor mode.  On inter-privilege level far transfers, SHSTK and IBT
> can be in play for the target privilege level, i.e. checking the current
> privilege could get a false negative, and KVM doesn't know the target
> privilege level until emulation gets under way.

About the emulator, there is a VMX exit reason EXIT_REASON_TASK_SWITCH.
The VM Exit triggers the following path:
EXIT_REASON_TASK_SWITCH
     handle_task_switch
         kvm_task_switch
             emulator_task_switch

According to SDM, in Vol 3 Chapter "Task Management", section "Executing a Task"
"If shadow stack is enabled, then the SSP of the task is located at the 4 bytes
  at offset 104 in the 32-bit TSS and is used by the processor to establish the
  SSP when a task switch occurs from a task associated with this TSS. Note that
  the processor does not write the SSP of the task initiating the task switch to
  the TSS of that task, and instead the SSP of the previous task is pushed onto
  the shadow stack of the new task."

This case is not covered, although using CET in 32-bit guests should be a corner
case.


>
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Cc: Mathias Krause <minipli@grsecurity.net>
> Cc: John Allen <john.allen@amd.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/emulate.c | 58 ++++++++++++++++++++++++++++++++++--------
>   1 file changed, 47 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 542d3664afa3..e4be54a677b0 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -178,6 +178,8 @@
>   #define IncSP       ((u64)1 << 54)  /* SP is incremented before ModRM calc */
>   #define TwoMemOp    ((u64)1 << 55)  /* Instruction has two memory operand */
>   #define IsBranch    ((u64)1 << 56)  /* Instruction is considered a branch. */
> +#define ShadowStack ((u64)1 << 57)  /* Instruction protected by Shadow Stack. */
> +#define IndirBrnTrk ((u64)1 << 58)  /* Instruction protected by IBT. */
>   
>   #define DstXacc     (DstAccLo | SrcAccHi | SrcWrite)
>   
> @@ -4068,9 +4070,9 @@ static const struct opcode group4[] = {
>   static const struct opcode group5[] = {
>   	F(DstMem | SrcNone | Lock,		em_inc),
>   	F(DstMem | SrcNone | Lock,		em_dec),
> -	I(SrcMem | NearBranch | IsBranch,       em_call_near_abs),
> -	I(SrcMemFAddr | ImplicitOps | IsBranch, em_call_far),
> -	I(SrcMem | NearBranch | IsBranch,       em_jmp_abs),
> +	I(SrcMem | NearBranch | IsBranch | ShadowStack | IndirBrnTrk, em_call_near_abs),
> +	I(SrcMemFAddr | ImplicitOps | IsBranch | ShadowStack | IndirBrnTrk, em_call_far),
> +	I(SrcMem | NearBranch | IsBranch | IndirBrnTrk, em_jmp_abs),
>   	I(SrcMemFAddr | ImplicitOps | IsBranch, em_jmp_far),
>   	I(SrcMem | Stack | TwoMemOp,		em_push), D(Undefined),
>   };
> @@ -4332,11 +4334,11 @@ static const struct opcode opcode_table[256] = {
>   	/* 0xC8 - 0xCF */
>   	I(Stack | SrcImmU16 | Src2ImmByte | IsBranch, em_enter),
>   	I(Stack | IsBranch, em_leave),
> -	I(ImplicitOps | SrcImmU16 | IsBranch, em_ret_far_imm),
> -	I(ImplicitOps | IsBranch, em_ret_far),
> -	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch, intn),
> +	I(ImplicitOps | SrcImmU16 | IsBranch | ShadowStack, em_ret_far_imm),
> +	I(ImplicitOps | IsBranch | ShadowStack, em_ret_far),
> +	D(ImplicitOps | IsBranch), DI(SrcImmByte | IsBranch | ShadowStack, intn),
>   	D(ImplicitOps | No64 | IsBranch),
> -	II(ImplicitOps | IsBranch, em_iret, iret),
> +	II(ImplicitOps | IsBranch | ShadowStack, em_iret, iret),
>   	/* 0xD0 - 0xD7 */
>   	G(Src2One | ByteOp, group2), G(Src2One, group2),
>   	G(Src2CL | ByteOp, group2), G(Src2CL, group2),
> @@ -4352,7 +4354,7 @@ static const struct opcode opcode_table[256] = {
>   	I2bvIP(SrcImmUByte | DstAcc, em_in,  in,  check_perm_in),
>   	I2bvIP(SrcAcc | DstImmUByte, em_out, out, check_perm_out),
>   	/* 0xE8 - 0xEF */
> -	I(SrcImm | NearBranch | IsBranch, em_call),
> +	I(SrcImm | NearBranch | IsBranch | ShadowStack, em_call),
>   	D(SrcImm | ImplicitOps | NearBranch | IsBranch),
>   	I(SrcImmFAddr | No64 | IsBranch, em_jmp_far),
>   	D(SrcImmByte | ImplicitOps | NearBranch | IsBranch),
> @@ -4371,7 +4373,7 @@ static const struct opcode opcode_table[256] = {
>   static const struct opcode twobyte_table[256] = {
>   	/* 0x00 - 0x0F */
>   	G(0, group6), GD(0, &group7), N, N,
> -	N, I(ImplicitOps | EmulateOnUD | IsBranch, em_syscall),
> +	N, I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk, em_syscall),
>   	II(ImplicitOps | Priv, em_clts, clts), N,
>   	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
>   	N, D(ImplicitOps | ModRM | SrcMem | NoAccess), N, N,
> @@ -4402,8 +4404,8 @@ static const struct opcode twobyte_table[256] = {
>   	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
>   	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
>   	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
> -	I(ImplicitOps | EmulateOnUD | IsBranch, em_sysenter),
> -	I(ImplicitOps | Priv | EmulateOnUD | IsBranch, em_sysexit),
> +	I(ImplicitOps | EmulateOnUD | IsBranch | ShadowStack | IndirBrnTrk, em_sysenter),
> +	I(ImplicitOps | Priv | EmulateOnUD | IsBranch | ShadowStack, em_sysexit),
>   	N, N,
>   	N, N, N, N, N, N, N, N,
>   	/* 0x40 - 0x4F */
> @@ -4941,6 +4943,40 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int
>   	if (ctxt->d == 0)
>   		return EMULATION_FAILED;
>   
> +	/*
> +	 * Reject emulation if KVM might need to emulate shadow stack updates
> +	 * and/or indirect branch tracking enforcement, which the emulator
> +	 * doesn't support.
> +	 */
> +	if (opcode.flags & (ShadowStack | IndirBrnTrk) &&
> +	    ctxt->ops->get_cr(ctxt, 4) & X86_CR4_CET) {
> +		u64 u_cet = 0, s_cet = 0;
> +
> +		/*
> +		 * Check both User and Supervisor on far transfers as inter-
> +		 * privilege level transfers are impacted by CET at the target
> +		 * privilege levels, and that is not known at this time.  The
> +		 * the expectation is that the guest will not require emulation
> +		 * of any CET-affected instructions at any privilege level.
> +		 */
> +		if (!(opcode.flags & NearBranch))
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
> +		if ((u_cet | s_cet) & CET_SHSTK_EN && opcode.flags & ShadowStack)
> +			return EMULATION_FAILED;
> +
> +		if ((u_cet | s_cet) & CET_ENDBR_EN && opcode.flags & IndirBrnTrk)
> +			return EMULATION_FAILED;
> +	}
> +
>   	ctxt->execute = opcode.u.execute;
>   
>   	if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&


